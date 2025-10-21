import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

/// NotificationRepository - Handles all Firestore operations for notifications
class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _notificationsCollection = 'notifications';

  /// Create a new notification
  Future<String> createNotification(NotificationModel notification) async {
    try {
      final docRef = await _firestore
          .collection(_notificationsCollection)
          .add(notification.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  /// Get notifications for a specific user
  Future<List<NotificationModel>> getNotificationsForUser(String userId) async {
    try {
      print('📥 Fetching notifications for user: $userId');

      final querySnapshot = await _firestore
          .collection(_notificationsCollection)
          .where('recipientId', isEqualTo: userId)
          .get();

      final notifications = querySnapshot.docs
          .map(
            (doc) => NotificationModel.fromJson({...doc.data(), 'id': doc.id}),
          )
          .toList();

      // Sort in memory instead of using Firestore orderBy
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print('✅ Loaded ${notifications.length} notifications');
      return notifications;
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  /// Get notifications stream for a user (real-time updates)
  Stream<List<NotificationModel>> getNotificationsStreamForUser(String userId) {
    print('🔔 Creating notification stream for user: $userId');

    return _firestore
        .collection(_notificationsCollection)
        .where('recipientId', isEqualTo: userId)
        .snapshots()
        .handleError((error) {
          print('❌ Notification stream error: $error');
        })
        .map((snapshot) {
          print('✅ Notification stream update - Docs: ${snapshot.docs.length}');

          final notifications = snapshot.docs
              .map(
                (doc) =>
                    NotificationModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList();

          // Sort in memory instead of using Firestore orderBy
          notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          print('📬 Parsed ${notifications.length} notifications');
          return notifications;
        });
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .update({'isRead': true});
      return true;
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read for a user
  Future<bool> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final querySnapshot = await _firestore
          .collection(_notificationsCollection)
          .where('recipientId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
      return true;
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  /// Get unread notifications count for a user
  Future<int> getUnreadCount(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_notificationsCollection)
          .where('recipientId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to fetch unread count: $e');
    }
  }

  /// Delete a notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Delete all notifications for a user
  Future<bool> deleteAllNotifications(String userId) async {
    try {
      final batch = _firestore.batch();
      final querySnapshot = await _firestore
          .collection(_notificationsCollection)
          .where('recipientId', isEqualTo: userId)
          .get();

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return true;
    } catch (e) {
      throw Exception('Failed to delete all notifications: $e');
    }
  }

  /// Create order notification for gas plant
  Future<void> createOrderNotification({
    required String plantId,
    required String distributorName,
    required String orderId,
  }) async {
    try {
      print('Creating notification for plant: $plantId');
      print('Distributor: $distributorName, Order ID: $orderId');

      final notification = NotificationModel(
        id: '',
        title: 'New Order Request',
        message: '$distributorName has requested cylinders from your plant',
        type: NotificationType.order,
        relatedId: orderId,
        recipientId: plantId,
        senderId: null,
        createdAt: DateTime.now(),
      );

      final notificationId = await createNotification(notification);
      print('Notification created with ID: $notificationId');
    } catch (e) {
      print('Error creating order notification: $e');
      throw Exception('Failed to create order notification: $e');
    }
  }

  /// Create order status update notification for distributor
  Future<void> createOrderStatusNotification({
    required String distributorId,
    required String plantName,
    required String orderId,
    required String status,
  }) async {
    try {
      String message = '';
      switch (status.toLowerCase()) {
        case 'confirmed':
          message = 'Your order from $plantName has been confirmed';
          break;
        case 'in_progress':
          message = 'Your order from $plantName is being processed';
          break;
        case 'completed':
          message = 'Your order from $plantName has been completed';
          break;
        case 'cancelled':
          message = 'Your order from $plantName has been cancelled';
          break;
        default:
          message = 'Your order from $plantName status has been updated';
      }

      final notification = NotificationModel(
        id: '',
        title: 'Order Update',
        message: message,
        type: NotificationType.order,
        relatedId: orderId,
        recipientId: distributorId,
        senderId: null,
        createdAt: DateTime.now(),
      );

      await createNotification(notification);
    } catch (e) {
      print('Error creating order status notification: $e');
      throw Exception('Failed to create order status notification: $e');
    }
  }
}
