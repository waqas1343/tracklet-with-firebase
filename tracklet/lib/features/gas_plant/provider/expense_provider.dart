import 'package:flutter/foundation.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/services/api_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ApiService _apiService;

  ExpenseProvider({required ApiService apiService}) : _apiService = apiService;

  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ExpenseModel> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalExpenses =>
      _expenses.fold(0.0, (sum, expense) => sum + expense.amount);

  Map<ExpenseCategory, double> get expensesByCategory {
    final Map<ExpenseCategory, double> categoryTotals = {};

    for (var expense in _expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0.0) + expense.amount;
    }

    return categoryTotals;
  }

  List<ExpenseModel> getExpensesByCategory(ExpenseCategory category) {
    return _expenses.where((expense) => expense.category == category).toList();
  }

  List<ExpenseModel> getExpensesByDateRange(DateTime start, DateTime end) {
    return _expenses
        .where(
          (expense) =>
              expense.date.isAfter(start) && expense.date.isBefore(end),
        )
        .toList();
  }

  Future<void> fetchExpenses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/expenses');
      final expensesData = response['expenses'] as List;
      _expenses = expensesData
          .map((json) => ExpenseModel.fromJson(json))
          .toList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch expenses: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createExpense(ExpenseModel expense) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/expenses', expense.toJson());
      final newExpense = ExpenseModel.fromJson(response['expense']);
      _expenses.insert(0, newExpense);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create expense: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExpense(ExpenseModel expense) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.put(
        '/expenses/${expense.id}',
        expense.toJson(),
      );
      final updatedExpense = ExpenseModel.fromJson(response['expense']);
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = updatedExpense;
      }
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update expense: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteExpense(String expenseId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.delete('/expenses/$expenseId');
      _expenses.removeWhere((expense) => expense.id == expenseId);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete expense: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
