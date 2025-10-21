import 'package:flutter/material.dart';

/// DashboardTabWidget: Reusable tab widget for dashboard sections
///
/// Provides consistent tab styling with icon, title, and badge
class DashboardTabWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback? onTap;
  final int? badgeCount;
  final Color? activeColor;
  final Color? inactiveColor;

  const DashboardTabWidget({
    super.key,
    required this.icon,
    required this.title,
    this.isActive = false,
    this.onTap,
    this.badgeCount,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeColorValue = activeColor ?? const Color(0xFF1A2B4C);
    final inactiveColorValue = inactiveColor ?? const Color(0xFF999999);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive
              ? activeColorValue.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border(bottom: BorderSide(color: activeColorValue, width: 2))
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isActive ? activeColorValue : inactiveColorValue,
                ),
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? activeColorValue : inactiveColorValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
