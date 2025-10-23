import 'package:flutter/material.dart';
import 'widgets/employees_header.dart';
import 'widgets/employees_list.dart';
import 'widgets/add_employee_cta.dart';

// SECTION: Employee Add Screen (UI unchanged)
class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Employee')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            const _EmployeesTitle(),
            const SizedBox(height: 8),
            const EmployeesHeader(),
            const SizedBox(height: 8),
            const Expanded(child: EmployeesList()),
            const SizedBox(height: 16),
            const AddEmployeeCTA(),
          ],
        ),
      ),
    );
  }
}

// SECTION: Private title widget to preserve exact UI style
class _EmployeesTitle extends StatelessWidget {
  const _EmployeesTitle();
  @override
  Widget build(BuildContext context) {
    return Text(
      'Employees',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
