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
}