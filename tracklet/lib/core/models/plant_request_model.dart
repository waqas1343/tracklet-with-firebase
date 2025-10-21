enum PlantRequestStatus { pending, approved, rejected, completed }

enum CylinderType { small, medium, large }

class PlantRequestModel {
  final String id;
  final String distributorId;
  final String distributorName;
  final CylinderType cylinderType;
  final int quantity;
  final PlantRequestStatus status;
  final DateTime requestDate;
  final DateTime? approvedDate;
  final DateTime? completedDate;
  final String? notes;
  final String? rejectionReason;
  final String? plantAdminId;
  final String? plantAdminName;

  PlantRequestModel({
    required this.id,
    required this.distributorId,
    required this.distributorName,
    required this.cylinderType,
    required this.quantity,
    required this.status,
    required this.requestDate,
    this.approvedDate,
    this.completedDate,
    this.notes,
    this.rejectionReason,
    this.plantAdminId,
    this.plantAdminName,
  });

  factory PlantRequestModel.fromJson(Map<String, dynamic> json) {
    return PlantRequestModel(
      id: json['id'] ?? '',
      distributorId: json['distributorId'] ?? '',
      distributorName: json['distributorName'] ?? '',
      cylinderType: CylinderType.values.firstWhere(
        (e) => e.toString() == 'CylinderType.${json['cylinderType']}',
        orElse: () => CylinderType.medium,
      ),
      quantity: json['quantity'] ?? 0,
      status: PlantRequestStatus.values.firstWhere(
        (e) => e.toString() == 'PlantRequestStatus.${json['status']}',
        orElse: () => PlantRequestStatus.pending,
      ),
      requestDate: json['requestDate'] != null
          ? DateTime.parse(json['requestDate'])
          : DateTime.now(),
      approvedDate: json['approvedDate'] != null
          ? DateTime.parse(json['approvedDate'])
          : null,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
      notes: json['notes'],
      rejectionReason: json['rejectionReason'],
      plantAdminId: json['plantAdminId'],
      plantAdminName: json['plantAdminName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distributorId': distributorId,
      'distributorName': distributorName,
      'cylinderType': cylinderType.toString().split('.').last,
      'quantity': quantity,
      'status': status.toString().split('.').last,
      'requestDate': requestDate.toIso8601String(),
      'approvedDate': approvedDate?.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'notes': notes,
      'rejectionReason': rejectionReason,
      'plantAdminId': plantAdminId,
      'plantAdminName': plantAdminName,
    };
  }

  PlantRequestModel copyWith({
    String? id,
    String? distributorId,
    String? distributorName,
    CylinderType? cylinderType,
    int? quantity,
    PlantRequestStatus? status,
    DateTime? requestDate,
    DateTime? approvedDate,
    DateTime? completedDate,
    String? notes,
    String? rejectionReason,
    String? plantAdminId,
    String? plantAdminName,
  }) {
    return PlantRequestModel(
      id: id ?? this.id,
      distributorId: distributorId ?? this.distributorId,
      distributorName: distributorName ?? this.distributorName,
      cylinderType: cylinderType ?? this.cylinderType,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      requestDate: requestDate ?? this.requestDate,
      approvedDate: approvedDate ?? this.approvedDate,
      completedDate: completedDate ?? this.completedDate,
      notes: notes ?? this.notes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      plantAdminId: plantAdminId ?? this.plantAdminId,
      plantAdminName: plantAdminName ?? this.plantAdminName,
    );
  }

  String get cylinderTypeDisplay {
    switch (cylinderType) {
      case CylinderType.small:
        return 'Small (5kg)';
      case CylinderType.medium:
        return 'Medium (11kg)';
      case CylinderType.large:
        return 'Large (45kg)';
    }
  }

  String get statusDisplay {
    switch (status) {
      case PlantRequestStatus.pending:
        return 'Pending';
      case PlantRequestStatus.approved:
        return 'Approved';
      case PlantRequestStatus.rejected:
        return 'Rejected';
      case PlantRequestStatus.completed:
        return 'Completed';
    }
  }
}
