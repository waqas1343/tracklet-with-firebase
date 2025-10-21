import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

/// NotificationViewModel - Handles notification-related business logic
/// Follows MVVM pattern for separation of concerns
class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _repository;

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;
  int _unreadCount = 0;

  NotificationViewModel(this._repository);

  // Getters
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _unreadCount;
  bool get hasNotifications => _notifications.isNotEmpty;
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  /// Load notifications for a specific user
  Future<void> loadNotificationsForUser(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      _notifications = await _repository.getNotificationsForUser(userId);
      await _loadUnreadCount(userId);

      notifyListeners();
    } catch (e) {
      _setError('Failed to load notifications: ${e.toString()}');
      if (kDebugMode) {
        print('Error loading notifications: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Listen to real-time notification updates for a user
  Stream<List<NotificationModel>> getNotificationsStreamForUser(String userId) {
    // Load initial unread count
    _loadUnreadCount(userId);
    
    return _repository.getNotificationsStreamForUser(userId).map((
      notifications,
    ) {
      _notifications = notifications;
      notifyListeners();
      return notifications;
    });
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      // Don't set loading to true here to avoid UI blocking
      _clearError();

      final success = await _repository.markAsRead(notificationId);

      if (success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(isRead: true);
          _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
          notifyListeners();
        }
      }

      return success;
    } catch (e) {
      _setError('Failed to mark notification as read: ${e.toString()}');
      if (kDebugMode) {
        print('Error marking notification as read: $e');
      }
      return false;
    }
  }

  /// Mark all notifications as read for a user
  Future<bool> markAllAsRead(String userId) async {
    try {
      // Don't set loading to true here to avoid UI blocking
      _clearError();

      final success = await _repository.markAllAsRead(userId);

      if (success) {
        _notifications = _notifications
            .map((n) => n.copyWith(isRead: true))
            .toList();
        _unreadCount = 0;
        notifyListeners();
      }

      return success;
    } catch (e) {
      _setError('Failed to mark all notifications as read: ${e.toString()}');
      if (kDebugMode) {
        print('Error marking all notifications as read: $e');
      }
      return false;
    }
  }

  /// Load unread notifications count
  Future<void> loadUnreadCount(String userId) async {
    await _loadUnreadCount(userId);
  }

  /// Delete a notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      // Don't set loading to true here to avoid UI blocking
      _clearError();

      final success = await _repository.deleteNotification(notificationId);

      if (success) {
        _notifications.removeWhere((n) => n.id == notificationId);
        // Update unread count after deletion
        await _loadUnreadCount(_notifications.isNotEmpty ? 
          _notifications.first.recipientId : '');
        notifyListeners();
      }

      return success;
    } catch (e) {
      _setError('Failed to delete notification: ${e.toString()}');
      if (kDebugMode) {
        print('Error deleting notification: $e');
      }
      return false;
    }
  }

  /// Delete all notifications for a user
  Future<bool> deleteAllNotifications(String userId) async {
    try {
      // Don't set loading to true here to avoid UI blocking
      _clearError();

      final success = await _repository.deleteAllNotifications(userId);

      if (success) {
        _notifications.clear();
        _unreadCount = 0;
        notifyListeners();
      }

      return success;
    } catch (e) {
      _setError('Failed to delete all notifications: ${e.toString()}');
      if (kDebugMode) {
        print('Error deleting all notifications: $e');
      }
      return false;
    }
  }

  /// Create order notification for gas plant
  Future<void> createOrderNotification({
    required String plantId,
    required String distributorName,
    required String orderId,
  }) async {
    try {
      await _repository.createOrderNotification(
        plantId: plantId,
        distributorName: distributorName,
        orderId: orderId,
      );
      // Reload notifications for the plant user to show the new notification
      // This will be handled by the real-time stream
    } catch (e) {
      _setError('Failed to create order notification: ${e.toString()}');
      if (kDebugMode) {
        print('Error creating order notification: $e');
      }
    }
  }

  /// Create order status notification for distributor
  Future<void> createOrderStatusNotification({
    required String distributorId,
    required String plantName,
    required String orderId,
    required String status,
  }) async {
    try {
      await _repository.createOrderStatusNotification(
        distributorId: distributorId,
        plantName: plantName,
        orderId: orderId,
        status: status,
      );
      // Reload notifications for the distributor user to show the new notification
      // This will be handled by the real-time stream
    } catch (e) {
      _setError('Failed to create order status notification: ${e.toString()}');
      if (kDebugMode) {
        print('Error creating order status notification: $e');
      }
    }
  }

  /// Refresh notifications
  Future<void> refreshNotifications(String userId) async {
    await loadNotificationsForUser(userId);
  }

  /// Clear all data
  void clearData() {
    _notifications = [];
    _unreadCount = 0;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Load unread count (private method)
  Future<void> _loadUnreadCount(String userId) async {
    try {
      if (userId.isNotEmpty) {
        _unreadCount = await _repository.getUnreadCount(userId);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading unread count: $e');
      }
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}