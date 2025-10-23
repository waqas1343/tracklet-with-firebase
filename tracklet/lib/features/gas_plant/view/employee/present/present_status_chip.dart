import 'package:flutter/material.dart';
import '../model/employee_model.dart';

// SECTION: Present tab/status neutral chip (UI unchanged)
class PresentStatusChip extends StatelessWidget {
  final EmployeeModel employee;
  const PresentStatusChip({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: employee.isPresent == true
            ? Colors.green
            : employee.isPresent == false
                ? Colors.red
                : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        employee.isPresent == true
            ? 'Present'
            : employee.isPresent == false
                ? 'Absent'
                : 'Not Marked',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
