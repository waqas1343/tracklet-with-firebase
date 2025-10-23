import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/user_creation_provider.dart';
import '../../../core/models/user_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class AdminUserCreationForm extends StatelessWidget {
  const AdminUserCreationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserCreationProvider>(
      builder: (context, userCreationProvider, _) {
        return _buildForm(context, userCreationProvider);
      },
    );
  }

  Widget _buildForm(BuildContext context, UserCreationProvider userCreationProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: GlobalKey<FormState>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Email Field
            CustomTextField(
              label: 'Email',
              controller: userCreationProvider.emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Name Field
            CustomTextField(
              label: 'Name',
              controller: userCreationProvider.nameController,
            ),
            const SizedBox(height: 16),
            
            // Role Selection
            const Text(
              'Role',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Distributor'),
                    leading: Radio<String>(
                      value: UserRole.distributor,
                      groupValue: userCreationProvider.selectedRole,
                      onChanged: (value) {
                        userCreationProvider.setSelectedRole(value!);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Gas Plant'),
                    leading: Radio<String>(
                      value: UserRole.gasPlant,
                      groupValue: userCreationProvider.selectedRole,
                      onChanged: (value) {
                        userCreationProvider.setSelectedRole(value!);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Conditional fields for Gas Plant
            if (userCreationProvider.selectedRole == UserRole.gasPlant) ...[
              // Company Name Field
              CustomTextField(
                label: 'Company Name',
                controller: userCreationProvider.companyNameController,
                validator: userCreationProvider.selectedRole == UserRole.gasPlant
                    ? (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter company name';
                        }
                        return null;
                      }
                    : null,
              ),
              const SizedBox(height: 16),
              
              // Address Field
              CustomTextField(
                label: 'Address',
                controller: userCreationProvider.addressController,
                maxLines: 3,
                validator: userCreationProvider.selectedRole == UserRole.gasPlant
                    ? (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      }
                    : null,
              ),
              const SizedBox(height: 16),
            ],
            
            // Error message
            if (userCreationProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  userCreationProvider.errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            
            // Create User Button
            CustomButton(
              text: 'Create User',
              onPressed: userCreationProvider.isLoading ? null : () => _createUser(context, userCreationProvider),
              width: double.infinity,
              isLoading: userCreationProvider.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createUser(BuildContext context, UserCreationProvider userCreationProvider) async {
    final success = await userCreationProvider.createUser();
    
    if (success && context.mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User created successfully with default password: 123123'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}