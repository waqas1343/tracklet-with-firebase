// Side Navigation - Drawer/sidebar navigation for tablet/desktop
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/dashboard_provider.dart';

class SideNavigation extends StatelessWidget {
  const SideNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.surface,
        boxShadow: theme.shadowMd,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Logo & Title
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.primary, theme.secondary],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Super Admin', style: theme.heading3),
                ],
              ),
            ),

            const Divider(height: 1),

            const SizedBox(height: 16),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _NavItem(
                    icon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    isSelected: dashboardProvider.currentPageIndex == 0,
                    onTap: () => dashboardProvider.setCurrentPage(0),
                  ),
                  _NavItem(
                    icon: Icons.people_rounded,
                    label: 'Users',
                    isSelected: dashboardProvider.currentPageIndex == 1,
                    onTap: () => dashboardProvider.setCurrentPage(1),
                  ),
                  _NavItem(
                    icon: Icons.analytics_rounded,
                    label: 'Analytics',
                    isSelected: dashboardProvider.currentPageIndex == 2,
                    onTap: () => dashboardProvider.setCurrentPage(2),
                  ),
                  _NavItem(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    isSelected: dashboardProvider.currentPageIndex == 3,
                    onTap: () => dashboardProvider.setCurrentPage(3),
                  ),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'MANAGEMENT',
                      style: theme.caption.copyWith(
                        color: theme.textMuted,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  _NavItem(
                    icon: Icons.badge_rounded,
                    label: 'Roles',
                    isSelected: false,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.security_rounded,
                    label: 'Permissions',
                    isSelected: false,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.history_rounded,
                    label: 'Activity Logs',
                    isSelected: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // User Profile Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.primary.withOpacity(0.1),
                    backgroundImage: const NetworkImage(
                      'https://i.pravatar.cc/150?img=1',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin User',
                          style: theme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'admin@company.com',
                          style: theme.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout_rounded, color: theme.error),
                    onPressed: () {
                      // Handle logout
                    },
                    tooltip: 'Logout',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: theme.primary.withOpacity(0.3), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected ? theme.primary : theme.textMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: theme.bodyMedium.copyWith(
                      color: isSelected ? theme.primary : theme.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
