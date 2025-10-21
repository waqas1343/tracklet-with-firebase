import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/models/employee_model.dart';
import '../provider/employee_provider.dart';

class ActiveEmployeesScreen extends StatefulWidget {
  const ActiveEmployeesScreen({super.key});

  @override
  State<ActiveEmployeesScreen> createState() => _ActiveEmployeesScreenState();
}

class _ActiveEmployeesScreenState extends State<ActiveEmployeesScreen> {
  @override
  void initState() {
    super.initState();
    // Load employees when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false).loadActiveEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        userName: 'Active Employees',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Consumer<EmployeeProvider>(
          builder: (context, employeeProvider, child) {
            if (employeeProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (employeeProvider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(employeeProvider.errorMessage!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => employeeProvider.loadActiveEmployees(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee Overview Card
                  _buildEmployeeOverviewCard(employeeProvider.activeEmployeesCount),
                  const SizedBox(height: 24),

                  // Active Employees List
                  _buildActiveEmployeesSection(employeeProvider.employees),
                  const SizedBox(height: 24),

                  // Add Employee Button
                  CustomButton(
                    text: 'Add New Employee',
                    onPressed: () {
                      // TODO: Handle add new employee
                      // Add new employee functionality
                    },
                    width: double.infinity,
                    backgroundColor: const Color(0xFF1A2B4C),
                    textColor: Colors.white,
                    height: 50,
                    borderRadius: 12,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmployeeOverviewCard(int count) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B4C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Employees',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Last updated: 08-Oct-2025',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveEmployeesSection(List<EmployeeModel> employees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Employee List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        if (employees.isEmpty)
          const Center(
            child: Text(
              'No active employees found',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          )
        else
          ...employees.map((employee) {
            return _buildEmployeeCard(
              employee.name,
              employee.role,
              employee.status.toString().split('.').last,
              Icons.person,
            );
          }), // Removed .toList() as it's unnecessary in a spread
      ],
    );
  }

  Widget _buildEmployeeCard(
    String name,
    String position,
    String status,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: const Color(0xFF1A2B4C), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  position,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}