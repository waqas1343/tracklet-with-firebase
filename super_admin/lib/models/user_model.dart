// User Model
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String department;
  final String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.isActive,
    required this.createdAt,
    required this.lastLogin,
    required this.department,
    required this.phone,
  });

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
      final email = name.toLowerCase().replaceAll(' ', '.') + '@company.com';

      return UserModel(
        id: 'user_${index + 1}',
        name: name,
        email: email,
        role: roles[index % roles.length],
        avatarUrl: 'https://i.pravatar.cc/150?img=${index + 1}',
        isActive: index % 5 != 0, // 80% active
        createdAt: DateTime.now().subtract(Duration(days: index * 10)),
        lastLogin: DateTime.now().subtract(Duration(hours: index * 3)),
        department: departments[index % departments.length],
        phone: '+92 300 ${1000000 + index}',
      );
    });
  }
}
