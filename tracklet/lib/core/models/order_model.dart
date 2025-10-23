import 'package:flutter/material.dart';

class OrderModel {
  final String id;
  final String distributorId;
  final String distributorName;
  final String plantId;
  final String plantName;
  final String plantAddress;
  final String plantContact;
  final double pricePerKg;
  final Map<String, int> quantities; // {"45.4": 3, "27.5": 2, etc.}
  final double totalKg;
  final double totalPrice;
  final double discountPerKg;
  final double finalPrice;
  final String? specialInstructions;
  final OrderStatus status;
  final String? driverName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deliveryDate;

  OrderModel({
    required this.id,
    required this.distributorId,
    required this.distributorName,
    required this.plantId,
    required this.plantName,
    required this.plantAddress,
    required this.plantContact,
    required this.pricePerKg,
    required this.quantities,
    required this.totalKg,
    required this.totalPrice,
    this.discountPerKg = 0.0,
    required this.finalPrice,
    this.specialInstructions,
    this.status = OrderStatus.pending,
    this.driverName,
    required this.createdAt,
    this.updatedAt,
    this.deliveryDate,
  });

  /// Create OrderModel from Firestore JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      distributorId: json['distributorId'] ?? '',
      distributorName: json['distributorName'] ?? '',
      plantId: json['plantId'] ?? '',
      plantName: json['plantName'] ?? '',
      plantAddress: json['plantAddress'] ?? '',
      plantContact: json['plantContact'] ?? '',
      pricePerKg: (json['pricePerKg'] ?? 0.0).toDouble(),
      quantities: Map<String, int>.from(json['quantities'] ?? {}),
      totalKg: (json['totalKg'] ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      discountPerKg: (json['discountPerKg'] ?? 0.0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0.0).toDouble(),
      specialInstructions: json['specialInstructions'],
      status: _parseOrderStatus(json['status']),
      driverName: json['driverName'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
    );
  }

  /// Convert OrderModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distributorId': distributorId,
      'distributorName': distributorName,
      'plantId': plantId,
      'plantName': plantName,
      'plantAddress': plantAddress,
      'plantContact': plantContact,
      'pricePerKg': pricePerKg,
      'quantities': quantities,
      'totalKg': totalKg,
      'totalPrice': totalPrice,
      'discountPerKg': discountPerKg,
      'finalPrice': finalPrice,
      'specialInstructions': specialInstructions,
      'status': status.toString().split('.').last,
      'driverName': driverName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  OrderModel copyWith({
    String? id,
    String? distributorId,
    String? distributorName,
    String? plantId,
    String? plantName,
    String? plantAddress,
    String? plantContact,
    double? pricePerKg,
    Map<String, int>? quantities,
    double? totalKg,
    double? totalPrice,
    double? discountPerKg,
    double? finalPrice,
    String? specialInstructions,
    OrderStatus? status,
    String? driverName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveryDate,
  }) {
    return OrderModel(
      id: id ?? this.id,
      distributorId: distributorId ?? this.distributorId,
      distributorName: distributorName ?? this.distributorName,
      plantId: plantId ?? this.plantId,
      plantName: plantName ?? this.plantName,
      plantAddress: plantAddress ?? this.plantAddress,
      plantContact: plantContact ?? this.plantContact,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      quantities: quantities ?? this.quantities,
      totalKg: totalKg ?? this.totalKg,
      totalPrice: totalPrice ?? this.totalPrice,
      discountPerKg: discountPerKg ?? this.discountPerKg,
      finalPrice: finalPrice ?? this.finalPrice,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      status: status ?? this.status,
      driverName: driverName ?? this.driverName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveryDate: deliveryDate ?? this.deliveryDate,
    );
  }

  static OrderStatus _parseOrderStatus(dynamic status) {
    if (status == null) return OrderStatus.pending;

    final statusString = status.toString().toLowerCase().trim();
    
    // Handle different possible formats for inProgress status
    if (statusString == 'in_progress' || 
        statusString == 'inprogress' || 
        statusString == 'in progress') {
      return OrderStatus.inProgress;
    }
    
    switch (statusString) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  /// Get formatted quantities for display
  List<String> get formattedQuantities {
    return quantities.entries
        .where((entry) => entry.value > 0)
        .map((entry) => '${entry.key} KG (${entry.value})')
        .toList();
  }

  /// Get status color for UI
  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.inProgress:
        return Colors.purple;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  /// Get status display text
  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

enum OrderStatus { pending, confirmed, inProgress, completed, cancelled }