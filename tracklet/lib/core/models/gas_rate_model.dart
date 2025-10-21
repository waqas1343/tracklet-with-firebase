class GasRateModel {
  final String id;
  final double pricePerUnit;
  final DateTime effectiveDate;
  final String? notes;
  final bool isActive;
  final String updatedBy;
  final DateTime createdAt;

  GasRateModel({
    required this.id,
    required this.pricePerUnit,
    required this.effectiveDate,
    this.notes,
    required this.isActive,
    required this.updatedBy,
    required this.createdAt,
  });

  factory GasRateModel.fromJson(Map<String, dynamic> json) {
    return GasRateModel(
      id: json['id'] ?? '',
      pricePerUnit: (json['pricePerUnit'] ?? 0).toDouble(),
      effectiveDate: json['effectiveDate'] != null
          ? DateTime.parse(json['effectiveDate'])
          : DateTime.now(),
      notes: json['notes'],
      isActive: json['isActive'] ?? false,
      updatedBy: json['updatedBy'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pricePerUnit': pricePerUnit,
      'effectiveDate': effectiveDate.toIso8601String(),
      'notes': notes,
      'isActive': isActive,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  GasRateModel copyWith({
    String? id,
    double? pricePerUnit,
    DateTime? effectiveDate,
    String? notes,
    bool? isActive,
    String? updatedBy,
    DateTime? createdAt,
  }) {
    return GasRateModel(
      id: id ?? this.id,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
