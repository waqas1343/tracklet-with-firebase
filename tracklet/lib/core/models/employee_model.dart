enum EmployeeStatus { active, onLeave, terminated }

class Employee {
  final String id;
  final String name;
  final String position;
  final String status;
  final String department;
  final String contact;
  final String joinDate;
  final String profileImage;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.status,
    required this.department,
    required this.contact,
    required this.joinDate,
    required this.profileImage,
  });

  // Factory constructor to create an Employee from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      position: json['position'] as String,
      status: json['status'] as String,
      department: json['department'] as String,
      contact: json['contact'] as String,
      joinDate: json['joinDate'] as String,
      profileImage: json['profileImage'] as String,
    );
  }

  // Method to convert an Employee to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'status': status,
      'department': department,
      'contact': contact,
      'joinDate': joinDate,
      'profileImage': profileImage,
    };
  }
}

class EmployeeModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String department;
  final DateTime joiningDate;
  final double salary;
  final EmployeeStatus status;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.joiningDate,
    required this.salary,
    required this.status,
  });

  // CopyWith method for updating employee
  EmployeeModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? department,
    DateTime? joiningDate,
    double? salary,
    EmployeeStatus? status,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      department: department ?? this.department,
      joiningDate: joiningDate ?? this.joiningDate,
      salary: salary ?? this.salary,
      status: status ?? this.status,
    );
  }

  // Factory constructor to create an EmployeeModel from JSON
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      department: json['department'] as String,
      joiningDate: DateTime.parse(json['joiningDate'] as String),
      salary: (json['salary'] as num).toDouble(),
      status: EmployeeStatus.values.firstWhere(
        (e) => e.toString() == 'EmployeeStatus.${json['status']}',
        orElse: () => EmployeeStatus.active,
      ),
    );
  }

  // Method to convert an EmployeeModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'department': department,
      'joiningDate': joiningDate.toIso8601String(),
      'salary': salary,
      'status': status.toString().split('.').last,
    };
  }
}
