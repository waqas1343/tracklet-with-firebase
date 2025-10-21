import 'package:flutter/foundation.dart';
import '../services/admin_service.dart';
import '../models/user_model.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _adminService;
  
  AdminProvider({required AdminService adminService}) : _adminService = adminService;

  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Create a new user
  Future<bool> createUser({
    required String email,
    required String role,
    String? companyName,
    String? address,
    String? name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _adminService.createUser(
        email: email,
        role: role,
        companyName: companyName,
        address: address,
        name: name,
      );
      
      if (success) {
        // Refresh the user list
        await fetchAllUsers();
      }
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Failed to create user: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fetch all users
  Future<void> fetchAllUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _adminService.getAllUsers();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch users: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user role
  Future<bool> updateUserRole(String userId, String newRole) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _adminService.updateUserRole(userId, newRole);
      
      if (success) {
        // Refresh the user list
        await fetchAllUsers();
      }
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Failed to update user role: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _adminService.deleteUser(userId);
      
      if (success) {
        // Refresh the user list
        await fetchAllUsers();
      }
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Failed to delete user: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}