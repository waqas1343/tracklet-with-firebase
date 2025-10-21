import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _keyLanguage = 'app_language';
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keyThemeMode = 'theme_mode';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token management
  Future<bool> saveToken(String token) async {
    return await _prefs.setString(_keyToken, token);
  }

  String? getToken() {
    return _prefs.getString(_keyToken);
  }

  Future<bool> removeToken() async {
    return await _prefs.remove(_keyToken);
  }

  // User data management
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    return await _prefs.setString(_keyUser, jsonEncode(userData));
  }

  Map<String, dynamic>? getUserData() {
    final userString = _prefs.getString(_keyUser);
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> removeUserData() async {
    return await _prefs.remove(_keyUser);
  }

  // Language management
  Future<bool> saveLanguage(String languageCode) async {
    return await _prefs.setString(_keyLanguage, languageCode);
  }

  String getLanguage() {
    return _prefs.getString(_keyLanguage) ?? 'en';
  }

  // Onboarding management
  Future<bool> setOnboardingComplete() async {
    return await _prefs.setBool(_keyOnboardingComplete, true);
  }

  bool isOnboardingComplete() {
    return _prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  // Theme management
  Future<bool> saveThemeMode(String mode) async {
    return await _prefs.setString(_keyThemeMode, mode);
  }

  String getThemeMode() {
    return _prefs.getString(_keyThemeMode) ?? 'light';
  }

  // Generic string storage
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
