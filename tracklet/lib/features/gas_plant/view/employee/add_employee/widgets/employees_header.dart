import 'package:flutter/material.dart';

// SECTION: Table Header for Employees list (UI unchanged)
class EmployeesHeader extends StatelessWidget {
  const EmployeesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(fontWeight: FontWeight.w600);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('ID', style: textStyle)),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: Text('Name', style: textStyle)),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: Text('Designation', style: textStyle)),
          const SizedBox(width: 8),
          const SizedBox(width: 80, child: Text('')),
        ],
      ),
    );
  }
}
