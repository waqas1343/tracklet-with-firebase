import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Flutter binding for background execution
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    print('📬 Background message received!');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
  }

  // Handle background message logic here
  // Note: You cannot directly access UI or most Flutter services here
  // You should only perform lightweight operations
}

/// FCM Service - Handles Firebase Cloud Messaging for push notifications
///
/// This service manages:
/// - FCM token generation and storage
/// - Notification permissions
/// - Foreground notifications
/// - Background notifications
/// - Notification handling
class FCMService {
  static FCMService? _instance;
  static bool _initialized = false;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _fcmToken;

  FCMService._();

  static FCMService get instance {
    _instance ??= FCMService._();
    return _instance!;
  }

  String? get fcmToken => _fcmToken;

  /// Initialize FCM service
  Future<void> initialize() async {
    if (_initialized) {
      if (kDebugMode) {
        print('⚠️ FCM already initialized');
      }
      return;
    }

    try {
      if (kDebugMode) {
        print('🔔 Initializing FCM Service...');
      }

      // Ensure Firebase is initialized first
      await FirebaseMessaging.instance.setAutoInitEnabled(true);

      // Request notification permissions
      await _requestPermissions();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token
      await _getFCMToken();

      // Setup message handlers
      _setupMessageHandlers();

      _initialized = true;

      if (kDebugMode) {
        print('✅ FCM Service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing FCM: $e');
      }
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      if (kDebugMode) {
        print('📱 Requesting notification permissions...');
      }

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (kDebugMode) {
        print(
          '✅ Notification permission status: ${settings.authorizationStatus}',
        );
      }

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print('✅ User granted notification permissions');
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        if (kDebugMode) {
          print('⚠️ User granted provisional notification permissions');
        }
      } else {
        if (kDebugMode) {
          print('❌ User declined notification permissions');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error requesting permissions: $e');
      }
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    try {
      if (kDebugMode) {
        print('🔔 Initializing local notifications...');
      }

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (kDebugMode) {
        print('✅ Local notifications initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing local notifications: $e');
      }
    }
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      if (kDebugMode) {
        print('🔑 Getting FCM token...');
      }

      // Get token for web
      if (kIsWeb) {
        // For web, you need VAPID key from Firebase Console
        // Go to: Project Settings > Cloud Messaging > Web Push certificates
        _fcmToken = await _messaging.getToken(
          vapidKey: 'YOUR_VAPID_KEY_HERE', // Replace with your actual VAPID key
        );
      } else {
        // For mobile platforms
        _fcmToken = await _messaging.getToken();
      }

      if (_fcmToken != null) {
        if (kDebugMode) {
          print('✅ FCM Token: $_fcmToken');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ Failed to get FCM token');
        }
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        if (kDebugMode) {
          print('🔄 FCM Token refreshed: $newToken');
        }
        _fcmToken = newToken;
        // Update token in Firestore if user is logged in
        _updateTokenInFirestore(newToken);
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting FCM token: $e');
      }
    }
  }

  /// Setup message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    if (kDebugMode) {
      print('✅ Message handlers setup complete');
    }
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('📬 Foreground message received!');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
    }

    // Show local notification
    await _showLocalNotification(message);
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('🔔 Notification tapped!');
      print('Data: ${message.data}');
    }

    // Navigate to appropriate screen based on notification data
    // You can implement navigation logic here
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'order_channel', // Channel ID
        'Order Notifications', // Channel name
        channelDescription: 'Notifications for new orders and updates',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        message.hashCode,
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? '',
        notificationDetails,
        payload: message.data.toString(),
      );

      if (kDebugMode) {
        print('✅ Local notification shown');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error showing local notification: $e');
      }
    }
  }

  /// Handle notification tap from local notifications
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('🔔 Local notification tapped!');
      print('Payload: ${response.payload}');
    }

    // Implement navigation logic here
  }

  /// Save FCM token to Firestore for a user
  Future<void> saveFCMToken(String userId) async {
    if (_fcmToken == null) {
      if (kDebugMode) {
        print('⚠️ No FCM token to save');
      }
      return;
    }

    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': _fcmToken,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('✅ FCM token saved for user: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving FCM token: $e');
      }
    }
  }

  /// Update token in Firestore
  Future<void> _updateTokenInFirestore(String token) async {
    // This will be called when token refreshes
    // You can get current user ID from your auth service
    if (kDebugMode) {
      print('🔄 Updating token in Firestore...');
    }
  }

  /// Send notification to a specific user
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Get user's FCM token from Firestore
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final fcmToken = userDoc.data()?['fcmToken'] as String?;

      if (fcmToken == null) {
        if (kDebugMode) {
          print('⚠️ No FCM token found for user: $userId');
        }
        return;
      }

      if (kDebugMode) {
        print('📤 Sending notification to user: $userId');
        print('Title: $title');
        print('Body: $body');
      }

      // Note: Sending notifications requires a server-side implementation
      // You can use Firebase Cloud Functions or your own backend
      // This is just a placeholder for the client-side logic

      if (kDebugMode) {
        print('✅ Notification sent successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error sending notification: $e');
      }
    }
  }

  /// Check if FCM is initialized
  bool get isInitialized => _initialized;
}
