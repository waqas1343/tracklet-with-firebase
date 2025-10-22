// Users Provider - User management state
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UsersProvider with ChangeNotifier {
  bool _isLoading = true;
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];
  String _searchQuery = '';
  int _currentPage = 0;
  int _usersPerPage = 10;
  UserModel? _selectedUser;

  UsersProvider() {
    _loadUsers();
  }

  // Getters
  bool get isLoading => _isLoading;
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

  // Load users
  Future<void> _loadUsers() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _allUsers = UserModel.generateSampleUsers(50);
    _filteredUsers = List.from(_allUsers);

    _isLoading = false;
    notifyListeners();
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

  // User actions
  Future<void> toggleUserStatus(String userId) async {
    final index = _allUsers.indexWhere((u) => u.id == userId);
    if (index != -1) {
      // In real app, make API call here
      await Future.delayed(const Duration(milliseconds: 300));

      // Create updated user
      final user = _allUsers[index];
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
      );

      _allUsers[index] = updatedUser;
      searchUsers(_searchQuery); // Refresh filtered list
    }
  }

  Future<void> deleteUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _allUsers.removeWhere((u) => u.id == userId);
    searchUsers(_searchQuery);
  }

  // Refresh
  Future<void> refreshUsers() async {
    await _loadUsers();
  }
}
