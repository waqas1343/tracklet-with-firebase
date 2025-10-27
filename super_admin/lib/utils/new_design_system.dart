// New Design System - Modern UI for Super Admin Dashboard
import 'package:flutter/material.dart';

/// Modern Color Palette
class ModernColors {
  // Primary Gradient
  static const primaryStart = Color(0xFF6366F1); // Indigo
  static const primaryEnd = Color(0xFF8B5CF6); // Violet

  // Secondary Colors
  static const secondary = Color(0xFFEC4899); // Pink
  static const accent = Color(0xFF06B6D4); // Cyan

  // Backgrounds
  static const backgroundLight = Color(0xFFF1F5F9);
  static const backgroundDark = Color(0xFF0F172A);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1E293B);

  // Text Colors
  static const textPrimaryLight = Color(0xFF0F172A);
  static const textPrimaryDark = Color(0xFFF1F5F9);
  static const textSecondaryLight = Color(0xFF64748B);
  static const textSecondaryDark = Color(0xFF94A3B8);

  // Semantic Colors
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  // UI Elements
  static const borderLight = Color(0xFFE2E8F0);
  static const borderDark = Color(0xFF334155);
  static const shadowLight = Color(0x1A000000);
  static const shadowDark = Color(0x33000000);
}

/// Modern Typography
class ModernTypography {
  static TextStyle displayLarge(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 57,
    height: 1.1,
    fontWeight: FontWeight.w700,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: -0.25,
  );

  static TextStyle displayMedium(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 45,
    height: 1.1,
    fontWeight: FontWeight.w700,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: 0,
  );

  static TextStyle displaySmall(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 36,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: 0,
  );

  static TextStyle headlineLarge(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: -0.25,
  );

  static TextStyle headlineMedium(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: 0,
  );

  static TextStyle headlineSmall(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: 0,
  );

  static TextStyle titleLarge(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: 0.15,
  );

  static TextStyle titleMedium(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w600,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: 0.15,
  );

  static TextStyle titleSmall(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w600,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: 0.1,
  );

  static TextStyle bodyLarge(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: isDark
        ? ModernColors.textSecondaryDark
        : ModernColors.textSecondaryLight,
    letterSpacing: 0.5,
  );

  static TextStyle bodyMedium(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: isDark
        ? ModernColors.textSecondaryDark
        : ModernColors.textSecondaryLight,
    letterSpacing: 0.25,
  );

  static TextStyle bodySmall(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w400,
    color: isDark
        ? ModernColors.textSecondaryDark
        : ModernColors.textSecondaryLight,
    letterSpacing: 0.4,
  );

  static TextStyle labelLarge(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w500,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w500,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w500,
    color: isDark
        ? ModernColors.textPrimaryDark
        : ModernColors.textPrimaryLight,
    letterSpacing: 0.5,
  );
}

/// Modern Spacing System
class ModernSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double xxxxl = 48;
}

/// Modern Border Radius
class ModernRadius {
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double full = 9999;
}

/// Modern Shadows
class ModernShadows {
  static List<BoxShadow> level1(bool isDark) => [
    BoxShadow(
      color: isDark ? ModernColors.shadowDark : ModernColors.shadowLight,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> level2(bool isDark) => [
    BoxShadow(
      color: isDark ? ModernColors.shadowDark : ModernColors.shadowLight,
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> level3(bool isDark) => [
    BoxShadow(
      color: isDark ? ModernColors.shadowDark : ModernColors.shadowLight,
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> level4(bool isDark) => [
    BoxShadow(
      color: isDark ? ModernColors.shadowDark : ModernColors.shadowLight,
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

/// Modern Gradients
class ModernGradients {
  static LinearGradient primary(bool isDark) => LinearGradient(
    colors: [ModernColors.primaryStart, ModernColors.primaryEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient success(bool isDark) => LinearGradient(
    colors: [ModernColors.success.withOpacity(0.8), ModernColors.success],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient warning(bool isDark) => LinearGradient(
    colors: [ModernColors.warning.withOpacity(0.8), ModernColors.warning],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient error(bool isDark) => LinearGradient(
    colors: [ModernColors.error.withOpacity(0.8), ModernColors.error],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient info(bool isDark) => LinearGradient(
    colors: [ModernColors.info.withOpacity(0.8), ModernColors.info],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
