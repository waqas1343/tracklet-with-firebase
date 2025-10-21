import 'package:flutter/material.dart';

/// NavigationViewModel: Manages bottom navigation state
///
/// Handles tab switching and navigation state management
class NavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  /// Navigate to specific tab index
  void navigateToIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// Reset navigation to home
  void resetToHome() {
    _currentIndex = 0;
    notifyListeners();
  }
}
