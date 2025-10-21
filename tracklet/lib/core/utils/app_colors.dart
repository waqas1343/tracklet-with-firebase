import 'package:flutter/material.dart';

/// AppColors: Centralized color management for the entire app
///
/// Provides consistent color scheme across all screens and components
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1A2B4C);
  static const Color primaryLight = Color(0xFF4A5B7C);
  static const Color primaryDark = Color(0xFF0F1A2B);

  // Secondary Colors
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color secondaryLight = Color(0xFF7EDDD6);
  static const Color secondaryDark = Color(0xFF2BB5AB);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Status Specific Colors
  static const Color cancelled = Color(0xFFF44336);
  static const Color completed = Color(0xFF4CAF50);
  static const Color inProgress = Color(0xFFFF9800);
  static const Color pending = Color(0xFF9E9E9E);

  // Order Status Colors
  static const Color orderPending = Color(0xFF9E9E9E);
  static const Color orderProcessing = Color(0xFFFF9800);
  static const Color orderCompleted = Color(0xFF4CAF50);
  static const Color orderCancelled = Color(0xFFF44336);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textLight = Color(0xFFAAAAAA);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundSecondary = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1A1A1A);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderDark = Color(0xFFCCCCCC);

  // Grey Colors
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF424242);

  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1A1A1A);
  static const Color cardShadow = Color(0x1A000000);

  // Tag Colors
  static const Color tagBackground = Color(0xFF333333);
  static const Color tagText = Color(0xFFFFFFFF);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF1A2B4C);
  static const Color buttonSecondary = Color(0xFFFFFFFF);
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color buttonTextSecondary = Color(0xFF1A2B4C);

  // Icon Colors
  static const Color iconPrimary = Color(0xFF1A2B4C);
  static const Color iconSecondary = Color(0xFF666666);
  static const Color iconLight = Color(0xFF999999);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
