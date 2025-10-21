import 'package:flutter/material.dart';

/// NavigationViewModel: Manages bottom navigation state
///
/// Handles tab switching and navigation state management
class NavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  /// Navigate to specific tab index with bounds checking
  void navigateToIndex(int index) {
    // Ensure index is valid (non-negative)
    if (index >= 0 && _currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// Navigate to specific tab index with max bounds checking
  void navigateToIndexWithMax(int index, int maxIndex) {
    // Ensure index is within valid range
    if (index >= 0 && index <= maxIndex && _currentIndex != index) {
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