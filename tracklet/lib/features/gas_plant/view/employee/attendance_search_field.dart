import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/employee_provider.dart';

// SECTION: UI - Search field for employees
class AttendanceSearchField extends StatelessWidget {
  const AttendanceSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmployeeProvider>(context);

    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search by ID or Name',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: provider.setSearchQuery,
    );
  }
}
