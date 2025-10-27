import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracklet/features/distributor/view/distributor_change_password.dart';
import 'package:tracklet/features/distributor/view/order_analaytics.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../common/view/profile_screen.dart';
import '../../../core/utils/app_colors.dart';

class DistributorSettingsScreen extends StatelessWidget {
  const DistributorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showBackButton: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Order Analytics
              Card(
                child: ListTile(
                  title: const Text('Order Analytics'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderAnalyticsScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Profile Settings
              Card(
                child: ListTile(
                  title: const Text('Profile Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DistributorProfileSetting(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Change Password
              Card(
                child: ListTile(
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DistributorChangePassword(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              SizedBox(
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
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
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
                  backgroundColor:
                      AppColors.buttonPrimary, // Explicitly using red color
                  textColor: Colors.white,
                  borderRadius: 12, // More rounded corners
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
