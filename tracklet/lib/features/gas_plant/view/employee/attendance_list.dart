import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/employee_provider.dart';
import 'attendance_tile.dart';

// SECTION: UI - Attendance list container and header
class AttendanceList extends StatelessWidget {
  const AttendanceList({super.key});

  @override
  Widget build(BuildContext context) {
    final employees = Provider.of<EmployeeProvider>(context).filteredEmployees;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey.shade200,
          child: Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text(
                  "ID",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              return AttendanceTile(employee: employees[index]);
            },
          ),
        ),
      ],
    );
  }
}
