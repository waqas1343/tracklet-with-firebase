import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../settings/manage_plant_screen.dart';
import '../settings/sales_summary_screen.dart';
import '../settings/profile_settings_screen.dart';
import '../settings/change_password_screen.dart';
import '../settings/download_reports_screen.dart';
import 'new_orders_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // 🔹 Settings Options
              ...[
                _buildSettingTile(context, 'Manage Plant', const ManagePlantScreen()),
                _buildSettingTile(context, 'New Orders', const NewOrdersScreen()),
                _buildSettingTile(context, 'Sales Summary', const SalesSummaryScreen()),
                _buildSettingTile(context, 'Profile Settings', const ProfileSettingsScreen()),
                _buildSettingTile(context, 'Change Password', const ChangePasswordScreen()),
                _buildSettingTile(context, 'Download Reports', const DownloadReportsScreen()),
              ].expand((widget) => [widget, const SizedBox(height: 12)]),

              const SizedBox(height: 20),

              // 🔹 Language Section
              const Text(
                'Language',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Text('Eng', style: TextStyle(fontSize: 14, color: Colors.black)),
                  const SizedBox(width: 8),
                  Switch(
                    value: true, // Urdu active
                    onChanged: (value) {
                      // TODO: Language switch
                    },
                    activeThumbColor: Colors.blue,
                    activeTrackColor: Colors.blue.withOpacity(0.3),
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 8),
                  const Text('Urdu', style: TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),

              const SizedBox(height: 32),

              // 🔹 Logout Button
              _buildLogoutButton(context),

              const Spacer(),

              // 🔹 Legal Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLegalLink('Legal Notice'),
                  _buildLegalLink('Privacy Policy'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Reusable Tile Widget
  Widget _buildSettingTile(BuildContext context, String title, Widget destination) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Logout Button with Confirmation
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B4C),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Logout'),
                    ),
                  ],
                );
              },
            );

            if (confirm == true) {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.exit_to_app, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Footer Links
  Widget _buildLegalLink(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
    );
  }
}
