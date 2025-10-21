enum DriverStatus { available, busy, offline }

class DriverModel {
  final String id;
  final String name;
  final String phone;
  final String licenseNumber;
  final String vehicleNumber;
  final DriverStatus status;
  final double? currentLatitude;
  final double? currentLongitude;
  final int completedDeliveries;
  final DateTime joinedDate;
  final bool isActive;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.licenseNumber,
    required this.vehicleNumber,
    required this.status,
    this.currentLatitude,
    this.currentLongitude,
    required this.completedDeliveries,
    required this.joinedDate,
    required this.isActive,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      status: DriverStatus.values.firstWhere(
        (e) => e.toString() == 'DriverStatus.${json['status']}',
        orElse: () => DriverStatus.offline,
      ),
      currentLatitude: json['currentLatitude']?.toDouble(),
      currentLongitude: json['currentLongitude']?.toDouble(),
      completedDeliveries: json['completedDeliveries'] ?? 0,
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'licenseNumber': licenseNumber,
      'vehicleNumber': vehicleNumber,
      'status': status.toString().split('.').last,
      'currentLatitude': currentLatitude,
      'currentLongitude': currentLongitude,
      'completedDeliveries': completedDeliveries,
      'joinedDate': joinedDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  DriverModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? licenseNumber,
    String? vehicleNumber,
    DriverStatus? status,
    double? currentLatitude,
    double? currentLongitude,
    int? completedDeliveries,
    DateTime? joinedDate,
    bool? isActive,
  }) {
    return DriverModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      status: status ?? this.status,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      completedDeliveries: completedDeliveries ?? this.completedDeliveries,
      joinedDate: joinedDate ?? this.joinedDate,
      isActive: isActive ?? this.isActive,
    );
  }
}
