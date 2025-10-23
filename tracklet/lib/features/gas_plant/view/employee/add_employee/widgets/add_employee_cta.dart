import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../provider/employee_provider.dart';
import '../../../../../../core/models/employee_model.dart';
import '../../../../../../shared/widgets/custom_flushbar.dart';

// SECTION: Bottom CTA button that opens the Add Employee dialog (UI unchanged)
class AddEmployeeCTA extends StatelessWidget {
  const AddEmployeeCTA({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Employee'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  // SECTION: Dialog for adding a new employee with error handling
  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final roleController = TextEditingController();
    final departmentController = TextEditingController();
    final salaryController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add New Employee'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Employee Name',
                    hintText: 'Enter employee name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter employee name';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter email address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter email address';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Enter phone number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: roleController,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    hintText: 'Enter role (e.g., Supervisor)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter role';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: departmentController,
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    hintText: 'Enter department',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter department';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: salaryController,
                  decoration: const InputDecoration(
                    labelText: 'Salary',
                    hintText: 'Enter salary',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter salary';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Validate form
              if (!formKey.currentState!.validate()) {
                return;
              }

              final name = nameController.text.trim();
              final email = emailController.text.trim();
              final phone = phoneController.text.trim();
              final role = roleController.text.trim();
              final department = departmentController.text.trim();
              final salary = double.parse(salaryController.text.trim());

              // Close dialog
              Navigator.pop(dialogContext);

              // Show loading indicator
              if (context.mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) =>
                      const Center(child: CircularProgressIndicator()),
                );
              }

              // Create employee model
              final employee = EmployeeModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                email: email,
                phone: phone,
                role: role,
                department: department,
                joiningDate: DateTime.now(),
                salary: salary,
                status: EmployeeStatus.active,
              );

              // Add employee
              final provider = Provider.of<EmployeeProvider>(
                context,
                listen: false,
              );
              final success = await provider.addEmployee(employee);

              // Close loading dialog
              if (context.mounted) {
                Navigator.of(context).pop();
              }

              // Show result
              if (context.mounted) {
                if (success) {
                  CustomFlushbar.showSuccess(
                    context,
                    message: 'Employee added successfully',
                  );
                } else {
                  CustomFlushbar.showError(
                    context,
                    message: provider.errorMessage ?? 'Failed to add employee',
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
