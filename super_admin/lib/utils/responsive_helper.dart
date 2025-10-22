// Responsive Helper - Screen size detection aur adaptive layouts
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const phoneBreakpoint = 600.0;
  static const tabletBreakpoint = 900.0;
  static const desktopBreakpoint = 1200.0;

  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < phoneBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= phoneBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  static bool useMobileLayout(BuildContext context) {
    return MediaQuery.of(context).size.width < phoneBreakpoint;
  }

  static bool useTabletLayout(BuildContext context) {
    return MediaQuery.of(context).size.width >= phoneBreakpoint;
  }

  static double getResponsiveValue({
    required BuildContext context,
    required double phone,
    required double tablet,
    required double desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return phone;
  }

  static int getGridColumns(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 2;
    return 1;
  }
}
