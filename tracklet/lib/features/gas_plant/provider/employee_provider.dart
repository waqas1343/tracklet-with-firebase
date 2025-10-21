import 'package:flutter/material.dart';
import '../../../core/services/employee_service.dart';
import '../../../core/models/employee_model.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeService _employeeService = EmployeeService();
  List<EmployeeModel> _employees = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<EmployeeModel> get employees => _employees;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get activeEmployeesCount => 
    _employees.where((employee) => employee.status == EmployeeStatus.active).length;

  // Load all employees
  Future<void> loadEmployees() async {
    _setLoading(true);
    try {
      _employees = await _employeeService.getAllEmployees();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load employees: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Load active employees only
  Future<void> loadActiveEmployees() async {
    _setLoading(true);
    try {
      _employees = await _employeeService.getActiveEmployees();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load active employees: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Get employee by ID
  Future<EmployeeModel?> getEmployeeById(String id) async {
    try {
      return await _employeeService.getEmployeeById(id);
    } catch (e) {
      _errorMessage = 'Failed to get employee: $e';
      notifyListeners();
      return null;
    }
  }

  // Add new employee
  Future<bool> addEmployee(EmployeeModel employee) async {
    _setLoading(true);
    try {
      final success = await _employeeService.addEmployee(employee);
      if (success) {
        _employees.add(employee);
        _errorMessage = null;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Failed to add employee: $e';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Update employee
  Future<bool> updateEmployee(EmployeeModel employee) async {
    _setLoading(true);
    try {
      final success = await _employeeService.updateEmployee(employee);
      if (success) {
        final index = _employees.indexWhere((e) => e.id == employee.id);
        if (index != -1) {
          _employees[index] = employee;
        }
        _errorMessage = null;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Failed to update employee: $e';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Delete employee
  Future<bool> deleteEmployee(String id) async {
    _setLoading(true);
    try {
      final success = await _employeeService.deleteEmployee(id);
      if (success) {
        _employees.removeWhere((employee) => employee.id == id);
        _errorMessage = null;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Failed to delete employee: $e';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}