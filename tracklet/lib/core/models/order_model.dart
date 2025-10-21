enum OrderStatus { pending, processing, completed, cancelled }

class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String? driverId;
  final String? driverName;
  final double quantity;
  final double pricePerUnit;
  final double totalPrice;
  final OrderStatus status;
  final String? deliveryAddress;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? notes;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.driverId,
    this.driverName,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalPrice,
    required this.status,
    this.deliveryAddress,
    required this.orderDate,
    this.deliveryDate,
    this.notes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      driverId: json['driverId'],
      driverName: json['driverName'],
      quantity: (json['quantity'] ?? 0).toDouble(),
      pricePerUnit: (json['pricePerUnit'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      deliveryAddress: json['deliveryAddress'],
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'driverId': driverId,
      'driverName': driverName,
      'quantity': quantity,
      'pricePerUnit': pricePerUnit,
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
      'deliveryAddress': deliveryAddress,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'notes': notes,
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? driverId,
    String? driverName,
    double? quantity,
    double? pricePerUnit,
    double? totalPrice,
    OrderStatus? status,
    String? deliveryAddress,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      quantity: quantity ?? this.quantity,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      notes: notes ?? this.notes,
    );
  }
}
