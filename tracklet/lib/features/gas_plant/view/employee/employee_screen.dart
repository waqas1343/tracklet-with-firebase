import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/employee_provider.dart';
import 'attendance_search_field.dart';
import 'attendance_tabs.dart';
import 'attendance_list.dart';
import 'add_employee/add_employee_screen.dart';

// SECTION: Screen - Employees (search + tabs + list)
class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    // Load employees when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      employeeProvider.loadEmployees();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Management'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => employeeProvider.downloadAttendancePDF(),
            tooltip: 'Download Attendance PDF',
          ),
        ],
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
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AddEmployeeScreen())),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Employee'),
      ),
    );
  }
}
