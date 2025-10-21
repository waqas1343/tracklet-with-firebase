import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/profile_repository.dart';

/// ProfileViewModel - Handles profile-related business logic
/// Follows MVVM pattern for separation of concerns
class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  ProfileViewModel(this._repository);

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  /// Initialize profile data
  Future<void> initializeProfile() async {
    final uid = _repository.currentUserId;
    if (uid != null) {
      await loadUserProfile(uid);
    }
  }

  /// Load user profile from repository
  Future<void> loadUserProfile(String uid) async {
    try {
      _setLoading(true);
      _clearError();

      _currentUser = await _repository.getUserProfile(uid);

      if (_currentUser == null) {
        await _createDefaultProfile(uid);
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to load profile: ${e.toString()}');
      if (kDebugMode) {
        print('Error loading profile: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Create default profile for new user
  Future<void> _createDefaultProfile(String uid) async {
    try {
      final defaultUser = UserModel(
        id: uid,
        name: 'User',
        email: '',
        phone: '',
        role: UserRole.gasPlant,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      await _repository.createProfile(defaultUser);
      _currentUser = defaultUser;
    } catch (e) {
      _setError('Failed to create profile: ${e.toString()}');
      if (kDebugMode) {
        print('Error creating profile: $e');
      }
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? companyName,
    String? address,
    String? operatingHours,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Check if user is logged in
      final uid = _repository.currentUserId;
      if (uid == null) {
        _setError('No user logged in');
        return false;
      }

      // If no current user, try to load it first
      if (_currentUser == null) {
        await loadUserProfile(uid);
      }

      // If still no user after loading, create a default one
      if (_currentUser == null) {
        await _createDefaultProfile(uid);
      }

      if (_currentUser == null) {
        _setError('Failed to initialize user profile');
        return false;
      }

      final success = await _repository.updateProfileFields(
        uid: _currentUser!.id,
        name: name,
        email: email,
        phone: phone,
        companyName: companyName,
        address: address,
        operatingHours: operatingHours,
      );

      if (success) {
        // Update local model
        _currentUser = _currentUser!.copyWith(
          name: name ?? _currentUser!.name,
          email: email ?? _currentUser!.email,
          phone: phone ?? _currentUser!.phone,
          companyName: companyName ?? _currentUser!.companyName,
          address: address ?? _currentUser!.address,
          operatingHours: operatingHours ?? _currentUser!.operatingHours,
          lastLogin: DateTime.now(),
        );
        notifyListeners();
      }

      return success;
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update complete profile
  Future<bool> updateCompleteProfile(UserModel user) async {
    try {
      if (_currentUser == null) {
        _setError('No user logged in');
        return false;
      }

      _setLoading(true);
      _clearError();

      final success = await _repository.updateProfile(
        _currentUser!.id,
        user.toJson(),
      );

      if (success) {
        _currentUser = user;
        notifyListeners();
      }

      return success;
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get real-time profile stream
  Stream<UserModel?> get profileStream {
    final uid = _repository.currentUserId;
    if (uid == null) return Stream.value(null);

    return _repository.getProfileStream(uid).map((user) {
      _currentUser = user;
      notifyListeners();
      return user;
    });
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    final uid = _repository.currentUserId;
    if (uid != null) {
      await loadUserProfile(uid);
    }
  }

  /// Clear profile data
  void clearProfile() {
    _currentUser = null;
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
