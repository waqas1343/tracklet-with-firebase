import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storageService;

  ThemeProvider({required StorageService storageService})
    : _storageService = storageService {
    final savedMode = _storageService.getThemeMode();
    _themeMode = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await _storageService.saveThemeMode(
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _storageService.saveThemeMode(
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }
}
