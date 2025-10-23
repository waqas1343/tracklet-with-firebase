import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../view/total_stock_screen.dart'; // For Tank model
import '../../../shared/widgets/custom_flushbar.dart';

class GasDeductionUtils {
  /// Deduct gas from tanks when an order is approved
  /// Returns true if successful, false if there's not enough gas
  static Future<bool> deductGasFromTanks({
    required BuildContext context,
    required double amountInTons, // Amount in tons from the order
    required String orderId, // For logging/tracking purposes
  }) async {
    try {
      // Get all tanks
      final QuerySnapshot tanksSnapshot = 
          await FirebaseFirestore.instance.collection('tanks').get();
      
      // Convert to list of Tank objects
      final List<Tank> tanks = tanksSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Tank(
          id: doc.id,
          name: data['tankName'] ?? '',
          capacity: (data['capacity'] ?? 0).toDouble(),
          currentGas: (data['currentGas'] ?? 0).toDouble(),
          frozenGas: (data['frozenGas'] ?? 0).toDouble(),
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
      
      // Sort tanks by available gas (descending) to use tanks with more gas first
      tanks.sort((a, b) => (b.currentGas).compareTo(a.currentGas));
      
      // Check if we have enough total gas
      final double totalAvailableGas = tanks.fold(
        0, 
        (sum, tank) => sum + tank.currentGas
      );
      
      if (totalAvailableGas < amountInTons) {
        // Not enough gas available
        CustomFlushbar.showError(
          context,
          message: 'Not enough gas available. Required: ${amountInTons.toStringAsFixed(2)} tons, Available: ${totalAvailableGas.toStringAsFixed(2)} tons',
        );
        return false;
      }
      
      // Deduct gas from tanks
      double remainingAmount = amountInTons;
      for (final tank in tanks) {
        if (remainingAmount <= 0) break;
        
        if (tank.currentGas > 0) {
          final double deductAmount = 
              remainingAmount < tank.currentGas ? remainingAmount : tank.currentGas;
          
          // Update the tank in Firestore
          await FirebaseFirestore.instance
              .collection('tanks')
              .doc(tank.id)
              .update({
            'currentGas': FieldValue.increment(-deductAmount),
          });
          
          remainingAmount -= deductAmount;
        }
      }
      
      // Show success message with details
      CustomFlushbar.showSuccess(
        context,
        message: 'Successfully deducted ${amountInTons.toStringAsFixed(2)} tons of gas from tanks',
      );
      
      return true;
    } catch (e) {
      // Log error (in a real app, you might want to use a proper logging service)
      CustomFlushbar.showError(
        context,
        message: 'Failed to deduct gas from tanks: $e',
      );
      return false;
    }
  }
  
  /// Get total available gas from all tanks
  static Future<double> getTotalAvailableGasInTons() async {
    try {
      final QuerySnapshot tanksSnapshot = 
          await FirebaseFirestore.instance.collection('tanks').get();
      
      double totalGas = 0;
      for (var doc in tanksSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final currentGas = (data['currentGas'] ?? 0).toDouble();
        final frozenGas = (data['frozenGas'] ?? 0).toDouble();
        totalGas += currentGas + frozenGas;
      }
      
      return totalGas;
    } catch (e) {
      return 0.0;
    }
  }
  
  /// Check if there's enough gas to fulfill an order
  static Future<bool> hasEnoughGasForOrder(double amountInTons) async {
    try {
      final double totalAvailableGas = await getTotalAvailableGasInTons();
      return totalAvailableGas >= amountInTons;
    } catch (e) {
      return false;
    }
  }
}