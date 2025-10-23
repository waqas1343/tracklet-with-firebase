import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracklet/core/widgets/custom_appbar.dart';
import 'package:tracklet/shared/widgets/custom_button.dart';
import '../../../core/utils/app_colors.dart';
import '../settings/manage_plant_screen.dart';
import '../settings/sales_summary_screen.dart';
import '../settings/profile_settings_screen.dart';
import '../settings/change_password_screen.dart';
import '../settings/download_reports_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(),

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
                _buildSettingTile(
                  context,
                  'Manage Plant',
                  const ManagePlantScreen(),
                ),
                _buildSettingTile(
                  context,
                  'Sales Summary',
                  SalesSummaryScreen(),
                ),
                _buildSettingTile(
                  context,
                  'Profile Settings',
                  const ProfileSettingsScreen(),
                ),
                _buildSettingTile(
                  context,
                  'Change Password',
                  const ChangePasswordScreen(),
                ),
                _buildSettingTile(
                  context,
                  'Download Reports',
                  const DownloadReportsScreen(),
                ),
              ].expand((widget) => [widget, const SizedBox(height: 12)]),

              const SizedBox(height: 20),

              // 🔹 Language Section

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Row(
                      children: [
                        const Text(
                          'Eng',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        Switch(
                          value: true,
                          onChanged: (value) {},
                          activeThumbColor: Colors.blue,
                          activeTrackColor: Colors.blue,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey.shade300,
                        ),
                        const Text(
                          'Urdu',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLegalLink('Legal Notice'),
                  _buildLegalLink('Privacy Policy'),
                ],
              ),
              // 🔹 Logout Button
              _buildLogoutButton(context),

              const Spacer(),

              // 🔹 Legal Links
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Reusable Tile Widget
  Widget _buildSettingTile(
    BuildContext context,
    String title,
    Widget destination,
  ) {
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
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
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Logout Button with Confirmation
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CustomButton(
        text: 'Logout',
        onPressed: () async {
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
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            }
          }
        },
        backgroundColor: AppColors.buttonPrimary, // Using app's error color
        textColor: AppColors.white,
        borderRadius: 12, // More rounded corners
        fontWeight: FontWeight.bold, // Bold text
        icon: Icons.exit_to_app, // Adding icon
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