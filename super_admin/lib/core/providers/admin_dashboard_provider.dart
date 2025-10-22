import 'package:flutter/material.dart';
import 'admin_provider.dart';

class AdminDashboardProvider extends ChangeNotifier {
  final AdminProvider _adminProvider;
  
  AdminDashboardProvider(this._adminProvider);

  void refreshUsers() {
    _adminProvider.fetchAllUsers();
  }
}