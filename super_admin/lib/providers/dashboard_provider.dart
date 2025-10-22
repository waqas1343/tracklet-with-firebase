// Dashboard Provider - Dashboard state, data aur loading management
import 'package:flutter/material.dart';
import '../models/activity_model.dart';

class DashboardProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _showShimmer = true;

  // Metrics
  int _totalUsers = 0;
  int _activeUsers = 0;
  int _totalRevenue = 0;
  int _pendingTasks = 0;

  // Activities
  List<ActivityModel> _recentActivities = [];

  // Current page
  int _currentPageIndex = 0;

  DashboardProvider() {
    _loadDashboardData();
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get showShimmer => _showShimmer;
  int get totalUsers => _totalUsers;
  int get activeUsers => _activeUsers;
  int get totalRevenue => _totalRevenue;
  int get pendingTasks => _pendingTasks;
  List<ActivityModel> get recentActivities => _recentActivities;
  int get currentPageIndex => _currentPageIndex;

  // Load dashboard data with shimmer effect
  Future<void> _loadDashboardData() async {
    _isLoading = true;
    _showShimmer = true;
    notifyListeners();

    // Simulate API call - 900ms delay
    await Future.delayed(const Duration(milliseconds: 900));

    // Generate fake data
    _totalUsers = 1247;
    _activeUsers = 892;
    _totalRevenue = 125840;
    _pendingTasks = 23;
    _recentActivities = ActivityModel.generateSampleActivities(20);

    _showShimmer = false;
    _isLoading = false;
    notifyListeners();
  }

  // Refresh data
  Future<void> refreshData() async {
    await _loadDashboardData();
  }

  // Change page (for bottom navigation)
  void setCurrentPage(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  // Animated counter targets
  double getCounterProgress(String metric, double currentValue) {
    switch (metric) {
      case 'users':
        return currentValue / _totalUsers;
      case 'active':
        return currentValue / _activeUsers;
      case 'revenue':
        return currentValue / _totalRevenue;
      case 'tasks':
        return currentValue / _pendingTasks;
      default:
        return 0.0;
    }
  }
}
