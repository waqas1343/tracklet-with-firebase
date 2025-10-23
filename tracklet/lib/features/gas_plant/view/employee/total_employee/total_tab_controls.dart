import 'package:flutter/material.dart';
import '../model/employee_model.dart';

// SECTION: Total tab controls (Absent/Present chips) (UI unchanged)
class TotalTabControls extends StatelessWidget {
  final EmployeeModel employee;
  final void Function(bool present) onToggle;
  const TotalTabControls({
    super.key,
    required this.employee,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChoiceChip(
          label: Text(
            employee.status == 'late'
                ? MaterialLocalizations.of(context).formatTimeOfDay(
                    TimeOfDay.fromDateTime(employee.lateTime ?? DateTime.now()),
                  )
                : 'Absent',
          ),
          selected: employee.isPresent == false,
          showCheckmark: false,
          onSelected: (_) => onToggle(false),
          selectedColor: employee.status == 'late' ? Colors.orange : Colors.red,
          backgroundColor: employee.isPresent == null ? Colors.grey[200] : null,
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text("Present"),
          selected: employee.isPresent == true,
          showCheckmark: false,
          onSelected: (_) => onToggle(true),
          selectedColor: Colors.green,
          backgroundColor: employee.isPresent == null ? Colors.grey[200] : null,
        ),
      ],
    );
  }
}
