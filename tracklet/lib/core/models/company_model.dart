/// Company Model - Represents a gas plant company
class CompanyModel {
  final String id;
  final String companyName;
  final String contactNumber;
  final String address;
  final String operatingHours;
  final String? imageUrl;
  final String? ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CompanyModel({
    required this.id,
    required this.companyName,
    required this.contactNumber,
    required this.address,
    required this.operatingHours,
    this.imageUrl,
    this.ownerId,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create CompanyModel from Firestore JSON
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      contactNumber: json['contactNumber'] ?? json['phone'] ?? '',
      address: json['address'] ?? '',
      operatingHours: json['operatingHours'] ?? '8:00 AM - 6:00 PM',
      imageUrl: json['imageUrl'],
      ownerId: json['ownerId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  /// Convert CompanyModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'contactNumber': contactNumber,
      'address': address,
      'operatingHours': operatingHours,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  CompanyModel copyWith({
    String? id,
    String? companyName,
    String? contactNumber,
    String? address,
    String? operatingHours,
    String? imageUrl,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      operatingHours: operatingHours ?? this.operatingHours,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
