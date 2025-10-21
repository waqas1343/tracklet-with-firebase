import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/admin_provider.dart';
import 'admin_user_creation_form.dart';
import 'user_list_view.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch users when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      adminProvider.fetchAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            final adminProvider = Provider.of<AdminProvider>(context, listen: false);
            adminProvider.fetchAllUsers();
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}