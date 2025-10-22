import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/admin_provider.dart';
import '../../../core/providers/admin_dashboard_provider.dart';
import 'admin_user_creation_form.dart';
import 'user_list_view.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminDashboardProvider>(
      builder: (context, dashboardProvider, _) {
        // Fetch users when the screen loads
        WidgetsBinding.instance.addPostFrameCallback((_) {
          dashboardProvider.refreshUsers();
        });
        
        return _buildDashboard(context);
      },
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Super Admin Dashboard'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Create User'),
              Tab(text: 'User List'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AdminUserCreationForm(),
            UserListView(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final dashboardProvider = Provider.of<AdminDashboardProvider>(context, listen: false);
            dashboardProvider.refreshUsers();
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}