import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../provider/employee_provider.dart';
import '../../../../../../shared/widgets/custom_flushbar.dart';

// SECTION: Employees list with rename/delete (UI unchanged)
class EmployeesList extends StatelessWidget {
  const EmployeesList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmployeeProvider>(context);
    final list = provider.employees;

    // Show loading state
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error state
    if (provider.errorMessage != null && list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 12),
            Text(
              provider.errorMessage!,
              style: TextStyle(fontSize: 14, color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No employees yet.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click "Add Employee" to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    // Show employee list
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
      itemBuilder: (context, index) {
        final e = list[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                key: ValueKey(e.id),
                child: Text(
                  e.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Text(e.name, style: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Text(
                  e.role,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Text(
                  e.department,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Edit Employee',
                icon: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () =>
                    _renameEmployee(context, provider, e.id, e.name),
              ),
              IconButton(
                tooltip: 'Delete Employee',
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => _deleteEmployee(context, provider, e.id),
              ),
            ],
          ),
        );
      },
    );
  }

  // SECTION: Rename logic with error handling
  Future<void> _renameEmployee(
    BuildContext context,
    EmployeeProvider provider,
    String id,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Employee Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Employee Name',
            hintText: 'Enter new name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final v = controller.text.trim();
              if (v.isNotEmpty) Navigator.pop(ctx, v);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName.trim().isNotEmpty) {
      // Get the employee to update
      final employee = provider.employees.firstWhere((e) => e.id == id);
      final updatedEmployee = employee.copyWith(name: newName.trim());

      // Show loading indicator
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const Center(child: CircularProgressIndicator()),
        );
      }

      // Update employee
      final success = await provider.updateEmployee(updatedEmployee);

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show result
      if (context.mounted) {
        if (success) {
          CustomFlushbar.showSuccess(
            context,
            message: 'Employee updated successfully',
          );
        } else {
          CustomFlushbar.showError(
            context,
            message: provider.errorMessage ?? 'Failed to update employee',
          );
        }
      }
    }
  }

  // SECTION: Delete logic with error handling
  Future<void> _deleteEmployee(
    BuildContext context,
    EmployeeProvider provider,
    String id,
  ) async {
    final employee = provider.employees.firstWhere((e) => e.id == id);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text(
          'Are you sure you want to delete ${employee.name}?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Show loading indicator
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const Center(child: CircularProgressIndicator()),
        );
      }

      // Delete employee
      final success = await provider.deleteEmployee(id);

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show result
      if (context.mounted) {
        if (success) {
          CustomFlushbar.showSuccess(
            context,
            message: 'Employee deleted successfully',
          );
        } else {
          CustomFlushbar.showError(
            context,
            message: provider.errorMessage ?? 'Failed to delete employee',
          );
        }
      }
    }
  }
}
