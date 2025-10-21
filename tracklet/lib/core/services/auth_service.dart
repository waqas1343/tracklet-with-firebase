import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final token = response['token'] as String;
      final userData = response['user'] as Map<String, dynamic>;

      await _storageService.saveToken(token);
      await _storageService.saveUserData(userData);
      _apiService.setAuthToken(token);

      return UserModel.fromJson(userData);
    } catch (e) {
      throw AuthException('Login failed: $e');
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required UserRole role,
    String? companyName,
    String? address,
  }) async {
    try {
      final response = await _apiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': role.toString().split('.').last,
        'companyName': companyName,
        'address': address,
      });

      final token = response['token'] as String;
      final userData = response['user'] as Map<String, dynamic>;

      await _storageService.saveToken(token);
      await _storageService.saveUserData(userData);
      _apiService.setAuthToken(token);

      return UserModel.fromJson(userData);
    } catch (e) {
      throw AuthException('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      // Optional: Call logout endpoint
      // await _apiService.post('/auth/logout', {});

      await _storageService.removeToken();
      await _storageService.removeUserData();
      _apiService.clearAuthToken();
    } catch (e) {
      throw AuthException('Logout failed: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final userData = _storageService.getUserData();
      if (userData != null) {
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = _storageService.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> updateProfile(UserModel user) async {
    try {
      final response = await _apiService.put('/auth/profile', user.toJson());
      final userData = response['user'] as Map<String, dynamic>;
      await _storageService.saveUserData(userData);
    } catch (e) {
      throw AuthException('Profile update failed: $e');
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _apiService.post('/auth/change-password', {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });
    } catch (e) {
      throw AuthException('Password change failed: $e');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _apiService.post('/auth/forgot-password', {'email': email});
    } catch (e) {
      throw AuthException('Password reset request failed: $e');
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
