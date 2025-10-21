import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../services/fcm_service.dart';

/// ProfileInitializer - Initializes profile data after user login
/// This widget should be placed after successful authentication
class ProfileInitializer extends StatelessWidget {
  final Widget child;

  const ProfileInitializer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    // Initialize profile if not already done
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (profileProvider.currentUser == null && !profileProvider.isLoading) {
        await profileProvider.initializeProfile();
        
        // Save FCM token after profile is initialized
        if (profileProvider.currentUser != null) {
          final fcmService = FCMService.instance;
          await fcmService.saveFCMToken(profileProvider.currentUser!.id);
        }
      }
    });

    if (profileProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return child;
  }
}
