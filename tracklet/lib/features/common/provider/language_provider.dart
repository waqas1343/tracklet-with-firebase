import 'package:flutter/foundation.dart';
import '../../../core/services/storage_service.dart';

class LanguageProvider extends ChangeNotifier {
  final StorageService _storageService;

  LanguageProvider({required StorageService storageService})
    : _storageService = storageService {
    _currentLanguage = _storageService.getLanguage();
  }

  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  final Map<String, String> _supportedLanguages = {
    'en': 'English',
    'ur': 'اردو',
    'ar': 'العربية',
  };

  Map<String, String> get supportedLanguages => _supportedLanguages;

  Future<void> changeLanguage(String languageCode) async {
    if (_supportedLanguages.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      await _storageService.saveLanguage(languageCode);
      notifyListeners();
    }
  }

  String translate(String key) {
    // This is a simple example. In a real app, you'd use a proper i18n solution
    final translations = _getTranslations();
    return translations[_currentLanguage]?[key] ?? key;
  }

  Map<String, Map<String, String>> _getTranslations() {
    return {
      'en': {
        'app_name': 'Tracklet',
        'login': 'Login',
        'logout': 'Logout',
        'email': 'Email',
        'password': 'Password',
        'dashboard': 'Dashboard',
        'orders': 'Orders',
        'settings': 'Settings',
        'gas_rate': 'Gas Rate',
        'expenses': 'Expenses',
        'drivers': 'Drivers',
        'welcome': 'Welcome',
        'loading': 'Loading...',
      },
      'ur': {
        'app_name': 'ٹریکلیٹ',
        'login': 'لاگ ان',
        'logout': 'لاگ آؤٹ',
        'email': 'ای میل',
        'password': 'پاس ورڈ',
        'dashboard': 'ڈیش بورڈ',
        'orders': 'آرڈرز',
        'settings': 'ترتیبات',
        'gas_rate': 'گیس کی قیمت',
        'expenses': 'اخراجات',
        'drivers': 'ڈرائیورز',
        'welcome': 'خوش آمدید',
        'loading': 'لوڈ ہو رہا ہے...',
      },
    };
  }
}
