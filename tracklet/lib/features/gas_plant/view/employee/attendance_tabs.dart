import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/app_colors.dart';
import 'provider/employee_provider.dart';

// SECTION: UI - Attendance tabs (Total / Present / Absent)
class AttendanceTabs extends StatelessWidget {
  const AttendanceTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmployeeProvider>(context);
    final total = provider.totalEmployees;
    final present = provider.presentCount;
    final absent = provider.absentCount;
    final late = provider.lateCount;

    Widget buildTab({
      required String label,
      required bool selected,
      required VoidCallback onTap,
      required IconData icon,
      required String headerTop,
      required String headerBottom,
      required Color color,
      required Color selectedColor,
    }) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            height: 100,
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? selectedColor
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            headerTop,
                            style: TextStyle(
                              color: selected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            headerBottom,
                            style: TextStyle(
                              color: selected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: selected
                              ? Theme.of(context).colorScheme.onPrimary
                              : color,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          icon,
                          size: 20,
                          color: selected
                              ? Theme.of(context).colorScheme.onPrimary
                              : color,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: selected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        buildTab(
          label: '$total',
          selected: provider.selectedTab == AttendanceTab.total,
          onTap: () => provider.setSelectedTab(AttendanceTab.total),
          icon: Icons.people, // Using Icons.people as placeholder
          color: AppColors.primary,
          selectedColor: AppColors.primary,
          headerTop: 'Total',
          headerBottom: 'Employees',
        ),
        const SizedBox(width: 8),
        buildTab(
          label: '$present',
          selected: provider.selectedTab == AttendanceTab.present,
          onTap: () => provider.setSelectedTab(AttendanceTab.present),
          icon: Icons.check, // Using Icons.check as placeholder
          color: AppColors.primary,
          selectedColor: AppColors.primary,
          headerTop: 'Present',
          headerBottom: 'Employees',
        ),
        const SizedBox(width: 8),
        buildTab(
          label: late > 0 ? '$absent, $late' : '$absent',
          selected: provider.selectedTab == AttendanceTab.absent,
          onTap: () => provider.setSelectedTab(AttendanceTab.absent),
          icon: Icons.clear, // Using Icons.clear as placeholder
          color: Colors.red,
          selectedColor: Colors.red,
          headerTop: 'Absent',
          headerBottom: 'Employees',
        ),
      ],
    );
  }
}
