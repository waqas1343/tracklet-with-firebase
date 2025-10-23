// Users Provider - User management state
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class UsersProvider with ChangeNotifier {
  bool _isLoading = true;
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];
  String _searchQuery = '';
  int _currentPage = 0;
  int _usersPerPage = 10;
  UserModel? _selectedUser;

  final FirebaseService _firebaseService = FirebaseService();

  UsersProvider() {
    _loadUsers();
  }

  // Getters
  bool get isLoading => _isLoading;
  List<UserModel> get allUsers => _allUsers;
  List<UserModel> get filteredUsers => _filteredUsers;
  String get searchQuery => _searchQuery;
  int get currentPage => _currentPage;
  int get usersPerPage => _usersPerPage;
  int get totalPages => (_filteredUsers.length / _usersPerPage).ceil();
  UserModel? get selectedUser => _selectedUser;

  List<UserModel> get paginatedUsers {
    final start = _currentPage * _usersPerPage;
    final end = (start + _usersPerPage).clamp(0, _filteredUsers.length);
    return _filteredUsers.sublist(start, end);
  }

  // Load users from Firebase
  Future<void> _loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allUsers = await _firebaseService.getAllUsers();
      _filteredUsers = List.from(_allUsers);
    } catch (e) {
      // No fallback to sample data - show empty state
      _allUsers = [];
      _filteredUsers = [];
      print('Error loading users from Firebase: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Public method to refresh users
  Future<void> refreshUsers() async {
    await _loadUsers();
  }

  // Search users
  void searchUsers(String query) {
    _searchQuery = query;
    _currentPage = 0;

    if (query.isEmpty) {
      _filteredUsers = List.from(_allUsers);
    } else {
      _filteredUsers = _allUsers.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()) ||
            user.role.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  // Pagination
  void nextPage() {
    if (_currentPage < totalPages - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  // Select user for detail view
  void selectUser(UserModel user) {
    _selectedUser = user;
    notifyListeners();
  }

  void clearSelectedUser() {
    _selectedUser = null;
    notifyListeners();
  }

  // Create new user
  Future<Map<String, dynamic>> createUser({
    required String name,
    required String email,
    required String role,
    required String phone,
    String department = '',
  }) async {
    try {
      final result = await _firebaseService.createUser(
        name: name,
        email: email,
        role: role,
        phone: phone,
        department: department,
        defaultPassword: '123123', // Fixed password for all users
      );

      if (result['success']) {
        // Reload users to include the new one
        await _loadUsers();
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create user: ${e.toString()}',
      };
    }
  }

  // User actions
  Future<void> toggleUserStatus(String userId) async {
    final index = _allUsers.indexWhere((u) => u.id == userId);
    if (index != -1) {
      final user = _allUsers[index];
      final success = await _firebaseService.updateUserStatus(
        userId,
        !user.isActive,
      );

      if (success) {
        // Create updated user
        final updatedUser = UserModel(
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
          avatarUrl: user.avatarUrl,
          isActive: !user.isActive,
          createdAt: user.createdAt,
          lastLogin: user.lastLogin,
          department: user.department,
          phone: user.phone,
          defaultPassword: user.defaultPassword,
        );

        _allUsers[index] = updatedUser;
        searchUsers(_searchQuery); // Refresh filtered list
      }
    }
  }

  Future<void> deleteUser(String userId) async {
    final success = await _firebaseService.deleteUser(userId);
    if (success) {
      _allUsers.removeWhere((u) => u.id == userId);
      searchUsers(_searchQuery);
    }
  }
}
