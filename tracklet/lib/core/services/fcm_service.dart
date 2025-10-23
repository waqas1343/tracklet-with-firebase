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

  // Removed kDebugMode print statements
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
  
  // Getter for local notifications plugin
  FlutterLocalNotificationsPlugin get localNotifications => _localNotifications;
  
  // Setter for notification tap callback
  set onNotificationTap(NotificationTapCallback? callback) {
    _onNotificationTap = callback;
  }

  /// Initialize FCM service
  Future<void> initialize() async {
    if (_initialized) {
      // Removed kDebugMode print statement
      return;
    }

    try {
      // Removed kDebugMode print statements

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

      // Removed kDebugMode print statements
    } catch (e) {
      // Removed kDebugMode print statement
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      // Removed kDebugMode print statements

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      // Removed kDebugMode print statements

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Removed kDebugMode print statement
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        // Removed kDebugMode print statement
      } else {
        // Removed kDebugMode print statement
      }
    } catch (e) {
      // Removed kDebugMode print statement
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    try {
      // Removed kDebugMode print statements

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

      // Removed kDebugMode print statement
    } catch (e) {
      // Removed kDebugMode print statement
    }
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      // Removed kDebugMode print statements

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
        // Removed kDebugMode print statement
      } else {
        // Removed kDebugMode print statement
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        // Removed kDebugMode print statement
        _fcmToken = newToken;
        // Update token in Firestore if user is logged in
        _updateTokenInFirestore(newToken);
      });
    } catch (e) {
      // Removed kDebugMode print statement
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

    // Removed kDebugMode print statement
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // Removed kDebugMode print statements
    // Show local notification
    await _showLocalNotification(message);
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    // Removed kDebugMode print statements
    // Navigate to appropriate screen based on notification data
    _handleNotificationAction(message.data);
  }

  /// Handle notification action based on data
  void _handleNotificationAction(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    
    // Removed kDebugMode print statements
    
    if (type == 'order_approved') {
      final orderId = data['orderId'] as String?;
      // Removed kDebugMode print statements
      if (orderId != null && orderId.isNotEmpty) {
        // Call the callback if set
        // Removed kDebugMode print statements
        if (_onNotificationTap != null) {
          // Removed kDebugMode print statement
          _onNotificationTap!(orderId);
        } else {
          // Fallback to showing driver assignment dialog directly
          // Removed kDebugMode print statement
          _showDriverAssignmentDialog(orderId);
        }
      } else {
        // Removed kDebugMode print statement
      }
    } else {
      // Removed kDebugMode print statement
    }
  }

  /// Show driver assignment dialog
  void _showDriverAssignmentDialog(String orderId) {
    // This method would be called when we have access to the context
    // For now, we'll handle this in the main app widget
    // Removed kDebugMode print statements
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

      // Format payload as JSON for better parsing
      final payload = jsonEncode(message.data);

      await _localNotifications.show(
        message.hashCode,
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? '',
        notificationDetails,
        payload: payload,
      );

      // Removed kDebugMode print statements
    } catch (e) {
      // Removed kDebugMode print statement
    }
  }

  /// Handle notification tap from local notifications
  void _onNotificationTapped(NotificationResponse response) {
    // Removed kDebugMode print statements

    // Parse payload and handle action
    if (response.payload != null) {
      try {
        // Try to parse as JSON first
        final payloadData = jsonDecode(response.payload!);
        // Removed kDebugMode print statements
        
        final type = payloadData['type'] as String?;
        final orderId = payloadData['orderId'] as String?;
        
        if (type == 'order_approved' && orderId != null && orderId.isNotEmpty) {
          // Removed kDebugMode print statements
          // Call the callback if set
          if (_onNotificationTap != null) {
            _onNotificationTap!(orderId);
          } else {
            // Fallback to showing driver assignment dialog directly
            _showDriverAssignmentDialog(orderId);
          }
        } else {
          // Removed kDebugMode print statements
        }
      } catch (e) {
        // Removed kDebugMode print statements
        
        // Fallback to string parsing
        try {
          final payload = response.payload!;
          // Removed kDebugMode print statements
          
          if (payload.contains('order_approved') && payload.contains('orderId')) {
            // Extract order ID from payload (simplified approach)
            final startIndex = payload.indexOf('orderId') + 9;
            final endIndex = payload.indexOf(',', startIndex);
            final orderId = payload.substring(startIndex, endIndex).replaceAll("'", "").trim();
            
            if (orderId.isNotEmpty) {
              // Removed kDebugMode print statements
              // Call the callback if set
              if (_onNotificationTap != null) {
                _onNotificationTap!(orderId);
              } else {
                // Fallback to showing driver assignment dialog directly
                _showDriverAssignmentDialog(orderId);
              }
            } else {
              // Removed kDebugMode print statement
            }
          } else {
            // Removed kDebugMode print statement
          }
        } catch (e2) {
          // Removed kDebugMode print statements
        }
      }
    } else {
      // Removed kDebugMode print statement
    }
  }

  /// Save FCM token to Firestore for a user
  Future<void> saveFCMToken(String userId) async {
    if (_fcmToken == null) {
      // Removed kDebugMode print statement
      return;
    }

    try {
      // Removed kDebugMode print statements
      
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': _fcmToken,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });

      // Removed kDebugMode print statement
    } catch (e) {
      // Removed kDebugMode print statement
    }
  }

  /// Update token in Firestore
  Future<void> _updateTokenInFirestore(String token) async {
    // This will be called when token refreshes
    // You can get current user ID from your auth service
    // Removed kDebugMode print statement
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
        // Removed kDebugMode print statement
        return;
      }

      // Removed kDebugMode print statements

      // Check if we have a valid server key
      const serverKey = 'YOUR_SERVER_KEY_HERE'; // Replace with your actual server key
      if (serverKey == 'YOUR_SERVER_KEY_HERE') {
        // Removed kDebugMode print statements
        return;
      }

      // Send notification using HTTP request to Firebase Cloud Messaging API
      // Note: In a production app, this should be done through a secure backend
      // to protect your Firebase credentials
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
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
        // Removed kDebugMode print statements
      } else {
        // Removed kDebugMode print statements
      }
    } catch (e) {
      // Removed kDebugMode print statement
    }
  }

  /// Check if FCM is initialized
  bool get isInitialized => _initialized;
}