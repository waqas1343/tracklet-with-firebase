import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/employee_provider.dart';
import 'package:tracklet/shared/widgets/custom_flushbar.dart';

// SECTION: Employees list with rename/delete (UI unchanged)
class EmployeesList extends StatelessWidget {
  const EmployeesList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmployeeProvider>(context);
    final list = provider.employees;

    if (list.isEmpty) {
      return const Center(child: Text('No employees yet.'));
    }

    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final e = list[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Row(
            children: [
              Expanded(flex: 2, key: ValueKey(e.id), child: Text(e.id)),
              const SizedBox(width: 8),
              Expanded(flex: 3, child: Text(e.name)),
              const SizedBox(width: 8),
              Expanded(flex: 3, child: Text(e.designation)),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Rename',
                icon: Icon(
                  Icons.edit_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () =>
                    _renameEmployee(context, provider, e.id, e.name),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
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

  // SECTION: Rename logic
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
        title: const Text('Rename Employee'),
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter new name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
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
      provider.renameEmployee(id, newName.trim());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          CustomFlushbar.showSuccess(context, message: 'Employee $id renamed');
        }
      });
    }
  }

  // SECTION: Delete logic
  Future<void> _deleteEmployee(
    BuildContext context,
    EmployeeProvider provider,
    String id,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Are you sure you want to delete $id?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      provider.deleteEmployee(id);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          CustomFlushbar.showError(context, message: 'Employee $id deleted');
        }
      });
    }
  }
}
