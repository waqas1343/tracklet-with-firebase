// Settings Provider - App settings management
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  String _language = 'English';
  bool _autoSave = true;
  int _sessionTimeout = 30; // minutes

  SettingsProvider() {
    _loadSettings();
  }

  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get emailNotifications => _emailNotifications;
  bool get pushNotifications => _pushNotifications;
  String get language => _language;
  bool get autoSave => _autoSave;
  int get sessionTimeout => _sessionTimeout;

  // Load settings
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _emailNotifications = prefs.getBool('emailNotifications') ?? true;
      _pushNotifications = prefs.getBool('pushNotifications') ?? false;
      _language = prefs.getString('language') ?? 'English';
      _autoSave = prefs.getBool('autoSave') ?? true;
      _sessionTimeout = prefs.getInt('sessionTimeout') ?? 30;
      notifyListeners();
    } catch (e) {
      // Removed debugPrint statement
    }
  }

  // Toggle settings
  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> toggleEmailNotifications(bool value) async {
    _emailNotifications = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> togglePushNotifications(bool value) async {
    _pushNotifications = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> toggleAutoSave(bool value) async {
    _autoSave = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setSessionTimeout(int minutes) async {
    _sessionTimeout = minutes;
    notifyListeners();
    await _saveSettings();
  }

  // Save all settings
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationsEnabled', _notificationsEnabled);
      await prefs.setBool('emailNotifications', _emailNotifications);
      await prefs.setBool('pushNotifications', _pushNotifications);
      await prefs.setString('language', _language);
      await prefs.setBool('autoSave', _autoSave);
      await prefs.setInt('sessionTimeout', _sessionTimeout);
    } catch (e) {
      // Removed debugPrint statement
    }
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    _notificationsEnabled = true;
    _emailNotifications = true;
    _pushNotifications = false;
    _language = 'English';
    _autoSave = true;
    _sessionTimeout = 30;
    notifyListeners();
    await _saveSettings();
  }
}