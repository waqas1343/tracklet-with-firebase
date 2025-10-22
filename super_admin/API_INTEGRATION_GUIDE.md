# API Integration Guide

How to connect the Super Admin dashboard to a real backend API.

## 🎯 Overview

Currently, the dashboard uses fake data generators. This guide shows how to replace them with real API calls.

## 📁 Recommended Structure

```
lib/
├── core/
│   ├── api/
│   │   ├── api_client.dart        # HTTP client setup
│   │   └── api_endpoints.dart     # API URLs
│   ├── models/                     # Already exists
│   └── repositories/
│       ├── user_repository.dart
│       ├── dashboard_repository.dart
│       └── settings_repository.dart
└── providers/                      # Update to use repositories
```

## 📦 Required Packages

Add to `pubspec.yaml`:
```yaml
dependencies:
  dio: ^5.4.0              # HTTP client
  retrofit: ^4.0.3         # Type-safe API calls
  json_annotation: ^4.8.1  # JSON serialization

dev_dependencies:
  build_runner: ^2.4.7
  retrofit_generator: ^8.0.6
  json_serializable: ^6.7.1
```

## 🔧 Step 1: Create API Client

```dart
// lib/core/api/api_client.dart
import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  late Dio dio;
  
  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://your-api.com/api/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // Add interceptors
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token
          final token = getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle errors globally
          if (error.response?.statusCode == 401) {
            // Handle unauthorized
            logout();
          }
          handler.next(error);
        },
      ),
    );
  }
  
  String? getAuthToken() {
    // Get from secure storage
    return null; // Implement this
  }
  
  void logout() {
    // Implement logout
  }
}
```

## 🔧 Step 2: Define API Endpoints

```dart
// lib/core/api/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'https://your-api.com/api/v1';
  
  // Dashboard
  static const String dashboardMetrics = '/dashboard/metrics';
  static const String recentActivity = '/dashboard/activity';
  
  // Users
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static const String searchUsers = '/users/search';
  
  // Settings
  static const String settings = '/settings';
}
```

## 🔧 Step 3: Update Models for Serialization

```dart
// lib/models/user_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart'; // Generated file

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'last_login')
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

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
```

Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🔧 Step 4: Create Repositories

```dart
// lib/core/repositories/user_repository.dart
import 'package:dio/dio.dart';
import '../../models/user_model.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class UserRepository {
  final Dio _dio = ApiClient().dio;

  Future<List<UserModel>> getUsers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.users,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final List<dynamic> data = response.data['users'];
      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.userById(id));
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _dio.put(
        ApiEndpoints.userById(user.id),
        data: user.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _dio.delete(ApiEndpoints.userById(id));
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<void> toggleUserStatus(String id, bool isActive) async {
    try {
      await _dio.patch(
        ApiEndpoints.userById(id),
        data: {'is_active': isActive},
      );
    } catch (e) {
      throw Exception('Failed to toggle user status: $e');
    }
  }
}
```

## 🔧 Step 5: Update Providers to Use Repositories

```dart
// lib/providers/users_provider.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/repositories/user_repository.dart';

class UsersProvider with ChangeNotifier {
  final UserRepository _repository = UserRepository();
  
  bool _isLoading = false;
  List<UserModel> _users = [];
  String _searchQuery = '';
  int _currentPage = 1;
  int _totalPages = 1;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<UserModel> get users => _users;
  String get searchQuery => _searchQuery;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  String? get errorMessage => _errorMessage;

  // Load users from API
  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _repository.getUsers(
        page: _currentPage,
        limit: 10,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Search users
  Future<void> searchUsers(String query) async {
    _searchQuery = query;
    _currentPage = 1;
    await loadUsers();
  }

  // Pagination
  Future<void> nextPage() async {
    if (_currentPage < _totalPages) {
      _currentPage++;
      await loadUsers();
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) {
      _currentPage--;
      await loadUsers();
    }
  }

  // Toggle user status
  Future<void> toggleUserStatus(String userId) async {
    try {
      final user = _users.firstWhere((u) => u.id == userId);
      await _repository.toggleUserStatus(userId, !user.isActive);
      await loadUsers(); // Reload to get updated data
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _repository.deleteUser(userId);
      await loadUsers(); // Reload to get updated list
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
```

## 🔧 Step 6: Handle Loading & Error States in UI

```dart
// Example in users_screen.dart
class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    
    // Handle error state
    if (usersProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Error: ${usersProvider.errorMessage}',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => usersProvider.loadUsers(),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    // Rest of your UI code...
  }
}
```

## 🔐 Step 7: Authentication Integration

```dart
// lib/core/repositories/auth_repository.dart
class AuthRepository {
  final Dio _dio = ApiClient().dio;
  
  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      final token = response.data['token'];
      await saveToken(token);
      return token;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
  
  Future<void> saveToken(String token) async {
    // Save to secure storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
```

## 📊 Step 8: Dashboard Repository

```dart
// lib/core/repositories/dashboard_repository.dart
class DashboardRepository {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> getMetrics() async {
    try {
      final response = await _dio.get(ApiEndpoints.dashboardMetrics);
      return response.data;
    } catch (e) {
      throw Exception('Failed to load metrics: $e');
    }
  }

  Future<List<ActivityModel>> getRecentActivity({int limit = 20}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.recentActivity,
        queryParameters: {'limit': limit},
      );
      
      final List<dynamic> data = response.data['activities'];
      return data.map((json) => ActivityModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load activity: $e');
    }
  }
}
```

## 🔄 Step 9: Update Dashboard Provider

```dart
// lib/providers/dashboard_provider.dart
class DashboardProvider with ChangeNotifier {
  final DashboardRepository _repository = DashboardRepository();
  
  bool _isLoading = true;
  int _totalUsers = 0;
  int _activeUsers = 0;
  int _totalRevenue = 0;
  int _pendingTasks = 0;
  List<ActivityModel> _recentActivities = [];
  String? _errorMessage;

  // Load dashboard data from API
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final metrics = await _repository.getMetrics();
      final activities = await _repository.getRecentActivity();

      _totalUsers = metrics['total_users'];
      _activeUsers = metrics['active_users'];
      _totalRevenue = metrics['total_revenue'];
      _pendingTasks = metrics['pending_tasks'];
      _recentActivities = activities;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }
}
```

## 🧪 Testing API Integration

```dart
// test/repositories/user_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

void main() {
  group('UserRepository Tests', () {
    test('getUsers returns list of users', () async {
      // Mock Dio client
      final mockDio = MockDio();
      
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
        .thenAnswer((_) async => Response(
          data: {
            'users': [
              {'id': '1', 'name': 'Test User', ...},
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

      final repository = UserRepository();
      final users = await repository.getUsers();
      
      expect(users.length, 1);
      expect(users.first.name, 'Test User');
    });
  });
}
```

## 📝 Environment Variables

Create `.env` file:
```
API_BASE_URL=https://your-api.com/api/v1
API_TIMEOUT=30000
```

Use with `flutter_dotenv`:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

Load in main:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}
```

## ✅ Checklist

- [ ] Install required packages
- [ ] Create API client with interceptors
- [ ] Define API endpoints
- [ ] Update models with JSON serialization
- [ ] Create repositories for each feature
- [ ] Update providers to use repositories
- [ ] Handle loading and error states in UI
- [ ] Implement authentication
- [ ] Add environment variables
- [ ] Write tests for repositories
- [ ] Test with real API

## 🚀 Next Steps

1. Replace fake data generators with repository calls
2. Add error handling and retry logic
3. Implement pagination on backend
4. Add caching layer (optional)
5. Implement real-time updates (WebSocket/FCM)

---

**Note**: This guide assumes a REST API. Adapt for GraphQL, gRPC, or other protocols as needed.

