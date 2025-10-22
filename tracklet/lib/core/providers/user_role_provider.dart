import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class UserRoleProvider extends ChangeNotifier {
  final StorageService _storageService;

  UserRole _currentRole = UserRole.distributor;
  bool _isLoading = false;
  String? _errorMessage;

  UserRoleProvider({required StorageService storageService})
    : _storageService = storageService {
    _loadUserRole();
  }

  UserRole get currentRole => _currentRole;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isGasPlant => _currentRole == UserRole.gasPlant;

  bool get isDistributor => _currentRole == UserRole.distributor;

  Future<void> _loadUserRole() async {
    _setLoading(true);
    try {
      final roleString = _storageService.getString('user_role');
      if (roleString != null) {
        _currentRole = UserRole.values.firstWhere(
          (role) => role.toString().split('.').last == roleString,
          orElse: () => UserRole.distributor,
        );
      }
    } catch (e) {
      _setError('Failed to load user role: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setUserRole(UserRole role) async {
    _setLoading(true);
    try {
      
      if (_currentRole != role) {
      }
      
      _currentRole = role;
      final roleString = role.toString().split('.').last;
      await _storageService.setString('user_role', roleString);
      notifyListeners();
    } catch (e) {
      _setError('Failed to save user role: $e');
    } finally {
      _setLoading(false);
    }
  }
  String get dashboardRoute {
    switch (_currentRole) {
      case UserRole.gasPlant:
        return '/gas-plant/dashboard';
      case UserRole.distributor:
        return '/distributor/dashboard';
    }
  }
  List<NavigationTab> get navigationTabs {
    switch (_currentRole) {
      case UserRole.gasPlant:
        return [
          NavigationTab(
            icon: Icons.home,
            title: 'Home',
            route: '/gas-plant/dashboard',
          ),
          NavigationTab(
            icon: Icons.attach_money,
            title: 'Rates',
            route: '/gas-plant/gas-rate',
          ),
          NavigationTab(
            icon: Icons.inventory_2,
            title: 'Orders',
            route: '/gas-plant/orders',
          ),
          NavigationTab(
            icon: Icons.account_balance_wallet,
            title: 'Expenses',
            route: '/gas-plant/expenses',
          ),
          NavigationTab(
            icon: Icons.settings,
            title: 'Settings',
            route: '/gas-plant/settings',
          ),
        ];
      case UserRole.distributor:
        return [
          NavigationTab(
            icon: Icons.home,
            title: 'Home',
            route: '/distributor/dashboard',
          ),
          NavigationTab(
            icon: Icons.inventory_2,
            title: 'Orders',
            route: '/distributor/orders',
          ),
          NavigationTab(
            icon: Icons.person,
            title: 'Drivers',
            route: '/distributor/drivers',
          ),
          NavigationTab(
            icon: Icons.settings,
            title: 'Settings',
            route: '/distributor/settings',
          ),
        ];
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
enum UserRole { gasPlant, distributor }
class NavigationTab {
  final IconData icon;
  final String title;
  final String route;

  const NavigationTab({
    required this.icon,
    required this.title,
    required this.route,
  });
}