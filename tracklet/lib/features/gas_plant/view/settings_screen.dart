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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - Exact match to image
              const Text(
                'Setting',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // Setting Options - Exact spacing from image
              _buildSettingTile('Manage Plant', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManagePlantScreen(),
                  ),
                );
              }),
              const SizedBox(height: 12),

              _buildSettingTile('New Orders', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewOrdersScreen(),
                  ),
                );
              }),
              const SizedBox(height: 12),

              _buildSettingTile('Sales Summary', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SalesSummaryScreen(),
                  ),
                );
              }),
              const SizedBox(height: 12),

              _buildSettingTile('Profile Settings', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileSettingsScreen(),
                  ),
                );
              }),
              const SizedBox(height: 12),

              _buildSettingTile('Change Password', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              }),
              const SizedBox(height: 12),

              _buildSettingTile('Download Reports', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadReportsScreen(),
                  ),
                );
              }),
              const SizedBox(height: 32),

              // Language Section - Exact match to image
              const Text(
                'Language',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Language Toggle - Exact positioning from image
              Row(
                children: [
                  const Text(
                    'Eng',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: true, // Set to Urdu position as shown in image
                    onChanged: (value) {
                      // Language toggle functionality
                    },
                    activeThumbColor: Colors.blue,
                    activeTrackColor: Colors.blue.withValues(alpha: 0.3),
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Urdu',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Logout Button - Exact design from image
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2B4C), // Dark blue as in image
                  borderRadius: BorderRadius.circular(25), // Oval shape
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
              ),

              const Spacer(),

              // Legal Links - Exact positioning from image
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to Legal Notice
                    },
                    child: const Text(
                      'Legal Notice',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to Privacy Policy
                    },
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(String title, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300, // Light gray border as in image
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8), // Slightly rounded corners
        color: Colors.white, // White background
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
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
}
