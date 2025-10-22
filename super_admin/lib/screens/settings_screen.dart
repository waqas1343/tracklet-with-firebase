// Settings Screen - App settings with toggles and selects
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: theme.heading2),
          const SizedBox(height: 8),
          Text(
            'Manage your app preferences and configurations',
            style: theme.bodyMedium,
          ),

          const SizedBox(height: 32),

          // Appearance Section
          _SettingsSection(
            title: 'Appearance',
            children: [
              _SettingsTile(
                icon: Icons.palette_rounded,
                title: 'Dark Mode',
                subtitle: 'Toggle between light and dark theme',
                trailing: Switch(
                  value: theme.isDarkMode,
                  onChanged: (_) => theme.toggleTheme(),
                  activeColor: theme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Notifications Section
          _SettingsSection(
            title: 'Notifications',
            children: [
              _SettingsTile(
                icon: Icons.notifications_rounded,
                title: 'Enable Notifications',
                subtitle: 'Receive app notifications',
                trailing: Switch(
                  value: settings.notificationsEnabled,
                  onChanged: (value) => settings.toggleNotifications(value),
                  activeColor: theme.primary,
                ),
              ),
              _SettingsTile(
                icon: Icons.email_rounded,
                title: 'Email Notifications',
                subtitle: 'Receive updates via email',
                trailing: Switch(
                  value: settings.emailNotifications,
                  onChanged: (value) =>
                      settings.toggleEmailNotifications(value),
                  activeColor: theme.primary,
                ),
              ),
              _SettingsTile(
                icon: Icons.phone_android_rounded,
                title: 'Push Notifications',
                subtitle: 'Receive push notifications on mobile',
                trailing: Switch(
                  value: settings.pushNotifications,
                  onChanged: (value) => settings.togglePushNotifications(value),
                  activeColor: theme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Preferences Section
          _SettingsSection(
            title: 'Preferences',
            children: [
              _SettingsTile(
                icon: Icons.language_rounded,
                title: 'Language',
                subtitle: settings.language,
                trailing: PopupMenuButton<String>(
                  initialValue: settings.language,
                  icon: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: theme.textMuted,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) => settings.setLanguage(value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'English',
                      child: Text('English'),
                    ),
                    const PopupMenuItem(
                      value: 'Urdu',
                      child: Text('اردو (Urdu)'),
                    ),
                    const PopupMenuItem(
                      value: 'Arabic',
                      child: Text('العربية (Arabic)'),
                    ),
                  ],
                ),
              ),
              _SettingsTile(
                icon: Icons.save_rounded,
                title: 'Auto Save',
                subtitle: 'Automatically save changes',
                trailing: Switch(
                  value: settings.autoSave,
                  onChanged: (value) => settings.toggleAutoSave(value),
                  activeColor: theme.primary,
                ),
              ),
              _SettingsTile(
                icon: Icons.timer_rounded,
                title: 'Session Timeout',
                subtitle: '${settings.sessionTimeout} minutes',
                trailing: PopupMenuButton<int>(
                  initialValue: settings.sessionTimeout,
                  icon: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: theme.textMuted,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) => settings.setSessionTimeout(value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 15, child: Text('15 minutes')),
                    const PopupMenuItem(value: 30, child: Text('30 minutes')),
                    const PopupMenuItem(value: 60, child: Text('1 hour')),
                    const PopupMenuItem(value: 120, child: Text('2 hours')),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Reset Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset Settings'),
                    content: const Text(
                      'Are you sure you want to reset all settings to default values?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.error,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await settings.resetToDefaults();
                }
              },
              icon: Icon(Icons.restart_alt_rounded, color: theme.error),
              label: Text(
                'Reset to Defaults',
                style: TextStyle(color: theme.error),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: theme.caption.copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.divider.withOpacity(0.5), width: 1),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(height: 1, color: theme.divider.withOpacity(0.5)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 16),
          trailing,
        ],
      ),
    );
  }
}
