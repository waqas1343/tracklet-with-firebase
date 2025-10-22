// Style Tokens - Design System
// Sari colors, typography, aur spacing yahan define hain

import 'package:flutter/material.dart';

/// Light Theme Colors
class AppColorsLight {
  // Primary & Secondary
  static const primary = Color(0xFF6366F1); // Indigo
  static const primaryVariant = Color(0xFF4F46E5);
  static const secondary = Color(0xFFEC4899); // Pink
  static const secondaryVariant = Color(0xFFDB2777);

  // Backgrounds
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF1F5F9);

  // Text
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textMuted = Color(0xFF94A3B8);

  // Semantic
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  // On Colors
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF0F172A);

  // Glass & Effects
  static const glassBlur = Color(0x1AFFFFFF);
  static const shadow = Color(0x1A000000);
  static const divider = Color(0xFFE2E8F0);
}

/// Dark Theme Colors
class AppColorsDark {
  // Primary & Secondary
  static const primary = Color(0xFF818CF8); // Lighter Indigo
  static const primaryVariant = Color(0xFF6366F1);
  static const secondary = Color(0xFFF472B6); // Lighter Pink
  static const secondaryVariant = Color(0xFFEC4899);

  // Backgrounds
  static const background = Color(0xFF0F172A);
  static const surface = Color(0xFF1E293B);
  static const surfaceVariant = Color(0xFF334155);

  // Text
  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFFCBD5E1);
  static const textMuted = Color(0xFF64748B);

  // Semantic
  static const success = Color(0xFF34D399);
  static const warning = Color(0xFFFBBF24);
  static const error = Color(0xFFF87171);
  static const info = Color(0xFF60A5FA);

  // On Colors
  static const onPrimary = Color(0xFF0F172A);
  static const onSurface = Color(0xFFF1F5F9);

  // Glass & Effects
  static const glassBlur = Color(0x1AFFFFFF);
  static const shadow = Color(0x33000000);
  static const divider = Color(0xFF334155);
}

/// Typography Scale
class StyleTokens {
  // Text Styles
  static TextStyle heading1(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    height: 1.2,
    fontWeight: FontWeight.bold,
    color: isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle heading2(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle heading3(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    height: 1.4,
    fontWeight: FontWeight.w600,
    color: isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary,
  );

  static TextStyle bodyLarge(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary,
  );

  static TextStyle bodyMedium(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary,
  );

  static TextStyle bodySmall(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: isDark ? AppColorsDark.textMuted : AppColorsLight.textMuted,
  );

  static TextStyle caption(bool isDark) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    height: 1.3,
    fontWeight: FontWeight.w500,
    color: isDark ? AppColorsDark.textMuted : AppColorsLight.textMuted,
    letterSpacing: 0.3,
  );

  // Spacing Scale (8px base)
  static const spacing = {
    'xs': 4.0,
    'sm': 8.0,
    'md': 12.0,
    'base': 16.0,
    'lg': 24.0,
    'xl': 32.0,
    'xxl': 40.0,
    'xxxl': 48.0,
  };

  // Border Radius
  static const borderRadius = {
    'sm': 8.0,
    'md': 12.0,
    'lg': 16.0,
    'xl': 24.0,
    'full': 9999.0,
  };

  // Animation Durations
  static const animationDurations = {
    'fast': Duration(milliseconds: 150),
    'normal': Duration(milliseconds: 300),
    'slow': Duration(milliseconds: 500),
    'verySlow': Duration(milliseconds: 900),
  };

  // Shadows
  static List<BoxShadow> shadowSm(bool isDark) => [
    BoxShadow(
      color: isDark ? AppColorsDark.shadow : AppColorsLight.shadow,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMd(bool isDark) => [
    BoxShadow(
      color: isDark ? AppColorsDark.shadow : AppColorsLight.shadow,
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLg(bool isDark) => [
    BoxShadow(
      color: isDark ? AppColorsDark.shadow : AppColorsLight.shadow,
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  // Glassmorphism Effect
  static BoxDecoration glassDecoration(bool isDark) => BoxDecoration(
    color: isDark
        ? AppColorsDark.surface.withOpacity(0.7)
        : AppColorsLight.surface.withOpacity(0.7),
    borderRadius: BorderRadius.circular(borderRadius['lg']!),
    border: Border.all(
      color: isDark
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.05),
      width: 1,
    ),
    boxShadow: shadowMd(isDark),
  );
}
