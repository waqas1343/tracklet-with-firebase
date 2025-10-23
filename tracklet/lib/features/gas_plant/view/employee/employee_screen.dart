import 'package:flutter/material.dart';
import 'package:tracklet/core/widgets/custom_appbar.dart';
import 'attendance_search_field.dart';
import 'attendance_tabs.dart';
import 'attendance_list.dart';
import 'add_employee/add_employee_screen.dart';

// SECTION: Screen - Employees (search + tabs + list)
class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        userName: 'Employees',
        userInitials: 'EM',
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            AttendanceSearchField(),
            SizedBox(height: 12),
            AttendanceTabs(),
            SizedBox(height: 16),
            Expanded(child: AttendanceList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'employee_fab',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEmployeeScreen()),
        ),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Employee'),
      ),
    );
  }
}