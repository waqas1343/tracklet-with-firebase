import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';
import 'fcm_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

/// NotificationService - Handles all notification operations
/// This service ensures notifications are created and delivered properly
class NotificationService {
  static NotificationService? _instance;
  final NotificationRepository _repository = NotificationRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NotificationService._();

  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  /// Create order approval notification for distributor
  Future<void> createOrderApprovalNotification({
    required String distributorId,
    required String plantName,
    required String orderId,
  }) async {
    try {
      print('🔔 NotificationService: Creating order approval notification');
      print('   Distributor ID: $distributorId');
      print('   Plant Name: $plantName');
      print('   Order ID: $orderId');

      // Create the notification
      final notification = NotificationModel(
        id: '',
        title: 'Order Approved',
        message: 'Your order is approved, please assign a driver.',
        type: NotificationType.order,
        relatedId: orderId,
        recipientId: distributorId,
        senderId: null,
        createdAt: DateTime.now(),
      );

      // Also send a local notification with proper payload for FCM service
      try {
        await _sendLocalNotification(orderId, distributorId);
      } catch (e) {
        print('⚠️ Failed to send local notification: $e');
      }

      // Save to Firestore
      final notificationId = await _repository.createNotification(notification);

      print('✅ NotificationService: Order approval notification created');
      print('   Notification ID: $notificationId');
      print('   Title: ${notification.title}');
      print('   Message: ${notification.message}');
      print('   Recipient: ${notification.recipientId}');

      // Verify the notification was created
      await _verifyNotificationCreated(notificationId, distributorId);
    } catch (e) {
      print(
        '❌ NotificationService: Error creating order approval notification: $e',
      );
      rethrow;
    }
  }

  /// Verify notification was created successfully
  Future<void> _verifyNotificationCreated(
    String notificationId,
    String distributorId,
  ) async {
    try {
      final doc = await _firestore
          .collection('notifications')
          .doc(notificationId)
          .get();

      if (doc.exists) {
        print('✅ NotificationService: Notification verified in Firestore');
        print('   Document ID: ${doc.id}');
        print('   Data: ${doc.data()}');
      } else {
        print('❌ NotificationService: Notification not found in Firestore');
      }
    } catch (e) {
      print('❌ NotificationService: Error verifying notification: $e');
    }
  }

  /// Send local notification with proper payload for FCM service
  Future<void> _sendLocalNotification(
    String orderId,
    String distributorId,
  ) async {
    try {
      print('🔔 NotificationService: Sending local notification');
      print('   Order ID: $orderId');
      print('   Distributor ID: $distributorId');

      final fcmService = FCMService.instance;
      final localNotifications = fcmService.localNotifications;

      const androidDetails = AndroidNotificationDetails(
        'order_channel',
        'Order Notifications',
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

      // Create proper JSON payload
      final payload = jsonEncode({
        'type': 'order_approved',
        'orderId': orderId,
        'distributorId': distributorId,
      });

      await localNotifications.show(
        DateTime.now().millisecondsSinceEpoch,
        'Order Approved',
        'Your order is approved, please assign a driver.',
        notificationDetails,
        payload: payload,
      );

      print('✅ NotificationService: Local notification sent');
      print('   Payload: $payload');
    } catch (e) {
      print('❌ NotificationService: Error sending local notification: $e');
      rethrow;
    }
  }

  /// Create driver assignment notification for distributor
  Future<void> createDriverAssignmentNotification({
    required String distributorId,
    required String plantName,
    required String orderId,
    required String driverName,
  }) async {
    try {
      print('🔔 NotificationService: Creating driver assignment notification');
      print('   Distributor ID: $distributorId');
      print('   Plant Name: $plantName');
      print('   Order ID: $orderId');
      print('   Driver Name: $driverName');

      final notification = NotificationModel(
        id: '',
        title: 'Driver Assigned',
        message: 'Driver $driverName has been assigned to your order.',
        type: NotificationType.order,
        relatedId: orderId,
        recipientId: distributorId,
        senderId: null,
        createdAt: DateTime.now(),
      );

      await _repository.createNotification(notification);
      print('✅ NotificationService: Driver assignment notification created');
    } catch (e) {
      print(
        '❌ NotificationService: Error creating driver assignment notification: $e',
      );
      rethrow;
    }
  }

  /// Create order completion notification for distributor
  Future<void> createOrderCompletionNotification({
    required String distributorId,
    required String plantName,
    required String orderId,
  }) async {
    try {
      print('🔔 NotificationService: Creating order completion notification');
      print('   Distributor ID: $distributorId');
      print('   Plant Name: $plantName');
      print('   Order ID: $orderId');

      final notification = NotificationModel(
        id: '',
        title: 'Order Completed',
        message: 'Your order from $plantName has been completed successfully.',
        type: NotificationType.order,
        relatedId: orderId,
        recipientId: distributorId,
        senderId: null,
        createdAt: DateTime.now(),
      );

      await _repository.createNotification(notification);
      print('✅ NotificationService: Order completion notification created');
    } catch (e) {
      print(
        '❌ NotificationService: Error creating order completion notification: $e',
      );
      rethrow;
    }
  }

  /// Create driver assignment notification for gas plant
  Future<void> createDriverAssignmentNotificationForGasPlant({
    required String plantId,
    required String distributorName,
    required String orderId,
    required String driverName,
  }) async {
    try {
      print(
        '🔔 NotificationService: Creating driver assignment notification for gas plant',
      );
      print('   Plant ID: $plantId');
      print('   Distributor Name: $distributorName');
      print('   Order ID: $orderId');
      print('   Driver Name: $driverName');

      final notification = NotificationModel(
        id: '',
        title: 'Driver Assigned',
        message:
            'Driver $driverName has been assigned to order from $distributorName.',
        type: NotificationType.order,
        relatedId: orderId,
        recipientId: plantId,
        senderId: null,
        createdAt: DateTime.now(),
      );

      await _repository.createNotification(notification);
      print(
        '✅ NotificationService: Driver assignment notification for gas plant created',
      );
    } catch (e) {
      print(
        '❌ NotificationService: Error creating driver assignment notification for gas plant: $e',
      );
      rethrow;
    }
  }

  /// Create new order notification for gas plant
  Future<void> createNewOrderNotification({
    required String plantId,
    required String distributorName,
    required String orderId,
  }) async {
    try {
      print('🔔 NotificationService: Creating new order notification');
      print('   Plant ID: $plantId');
      print('   Distributor Name: $distributorName');
      print('   Order ID: $orderId');

      final notification = NotificationModel(
        id: '',
        title: 'New Order Request',
        message: '$distributorName has requested cylinders from your plant.',
        type: NotificationType.order,
        relatedId: orderId,
        recipientId: plantId,
        senderId: null,
        createdAt: DateTime.now(),
      );

      await _repository.createNotification(notification);
      print('✅ NotificationService: New order notification created');
    } catch (e) {
      print('❌ NotificationService: Error creating new order notification: $e');
      rethrow;
    }
  }

  /// Create test notification for debugging
  Future<void> createTestNotification(String distributorId) async {
    try {
      print(
        '🧪 NotificationService: Creating test notification for distributor: $distributorId',
      );

      final notification = NotificationModel(
        id: '',
        title: 'Test Notification',
        message: 'This is a test notification to verify the system is working.',
        type: NotificationType.order,
        relatedId: 'test-order-123',
        recipientId: distributorId,
        senderId: null,
        createdAt: DateTime.now(),
      );

      final notificationId = await _repository.createNotification(notification);
      print(
        '✅ NotificationService: Test notification created with ID: $notificationId',
      );
    } catch (e) {
      print('❌ NotificationService: Error creating test notification: $e');
    }
  }

  /// Get notifications for a user
  Future<List<NotificationModel>> getNotificationsForUser(String userId) async {
    try {
      print('📥 NotificationService: Fetching notifications for user: $userId');
      final notifications = await _repository.getNotificationsForUser(userId);
      print(
        '✅ NotificationService: Loaded ${notifications.length} notifications',
      );
      return notifications;
    } catch (e) {
      print('❌ NotificationService: Error fetching notifications: $e');
      return [];
    }
  }

  /// Get notifications stream for real-time updates
  Stream<List<NotificationModel>> getNotificationsStreamForUser(String userId) {
    print(
      '🔔 NotificationService: Creating notification stream for user: $userId',
    );
    return _repository.getNotificationsStreamForUser(userId);
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      print(
        '📖 NotificationService: Marking notification as read: $notificationId',
      );
      final success = await _repository.markAsRead(notificationId);
      if (success) {
        print('✅ NotificationService: Notification marked as read');
      } else {
        print('❌ NotificationService: Failed to mark notification as read');
      }
      return success;
    } catch (e) {
      print('❌ NotificationService: Error marking notification as read: $e');
      return false;
    }
  }

  /// Mark all notifications as read for a user
  Future<bool> markAllAsRead(String userId) async {
    try {
      print(
        '📖 NotificationService: Marking all notifications as read for user: $userId',
      );
      final success = await _repository.markAllAsRead(userId);
      if (success) {
        print('✅ NotificationService: All notifications marked as read');
      } else {
        print(
          '❌ NotificationService: Failed to mark all notifications as read',
        );
      }
      return success;
    } catch (e) {
      print(
        '❌ NotificationService: Error marking all notifications as read: $e',
      );
      return false;
    }
  }

  /// Get unread count for a user
  Future<int> getUnreadCount(String userId) async {
    try {
      print('🔢 NotificationService: Getting unread count for user: $userId');
      final count = await _repository.getUnreadCount(userId);
      print('✅ NotificationService: Unread count: $count');
      return count;
    } catch (e) {
      print('❌ NotificationService: Error getting unread count: $e');
      return 0;
    }
  }

  /// Delete a notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      print('🗑️ NotificationService: Deleting notification: $notificationId');
      final success = await _repository.deleteNotification(notificationId);
      if (success) {
        print('✅ NotificationService: Notification deleted');
      } else {
        print('❌ NotificationService: Failed to delete notification');
      }
      return success;
    } catch (e) {
      print('❌ NotificationService: Error deleting notification: $e');
      return false;
    }
  }

  /// Refresh notifications for a user (useful for testing)
  Future<void> refreshNotificationsForUser(String userId) async {
    try {
      print(
        '🔄 NotificationService: Refreshing notifications for user: $userId',
      );
      final notifications = await getNotificationsForUser(userId);
      print(
        '✅ NotificationService: Refreshed ${notifications.length} notifications',
      );
    } catch (e) {
      print('❌ NotificationService: Error refreshing notifications: $e');
    }
  }

  /// Test the complete notification flow
  Future<void> testCompleteNotificationFlow(String distributorId) async {
    try {
      print('🧪 NotificationService: Testing complete notification flow');
      print('   Distributor ID: $distributorId');

      // Create test order approval notification
      await createOrderApprovalNotification(
        distributorId: distributorId,
        plantName: 'Test Plant',
        orderId: 'test-order-${DateTime.now().millisecondsSinceEpoch}',
      );

      // Wait a moment
      await Future.delayed(const Duration(seconds: 1));

      // Get notifications for the user
      final notifications = await getNotificationsForUser(distributorId);
      print(
        '✅ NotificationService: Found ${notifications.length} notifications for user',
      );

      // Print notification details
      for (var notification in notifications) {
        print(
          '   Notification: ${notification.title} - ${notification.message}',
        );
      }
    } catch (e) {
      print('❌ NotificationService: Error in test flow: $e');
    }
  }
}
