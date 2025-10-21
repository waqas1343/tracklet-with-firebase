import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/admin_provider.dart';
import '../../../core/models/user_model.dart';

class AdminUserCreationForm extends StatefulWidget {
  const AdminUserCreationForm({super.key});

  @override
  State<AdminUserCreationForm> createState() => _AdminUserCreationFormState();
}

class _AdminUserCreationFormState extends State<AdminUserCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();
  
  String _selectedRole = UserRole.distributor;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _companyNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _createUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      
      final success = await adminProvider.createUser(
        email: _emailController.text.trim(),
        role: _selectedRole,
        name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
        companyName: _selectedRole == UserRole.gasPlant && _companyNameController.text.trim().isNotEmpty 
            ? _companyNameController.text.trim() 
            : null,
        address: _selectedRole == UserRole.gasPlant && _addressController.text.trim().isNotEmpty 
            ? _addressController.text.trim() 
            : null,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Clear form
        _formKey.currentState!.reset();
        _emailController.clear();
        _nameController.clear();
        _companyNameController.clear();
        _addressController.clear();
        _selectedRole = UserRole.distributor;
        
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User created successfully with default password: 123123'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to create user. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
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
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
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
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
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
                      groupValue: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Gas Plant'),
                    leading: Radio<String>(
                      value: UserRole.gasPlant,
                      groupValue: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Conditional fields for Gas Plant
            if (_selectedRole == UserRole.gasPlant) ...[
              // Company Name Field
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
                validator: _selectedRole == UserRole.gasPlant
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
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: _selectedRole == UserRole.gasPlant
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
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            
            // Create User Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createUser,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Create User',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}