import 'package:flutter/material.dart';
import '../model/employee_model.dart';

// SECTION: Absent tab pill + Mark Late button (UI unchanged)
class AbsentStatusRow extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onMarkLate;
  const AbsentStatusRow({super.key, required this.employee, required this.onMarkLate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: employee.status == 'late' ? Colors.orange : Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            employee.status == 'late'
                ? 'Late - ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(employee.lateTime ?? DateTime.now()))}'
                : 'Absent',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (employee.status != 'late') ...[
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onMarkLate,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.orange),
              foregroundColor: Colors.orange.shade800,
            ),
            child: const Text('Mark Late'),
          ),
        ],
      ],
    );
  }
}
