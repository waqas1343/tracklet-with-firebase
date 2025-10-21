import 'package:flutter/foundation.dart';
import '../models/company_model.dart';
import '../repositories/company_repository.dart';

/// CompanyViewModel - Handles company-related business logic
/// Follows MVVM pattern for separation of concerns
class CompanyViewModel extends ChangeNotifier {
  final CompanyRepository _repository;

  List<CompanyModel> _companies = [];
  List<CompanyModel> _topPlants = [];
  bool _isLoading = false;
  String? _error;

  CompanyViewModel(this._repository);

  // Getters
  List<CompanyModel> get companies => _companies;
  List<CompanyModel> get topPlants => _topPlants;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCompanies => _companies.isNotEmpty;

  /// Load all companies from Firestore
  Future<void> loadAllCompanies() async {
    try {
      _setLoading(true);
      _clearError();

      _companies = await _repository.getAllCompanies();
      _updateTopPlants();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load companies: ${e.toString()}');
      if (kDebugMode) {
        print('Error loading companies: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Load a specific company by ID
  Future<CompanyModel?> loadCompanyById(String companyId) async {
    try {
      _setLoading(true);
      _clearError();

      final company = await _repository.getCompanyById(companyId);
      return company;
    } catch (e) {
      _setError('Failed to load company: ${e.toString()}');
      if (kDebugMode) {
        print('Error loading company: $e');
      }
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Listen to real-time company updates
  Stream<List<CompanyModel>> get companiesStream {
    return _repository.getCompaniesStream().map((companies) {
      _companies = companies;
      _updateTopPlants();
      notifyListeners();
      return companies;
    });
  }

  /// Search companies by name
  Future<void> searchCompanies(String query) async {
    try {
      _setLoading(true);
      _clearError();

      if (query.isEmpty) {
        await loadAllCompanies();
        return;
      }

      _companies = await _repository.searchCompaniesByName(query);
      _updateTopPlants();

      notifyListeners();
    } catch (e) {
      _setError('Failed to search companies: ${e.toString()}');
      if (kDebugMode) {
        print('Error searching companies: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Get companies by owner
  Future<void> loadCompaniesByOwner(String ownerId) async {
    try {
      _setLoading(true);
      _clearError();

      _companies = await _repository.getCompaniesByOwner(ownerId);
      _updateTopPlants();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load companies: ${e.toString()}');
      if (kDebugMode) {
        print('Error loading companies by owner: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Save or update a company
  Future<bool> saveCompany(CompanyModel company) async {
    try {
      _setLoading(true);
      _clearError();

      final success = await _repository.saveCompany(company);

      if (success) {
        await loadAllCompanies();
      }

      return success;
    } catch (e) {
      _setError('Failed to save company: ${e.toString()}');
      if (kDebugMode) {
        print('Error saving company: $e');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a company
  Future<bool> deleteCompany(String companyId) async {
    try {
      _setLoading(true);
      _clearError();

      final success = await _repository.deleteCompany(companyId);

      if (success) {
        _companies.removeWhere((c) => c.id == companyId);
        _updateTopPlants();
        notifyListeners();
      }

      return success;
    } catch (e) {
      _setError('Failed to delete company: ${e.toString()}');
      if (kDebugMode) {
        print('Error deleting company: $e');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh companies list
  Future<void> refreshCompanies() async {
    await loadAllCompanies();
  }

  /// Update top plants (limited to first 10 for performance)
  void _updateTopPlants() {
    _topPlants = _companies.take(10).toList();
  }

  /// Clear all data
  void clearData() {
    _companies = [];
    _topPlants = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
