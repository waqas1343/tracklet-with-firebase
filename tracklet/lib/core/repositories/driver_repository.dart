import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/driver_model.dart';

/// DriverRepository - Handles all Firestore operations for drivers
class DriverRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _driversCollection = 'drivers';

  /// Get all drivers from Firestore
  Future<List<DriverModel>> getAllDrivers() async {
    try {
      final querySnapshot = await _firestore
          .collection(_driversCollection)
          .orderBy('joinedDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DriverModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch drivers: $e');
    }
  }

  /// Get a single driver by ID
  Future<DriverModel?> getDriverById(String driverId) async {
    try {
      final docSnapshot = await _firestore
          .collection(_driversCollection)
          .doc(driverId)
          .get();

      if (!docSnapshot.exists) {
        return null;
      }

      return DriverModel.fromJson({
        ...docSnapshot.data()!,
        'id': docSnapshot.id,
      });
    } catch (e) {
      throw Exception('Failed to fetch driver: $e');
    }
  }

  /// Get drivers stream for real-time updates
  Stream<List<DriverModel>> getDriversStream() {
    return _firestore
        .collection(_driversCollection)
        .orderBy('joinedDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => DriverModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList();
        });
  }

  /// Create or update a driver
  Future<bool> saveDriver(DriverModel driver) async {
    try {
      await _firestore
          .collection(_driversCollection)
          .doc(driver.id)
          .set(driver.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      throw Exception('Failed to save driver: $e');
    }
  }

  /// Delete a driver
  Future<bool> deleteDriver(String driverId) async {
    try {
      await _firestore.collection(_driversCollection).doc(driverId).delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete driver: $e');
    }
  }

  /// Get drivers by status
  Future<List<DriverModel>> getDriversByStatus(DriverStatus status) async {
    try {
      final querySnapshot = await _firestore
          .collection(_driversCollection)
          .where('status', isEqualTo: status.toString().split('.').last)
          .orderBy('joinedDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DriverModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch drivers by status: $e');
    }
  }

  /// Get active drivers
  Future<List<DriverModel>> getActiveDrivers() async {
    try {
      final querySnapshot = await _firestore
          .collection(_driversCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('joinedDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DriverModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch active drivers: $e');
    }
  }
}