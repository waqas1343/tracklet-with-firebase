// Side Navigation - Drawer/sidebar navigation for tablet/desktop
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/login_provider.dart';
import '../shared/widgets/custom_button.dart';

class SideNavigation extends StatelessWidget {
  const SideNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.modernSurface,
        boxShadow: theme.shadowLevel3,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Logo & Title
            Padding(
              padding: EdgeInsets.all(theme.spacingLg),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(theme.spacingMd),
                    decoration: BoxDecoration(
                      gradient: theme.primaryGradient,
                      borderRadius: BorderRadius.circular(theme.radiusMd),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Super Admin',
                    style: theme.headlineSmall.copyWith(
                      color: theme.modernTextPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            const SizedBox(height: 16),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: theme.spacingMd),
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
                    padding: EdgeInsets.symmetric(horizontal: theme.spacingLg),
                    child: Text(
                      'MANAGEMENT',
                      style: theme.labelSmall.copyWith(
                        color: theme.modernTextSecondary,
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
              padding: EdgeInsets.all(theme.spacingLg),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: theme.primaryGradient,
                          borderRadius: BorderRadius.circular(theme.radiusFull),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin User',
                              style: theme.titleMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.modernTextPrimary,
                              ),
                            ),
                            Text(
                              'admin@company.com',
                              style: theme.bodySmall.copyWith(
                                color: theme.modernTextSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Logout Button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.error.withValues(alpha: 0.8),
                          theme.error,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(theme.radiusMd),
                      boxShadow: theme.shadowLevel2,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: CustomButton(
                        text: 'Logout',
                        onPressed: () {
                          // Show confirmation dialog
                          showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              );
                            },
                          ).then((confirm) {
                            if (confirm == true) {
                              // Perform logout
                              Provider.of<LoginProvider>(
                                context,
                                listen: false,
                              ).logout();
                              // Navigate to login screen
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (route) => false,
                              );
                            }
                          });
                        },
                        backgroundColor: Colors.transparent,
                        textColor: Colors.white,
                        borderRadius: theme.radiusMd,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
          borderRadius: BorderRadius.circular(theme.radiusMd),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacingLg,
              vertical: theme.spacingMd,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.modernPrimaryStart.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(theme.radiusMd),
              border: isSelected
                  ? Border.all(
                      color: theme.modernPrimaryStart.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? theme.modernPrimaryStart
                      : theme.modernTextSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: theme.labelLarge.copyWith(
                      color: isSelected
                          ? theme.modernPrimaryStart
                          : theme.modernTextSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.modernPrimaryStart,
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
