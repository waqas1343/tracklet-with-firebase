import 'package:flutter/foundation.dart';
import '../models/company_model.dart';
import '../repositories/company_repository.dart';
import '../viewmodels/company_viewmodel.dart';

/// CompanyProvider - Manages company/gas plant data using MVVM pattern
/// Acts as a bridge between UI and CompanyViewModel
class CompanyProvider extends ChangeNotifier {
  final CompanyViewModel _viewModel;

  CompanyProvider() : _viewModel = CompanyViewModel(CompanyRepository()) {
    _viewModel.addListener(_onViewModelChanged);
    // Start listening to real-time updates
    _listenToRealTimeUpdates();
  }

  // Getters - Delegate to ViewModel
  List<CompanyModel> get companies => _viewModel.companies;
  List<CompanyModel> get topPlants => _viewModel.topPlants;
  bool get isLoading => _viewModel.isLoading;
  String? get error => _viewModel.error;
  bool get hasCompanies => _viewModel.hasCompanies;

  /// Load all companies from Firestore
  Future<void> loadAllCompanies() async {
    await _viewModel.loadAllCompanies();
  }

  /// Load a specific company by ID
  Future<CompanyModel?> loadCompanyById(String companyId) async {
    return await _viewModel.loadCompanyById(companyId);
  }

  /// Listen to real-time company updates
  Stream<List<CompanyModel>> get companiesStream => _viewModel.companiesStream;

  /// Search companies by name
  Future<void> searchCompanies(String query) async {
    await _viewModel.searchCompanies(query);
  }

  /// Get companies by owner
  Future<void> loadCompaniesByOwner(String ownerId) async {
    await _viewModel.loadCompaniesByOwner(ownerId);
  }

  /// Save or update a company
  Future<bool> saveCompany(CompanyModel company) async {
    return await _viewModel.saveCompany(company);
  }

  /// Delete a company
  Future<bool> deleteCompany(String companyId) async {
    return await _viewModel.deleteCompany(companyId);
  }

  /// Refresh companies list
  Future<void> refreshCompanies() async {
    await _viewModel.refreshCompanies();
  }

  /// Clear all data
  void clearData() {
    _viewModel.clearData();
  }

  /// Listen to real-time updates
  void _listenToRealTimeUpdates() {
    // Subscribe to real-time updates
    _viewModel.companiesStream.listen((companies) {
      // The companies are automatically updated through the view model
      // We just need to ensure the subscription is active
    });
  }

  /// Handle ViewModel changes
  void _onViewModelChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }
}