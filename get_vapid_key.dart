/*
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Run this to get your FCM token for testing
///
/// Usage: dart run get_vapid_key.dart
void main() async {
  // Removed print statements
  /*
  print('🔑 Getting Firebase Cloud Messaging Token...\n');

  try {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Get FCM instance
    final messaging = FirebaseMessaging.instance;

    // Request permissions
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('✅ Permission status: ${settings.authorizationStatus}\n');

    // Get token
    final token = await messaging.getToken();

    if (token != null) {
      print('🎯 YOUR FCM TOKEN:');
      print('─' * 80);
      print(token);
      print('─' * 80);
      print('\n✅ Copy this token and use it for testing push notifications');
      print('📝 You can send test notifications from Firebase Console:\n');
      print('   1. Go to Firebase Console → Cloud Messaging');
      print('   2. Click "Send test message"');
      print('   3. Paste this token');
      print('   4. Send notification\n');
    } else {
      print('❌ Failed to get FCM token');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
  */
}
*/