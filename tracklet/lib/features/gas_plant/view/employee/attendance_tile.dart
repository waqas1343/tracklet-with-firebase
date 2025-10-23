import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/employee_provider.dart';
import 'absent/absent_status_row.dart';
import 'present/present_status_chip.dart';
import 'total_employee/total_tab_controls.dart';
import 'model/employee_model.dart';

// NOTE: This widget only renders exactly the same UI with small refactors.
// No layout, padding, or colors were changed.

// SECTION: UI Widgets - Employee row tile for Attendance lists
class AttendanceTile extends StatelessWidget {
  final EmployeeModel employee;

  const AttendanceTile({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmployeeProvider>();
    final onTotalTab = provider.selectedTab == AttendanceTab.total;
    final onAbsentTab = provider.selectedTab == AttendanceTab.absent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: employee.status == 'late' ? Colors.yellow.shade50 : null,
        border: const Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(employee.id, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(employee.name, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: onTotalTab
                    ? TotalTabControls(employee: employee, onToggle: (p) => provider.toggleAttendance(employee.id, p))
                    : (onAbsentTab
                          ? AbsentStatusRow(
                              employee: employee,
                              onMarkLate: () => provider.markLate(employee.id, DateTime.now()),
                            )
                          : PresentStatusChip(employee: employee)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
