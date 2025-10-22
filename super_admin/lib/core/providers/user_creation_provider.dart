import 'package:flutter/material.dart';
import 'admin_provider.dart';
import '../models/user_model.dart';

class UserCreationProvider extends ChangeNotifier {
  final AdminProvider _adminProvider;
  
  UserCreationProvider(this._adminProvider);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  
  String _selectedRole = UserRole.distributor;
  String get selectedRole => _selectedRole;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    companyNameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void setSelectedRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearForm() {
    emailController.clear();
    nameController.clear();
    companyNameController.clear();
    addressController.clear();
    _selectedRole = UserRole.distributor;
    notifyListeners();
  }

  Future<bool> createUser() async {
    setLoading(true);
    setErrorMessage(null);

    final success = await _adminProvider.createUser(
      email: emailController.text.trim(),
      role: _selectedRole,
      name: nameController.text.trim().isNotEmpty ? nameController.text.trim() : null,
      companyName: _selectedRole == UserRole.gasPlant && companyNameController.text.trim().isNotEmpty 
          ? companyNameController.text.trim() 
          : null,
      address: _selectedRole == UserRole.gasPlant && addressController.text.trim().isNotEmpty 
          ? addressController.text.trim() 
          : null,
    );

    setLoading(false);
    
    if (success) {
      clearForm();
    } else {
      setErrorMessage('Failed to create user. Please try again.');
    }
    
    return success;
  }
}