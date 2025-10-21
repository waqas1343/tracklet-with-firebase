class UserRole {
  static const String distributor = 'distributor';
  static const String gasPlant = 'gas_plant';
  static const String admin = 'admin';
}

class UserModel {
  final String id;
  final String email;
  final String role;
  final String? companyName;
  final String? address;
  final String? name;
  final DateTime createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.companyName,
    this.address,
    this.name,
    required this.createdAt,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? UserRole.distributor,
      companyName: json['companyName'],
      address: json['address'],
      name: json['name'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'companyName': companyName,
      'address': address,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? role,
    String? companyName,
    String? address,
    String? name,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      companyName: companyName ?? this.companyName,
      address: address ?? this.address,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}