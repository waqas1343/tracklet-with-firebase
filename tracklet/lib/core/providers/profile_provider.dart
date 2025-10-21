import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/profile_repository.dart';
import '../viewmodels/profile_viewmodel.dart';

/// ProfileProvider - Manages user profile data using MVVM pattern
/// Acts as a bridge between UI and ProfileViewModel
class ProfileProvider extends ChangeNotifier {
  final ProfileViewModel _viewModel;

  ProfileProvider() : _viewModel = ProfileViewModel(ProfileRepository()) {
    _viewModel.addListener(_onViewModelChanged);
  }

  // Getters - Delegate to ViewModel
  UserModel? get currentUser => _viewModel.currentUser;
  bool get isLoading => _viewModel.isLoading;
  String? get error => _viewModel.error;
  bool get isLoggedIn => _viewModel.isLoggedIn;

  /// Initialize profile data after user login
  Future<void> initializeProfile() async {
    await _viewModel.initializeProfile();
  }

  /// Load user profile from Firestore
  Future<void> loadUserProfile(String uid) async {
    await _viewModel.loadUserProfile(uid);
  }

  /// Update user profile in Firestore and locally
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? companyName,
    String? address,
    String? operatingHours,
  }) async {
    return await _viewModel.updateProfile(
      name: name,
      email: email,
      phone: phone,
      companyName: companyName,
      address: address,
      operatingHours: operatingHours,
    );
  }

  /// Update profile with complete UserModel
  Future<bool> updateCompleteProfile(UserModel user) async {
    return await _viewModel.updateCompleteProfile(user);
  }

  /// Listen to real-time profile changes
  Stream<UserModel?> get profileStream => _viewModel.profileStream;

  /// Clear profile data on logout
  void clearProfile() {
    _viewModel.clearProfile();
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await _viewModel.refreshProfile();
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
