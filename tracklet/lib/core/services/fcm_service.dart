import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Callback type for handling notification taps
typedef NotificationTapCallback = void Function(String orderId);

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
  
  // Callback for handling notification taps
  NotificationTapCallback? _onNotificationTap;

  FCMService._();

  static FCMService get instance {
    _instance ??= FCMService._();
    return _instance!;
  }

  String? get fcmToken => _fcmToken;
  
  // Setter for notification tap callback
  set onNotificationTap(NotificationTapCallback? callback) {
    _onNotificationTap = callback;
  }

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
    _handleNotificationAction(message.data);
  }

  /// Handle notification action based on data
  void _handleNotificationAction(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    
    if (type == 'order_approved') {
      final orderId = data['orderId'] as String?;
      if (orderId != null) {
        // Call the callback if set
        if (_onNotificationTap != null) {
          _onNotificationTap!(orderId);
        } else {
          // Fallback to showing driver assignment dialog directly
          _showDriverAssignmentDialog(orderId);
        }
      }
    }
  }

  /// Show driver assignment dialog
  void _showDriverAssignmentDialog(String orderId) {
    // This method would be called when we have access to the context
    // For now, we'll handle this in the main app widget
    if (kDebugMode) {
      print('🔔 Order approved notification tapped for order: $orderId');
    }
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

    // Parse payload and handle action
    if (response.payload != null) {
      try {
        // This is a simplified parsing, in real app you might want to use JSON
        final payload = response.payload!;
        if (payload.contains('order_approved') && payload.contains('orderId')) {
          // Extract order ID from payload (simplified approach)
          final startIndex = payload.indexOf('orderId') + 9;
          final endIndex = payload.indexOf(',', startIndex);
          final orderId = payload.substring(startIndex, endIndex).replaceAll("'", "").trim();
          
          if (orderId.isNotEmpty) {
            // Call the callback if set
            if (_onNotificationTap != null) {
              _onNotificationTap!(orderId);
            } else {
              // Fallback to showing driver assignment dialog directly
              _showDriverAssignmentDialog(orderId);
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error parsing notification payload: $e');
        }
      }
    }
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
        print('Data: $data');
      }

      // Send notification using HTTP request to Firebase Cloud Messaging API
      // Note: In a production app, this should be done through a secure backend
      // to protect your Firebase credentials
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=YOUR_SERVER_KEY_HERE', // Replace with your actual server key
        },
        body: jsonEncode({
          'to': fcmToken,
          'notification': {
            'title': title,
            'body': body,
            'sound': 'default',
          },
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ Notification sent successfully');
          print('Response: ${response.body}');
        }
      } else {
        if (kDebugMode) {
          print('❌ Failed to send notification. Status code: ${response.statusCode}');
          print('Response: ${response.body}');
        }
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