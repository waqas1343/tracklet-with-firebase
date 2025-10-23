// User Model
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final String department;
  final String phone;
  final bool defaultPassword;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.isActive,
    required this.createdAt,
    this.lastLogin,
    required this.department,
    required this.phone,
    this.defaultPassword = false,
  });

  // Create UserModel from Firestore data
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    // Handle both Timestamp and String formats for createdAt
    DateTime createdAt;
    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    } else if (data['createdAt'] is String) {
      createdAt = DateTime.parse(data['createdAt']);
    } else {
      createdAt = DateTime.now();
    }

    // Handle both Timestamp and String formats for lastLogin
    DateTime? lastLogin;
    if (data['lastLogin'] is Timestamp) {
      lastLogin = (data['lastLogin'] as Timestamp).toDate();
    } else if (data['lastLogin'] is String) {
      lastLogin = DateTime.parse(data['lastLogin']);
    }

    return UserModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: createdAt,
      lastLogin: lastLogin,
      department: data['department'] ?? '',
      phone: data['phone'] ?? '',
      defaultPassword: data['defaultPassword'] ?? false,
    );
  }

  // Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'isActive': isActive,
      'createdAt': createdAt
          .toIso8601String(), // Use string format for Tracklet compatibility
      'lastLogin': lastLogin?.toIso8601String(),
      'department': department,
      'phone': phone,
      'defaultPassword': defaultPassword,
    };
  }

  // Fake data generator
  static List<UserModel> generateSampleUsers(int count) {
    final roles = ['Admin', 'Manager', 'Developer', 'Designer', 'Analyst'];
    final departments = ['Engineering', 'Marketing', 'Sales', 'HR', 'Finance'];
    final names = [
      'Ahmed Khan',
      'Sara Ali',
      'Hassan Raza',
      'Fatima Sheikh',
      'Usman Malik',
      'Ayesha Ahmed',
      'Bilal Hussain',
      'Zainab Tariq',
      'Imran Farooq',
      'Mariam Akram',
      'Kamran Yousaf',
      'Nida Jamil',
      'Faisal Zahid',
      'Hina Aslam',
      'Asad Mehmood',
      'Rabia Nawaz',
    ];

    return List.generate(count, (index) {
      final name = names[index % names.length];
      final email = '${name.toLowerCase().replaceAll(' ', '.')}@company.com';

      return UserModel(
        id: 'user_${index + 1}',
        name: name,
        email: email,
        role: roles[index % roles.length],
        avatarUrl: '', // Remove network images to avoid loading errors
        isActive: index % 5 != 0, // 80% active
        createdAt: DateTime.now().subtract(Duration(days: index * 10)),
        lastLogin: DateTime.now().subtract(Duration(hours: index * 3)),
        department: departments[index % departments.length],
        phone: '+92 300 ${1000000 + index}',
      );
    });
  }
}
