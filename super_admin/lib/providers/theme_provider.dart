// Theme Provider - Light/Dark mode toggle aur theme management
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/style_tokens.dart';
import '../utils/modern_design_system.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _isLoading = true;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  // Theme Colors - Dynamic based on mode
  Color get primary =>
      _isDarkMode ? AppColorsDark.primary : AppColorsLight.primary;
  Color get primaryVariant => _isDarkMode
      ? AppColorsDark.primaryVariant
      : AppColorsLight.primaryVariant;
  Color get secondary =>
      _isDarkMode ? AppColorsDark.secondary : AppColorsLight.secondary;
  Color get background =>
      _isDarkMode ? AppColorsDark.background : AppColorsLight.background;
  Color get surface =>
      _isDarkMode ? AppColorsDark.surface : AppColorsLight.surface;
  Color get surfaceVariant => _isDarkMode
      ? AppColorsDark.surfaceVariant
      : AppColorsLight.surfaceVariant;
  Color get textPrimary =>
      _isDarkMode ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
  Color get textSecondary =>
      _isDarkMode ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
  Color get textMuted =>
      _isDarkMode ? AppColorsDark.textMuted : AppColorsLight.textMuted;
  Color get success =>
      _isDarkMode ? AppColorsDark.success : AppColorsLight.success;
  Color get warning =>
      _isDarkMode ? AppColorsDark.warning : AppColorsLight.warning;
  Color get error => _isDarkMode ? AppColorsDark.error : AppColorsLight.error;
  Color get info => _isDarkMode ? AppColorsDark.info : AppColorsLight.info;
  Color get divider =>
      _isDarkMode ? AppColorsDark.divider : AppColorsLight.divider;
  Color get onPrimary =>
      _isDarkMode ? AppColorsDark.onPrimary : AppColorsLight.onPrimary;

  // Modern Colors
  Color get modernPrimaryStart => ModernColors.primaryStart;
  Color get modernPrimaryEnd => ModernColors.primaryEnd;
  Color get modernSecondary => ModernColors.secondary;
  Color get modernAccent => ModernColors.accent;
  Color get modernBackground =>
      _isDarkMode ? ModernColors.backgroundDark : ModernColors.backgroundLight;
  Color get modernSurface =>
      _isDarkMode ? ModernColors.surfaceDark : ModernColors.surfaceLight;
  Color get modernTextPrimary => _isDarkMode
      ? ModernColors.textPrimaryDark
      : ModernColors.textPrimaryLight;
  Color get modernTextSecondary => _isDarkMode
      ? ModernColors.textSecondaryDark
      : ModernColors.textSecondaryLight;
  Color get modernBorder =>
      _isDarkMode ? ModernColors.borderDark : ModernColors.borderLight;

  // Text Styles
  TextStyle get heading1 => StyleTokens.heading1(_isDarkMode);
  TextStyle get heading2 => StyleTokens.heading2(_isDarkMode);
  TextStyle get heading3 => StyleTokens.heading3(_isDarkMode);
  TextStyle get bodyLarge => StyleTokens.bodyLarge(_isDarkMode);
  TextStyle get bodyMedium => StyleTokens.bodyMedium(_isDarkMode);
  TextStyle get bodySmall => StyleTokens.bodySmall(_isDarkMode);
  TextStyle get caption => StyleTokens.caption(_isDarkMode);

  // Modern Text Styles
  TextStyle get displayLarge => ModernTypography.displayLarge(_isDarkMode);
  TextStyle get displayMedium => ModernTypography.displayMedium(_isDarkMode);
  TextStyle get displaySmall => ModernTypography.displaySmall(_isDarkMode);
  TextStyle get headlineLarge => ModernTypography.headlineLarge(_isDarkMode);
  TextStyle get headlineMedium => ModernTypography.headlineMedium(_isDarkMode);
  TextStyle get headlineSmall => ModernTypography.headlineSmall(_isDarkMode);
  TextStyle get titleLarge => ModernTypography.titleLarge(_isDarkMode);
  TextStyle get titleMedium => ModernTypography.titleMedium(_isDarkMode);
  TextStyle get titleSmall => ModernTypography.titleSmall(_isDarkMode);
  TextStyle get labelLarge => ModernTypography.labelLarge(_isDarkMode);
  TextStyle get labelMedium => ModernTypography.labelMedium(_isDarkMode);
  TextStyle get labelSmall => ModernTypography.labelSmall(_isDarkMode);

  // Spacing
  double spacing(String key) => StyleTokens.spacing[key] ?? 16.0;
  double get spacingXs => ModernSpacing.xs;
  double get spacingSm => ModernSpacing.sm;
  double get spacingMd => ModernSpacing.md;
  double get spacingLg => ModernSpacing.lg;
  double get spacingXl => ModernSpacing.xl;
  double get spacingXxl => ModernSpacing.xxl;
  double get spacingXxxl => ModernSpacing.xxxl;
  double get spacingXxxxl => ModernSpacing.xxxxl;

  // Border Radius
  double get radiusSm => ModernRadius.sm;
  double get radiusMd => ModernRadius.md;
  double get radiusLg => ModernRadius.lg;
  double get radiusXl => ModernRadius.xl;
  double get radiusXxl => ModernRadius.xxl;
  double get radiusFull => ModernRadius.full;

  // Shadows
  List<BoxShadow> get shadowSm => StyleTokens.shadowSm(_isDarkMode);
  List<BoxShadow> get shadowMd => StyleTokens.shadowMd(_isDarkMode);
  List<BoxShadow> get shadowLg => StyleTokens.shadowLg(_isDarkMode);
  List<BoxShadow> get shadowLevel1 => ModernShadows.level1(_isDarkMode);
  List<BoxShadow> get shadowLevel2 => ModernShadows.level2(_isDarkMode);
  List<BoxShadow> get shadowLevel3 => ModernShadows.level3(_isDarkMode);
  List<BoxShadow> get shadowLevel4 => ModernShadows.level4(_isDarkMode);

  // Gradients
  LinearGradient get primaryGradient => ModernGradients.primary(_isDarkMode);
  LinearGradient get successGradient => ModernGradients.success(_isDarkMode);
  LinearGradient get warningGradient => ModernGradients.warning(_isDarkMode);
  LinearGradient get errorGradient => ModernGradients.error(_isDarkMode);
  LinearGradient get infoGradient => ModernGradients.info(_isDarkMode);

  // Glass Decoration
  BoxDecoration get glassDecoration => StyleTokens.glassDecoration(_isDarkMode);

  // Toggle Theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _saveThemePreference();
  }

  // Load theme from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    } catch (e) {
      // Removed debugPrint statement
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save theme to SharedPreferences
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      // Removed debugPrint statement
    }
  }

  // Material ThemeData for app
  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onPrimary,
        error: error,
        onError: onPrimary,
        surface: surface,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: 'Inter',
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
    );
  }
}
