// Modern Settings Screen - Redesigned UI for settings
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';

class ModernSettingsScreen extends StatelessWidget {
  const ModernSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: theme.modernBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: theme.headlineMedium.copyWith(
                color: theme.modernTextPrimary,
              ),
            ),
            const SizedBox(height: 32),

            // Theme Settings Card
            Container(
              padding: EdgeInsets.all(theme.spacingLg),
              decoration: BoxDecoration(
                color: theme.modernSurface,
                borderRadius: BorderRadius.circular(theme.radiusLg),
                boxShadow: theme.shadowLevel1,
                border: Border.all(color: theme.modernBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.modernPrimaryStart.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(theme.radiusFull),
                        ),
                        child: Icon(
                          theme.isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: theme.modernPrimaryStart,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Theme',
                              style: theme.titleMedium.copyWith(
                                color: theme.modernTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Choose between light and dark mode',
                              style: theme.bodySmall.copyWith(
                                color: theme.modernTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: theme.isDarkMode,
                        onChanged: (value) => theme.toggleTheme(),
                        activeThumbColor: theme.modernPrimaryStart,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Notification Settings Card
            Container(
              padding: EdgeInsets.all(theme.spacingLg),
              decoration: BoxDecoration(
                color: theme.modernSurface,
                borderRadius: BorderRadius.circular(theme.radiusLg),
                boxShadow: theme.shadowLevel1,
                border: Border.all(color: theme.modernBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.modernPrimaryStart.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(theme.radiusFull),
                        ),
                        child: Icon(
                          Icons.notifications_rounded,
                          color: theme.modernPrimaryStart,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notifications',
                              style: theme.titleMedium.copyWith(
                                color: theme.modernTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manage your notification preferences',
                              style: theme.bodySmall.copyWith(
                                color: theme.modernTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildNotificationSetting(
                    context,
                    theme,
                    'Email Notifications',
                    'Receive email updates',
                    settingsProvider.emailNotifications,
                    (value) => settingsProvider.toggleEmailNotifications(value),
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationSetting(
                    context,
                    theme,
                    'Push Notifications',
                    'Receive push notifications',
                    settingsProvider.pushNotifications,
                    (value) => settingsProvider.togglePushNotifications(value),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Account Settings Card
            Container(
              padding: EdgeInsets.all(theme.spacingLg),
              decoration: BoxDecoration(
                color: theme.modernSurface,
                borderRadius: BorderRadius.circular(theme.radiusLg),
                boxShadow: theme.shadowLevel1,
                border: Border.all(color: theme.modernBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.modernPrimaryStart.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(theme.radiusFull),
                        ),
                        child: Icon(
                          Icons.account_circle_rounded,
                          color: theme.modernPrimaryStart,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account',
                              style: theme.titleMedium.copyWith(
                                color: theme.modernTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manage your account settings',
                              style: theme.bodySmall.copyWith(
                                color: theme.modernTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildAccountSetting(
                    context,
                    theme,
                    'Change Password',
                    'Update your password',
                    Icons.lock_rounded,
                    () {
                      // Handle change password
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildAccountSetting(
                    context,
                    theme,
                    'Privacy Settings',
                    'Manage your privacy preferences',
                    Icons.privacy_tip_rounded,
                    () {
                      // Handle privacy settings
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildAccountSetting(
                    context,
                    theme,
                    'Delete Account',
                    'Permanently delete your account',
                    Icons.delete_rounded,
                    () {
                      // Handle delete account
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSetting(
    BuildContext context,
    ThemeProvider theme,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.bodyMedium.copyWith(
                  color: theme.modernTextPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.bodySmall.copyWith(
                  color: theme.modernTextSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: theme.modernPrimaryStart,
        ),
      ],
    );
  }

  Widget _buildAccountSetting(
    BuildContext context,
    ThemeProvider theme,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(theme.spacingMd),
        decoration: BoxDecoration(
          color: theme.modernSurface,
          borderRadius: BorderRadius.circular(theme.radiusMd),
          border: Border.all(color: theme.modernBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.modernPrimaryStart, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.bodyMedium.copyWith(
                      color: theme.modernTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.bodySmall.copyWith(
                      color: theme.modernTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.modernTextSecondary),
          ],
        ),
      ),
    );
  }
}
