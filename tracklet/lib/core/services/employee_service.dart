import '../models/employee_model.dart';

class EmployeeService {
  final List<EmployeeModel> _employees = [
    EmployeeModel(
      id: '1',
      name: 'Ahmed Khan',
      email: 'ahmed.khan@example.com',
      phone: '+923001234567',
      role: 'Manager',
      department: 'Operations',
      joiningDate: DateTime(2023, 1, 15),
      salary: 75000,
      status: EmployeeStatus.active,
    ),
    EmployeeModel(
      id: '2',
      name: 'Sana Ali',
      email: 'sana.ali@example.com',
      phone: '+923001234568',
      role: 'Supervisor',
      department: 'Production',
      joiningDate: DateTime(2023, 3, 22),
      salary: 55000,
      status: EmployeeStatus.active,
    ),
    EmployeeModel(
      id: '3',
      name: 'Usman Malik',
      email: 'usman.malik@example.com',
      phone: '+923001234569',
      role: 'Worker',
      department: 'Production',
      joiningDate: DateTime(2023, 6, 10),
      salary: 35000,
      status: EmployeeStatus.active,
    ),
    EmployeeModel(
      id: '4',
      name: 'Fatima Zahra',
      email: 'fatima.zahra@example.com',
      phone: '+923001234570',
      role: 'Accountant',
      department: 'Finance',
      joiningDate: DateTime(2023, 9, 5),
      salary: 60000,
      status: EmployeeStatus.onLeave,
    ),
  ];

  List<EmployeeModel> get employees => _employees;

  // Add the missing getAllEmployees method
  Future<List<EmployeeModel>> getAllEmployees() async {
    // Simulate async operation
    await Future.delayed(Duration(milliseconds: 100));
    return List<EmployeeModel>.from(_employees);
  }

  Future<List<EmployeeModel>> getActiveEmployees() async {
    // Simulate async operation
    await Future.delayed(Duration(milliseconds: 100));
    return _employees.where((employee) => employee.status == EmployeeStatus.active).toList();
  }

  Future<List<EmployeeModel>> getEmployeesByDepartment(String department) async {
    // Simulate async operation
    await Future.delayed(Duration(milliseconds: 100));
    return _employees.where((employee) => employee.department == department).toList();
  }

  Future<EmployeeModel?> getEmployeeById(String id) async {
    // Simulate async operation
    await Future.delayed(Duration(milliseconds: 100));
    try {
      return _employees.firstWhere((employee) => employee.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addEmployee(EmployeeModel employee) async {
    try {
      // Simulate async operation
      await Future.delayed(Duration(milliseconds: 100));
      _employees.add(employee);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateEmployee(EmployeeModel updatedEmployee) async {
    try {
      // Simulate async operation
      await Future.delayed(Duration(milliseconds: 100));
      final index = _employees.indexWhere((employee) => employee.id == updatedEmployee.id);
      if (index != -1) {
        _employees[index] = updatedEmployee;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteEmployee(String id) async {
    try {
      // Simulate async operation
      await Future.delayed(Duration(milliseconds: 100));
      _employees.removeWhere((employee) => employee.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }
}