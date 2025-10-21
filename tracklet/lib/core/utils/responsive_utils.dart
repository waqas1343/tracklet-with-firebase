import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMaxWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMaxWidth && width < tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletMaxWidth;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double responsiveWidth(BuildContext context, double percentage) {
    return screenWidth(context) * percentage / 100;
  }

  static double responsiveHeight(BuildContext context, double percentage) {
    return screenHeight(context) * percentage / 100;
  }

  static double responsiveFontSize(BuildContext context, double baseSize) {
    final width = screenWidth(context);
    if (width < mobileMaxWidth) {
      return baseSize;
    } else if (width < tabletMaxWidth) {
      return baseSize * 1.2;
    } else {
      return baseSize * 1.4;
    }
  }

  static EdgeInsets responsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  static double responsiveSpacing(BuildContext context) {
    if (isMobile(context)) {
      return 16.0;
    } else if (isTablet(context)) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  static int gridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }
}

// Extension for easier usage
extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  double get screenWidth => ResponsiveUtils.screenWidth(this);
  double get screenHeight => ResponsiveUtils.screenHeight(this);

  double responsiveWidth(double percentage) {
    return ResponsiveUtils.responsiveWidth(this, percentage);
  }

  double responsiveHeight(double percentage) {
    return ResponsiveUtils.responsiveHeight(this, percentage);
  }

  double responsiveFontSize(double baseSize) {
    return ResponsiveUtils.responsiveFontSize(this, baseSize);
  }

  EdgeInsets get responsivePadding => ResponsiveUtils.responsivePadding(this);
  double get responsiveSpacing => ResponsiveUtils.responsiveSpacing(this);
  int get gridCrossAxisCount => ResponsiveUtils.gridCrossAxisCount(this);
}
