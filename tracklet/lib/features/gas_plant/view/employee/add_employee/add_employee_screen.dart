import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/employees_header.dart';
import 'widgets/employees_list.dart';
import 'widgets/add_employee_cta.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../provider/employee_provider.dart';

// SECTION: Employee Add Screen with error handling
class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EmployeeProvider>(context, listen: false);
      provider.loadEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Employee')),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, child) {
          // Show loading indicator
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // Show error message if any
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[700],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.clearError();
                      provider.loadEmployees();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show main content
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const _EmployeesTitle(),
                const SizedBox(height: 8),
                const EmployeesHeader(),
                const SizedBox(height: 8),
                const Expanded(child: EmployeesList()),
                const SizedBox(height: 16),
                const AddEmployeeCTA(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// SECTION: Private title widget to preserve exact UI style
class _EmployeesTitle extends StatelessWidget {
  const _EmployeesTitle();
  @override
  Widget build(BuildContext context) {
    return Text('Employees', style: Theme.of(context).textTheme.titleMedium);
  }
}
