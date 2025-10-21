import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';
import '../viewmodels/notification_viewmodel.dart';

/// NotificationProvider - Manages notification data using MVVM pattern
/// Acts as a bridge between UI and NotificationViewModel
class NotificationProvider extends ChangeNotifier {
  final NotificationViewModel _viewModel;

  NotificationProvider()
    : _viewModel = NotificationViewModel(NotificationRepository()) {
    _viewModel.addListener(_onViewModelChanged);
  }

  // Getters - Delegate to ViewModel
  List<NotificationModel> get notifications => _viewModel.notifications;
  bool get isLoading => _viewModel.isLoading;
  String? get error => _viewModel.error;
  int get unreadCount => _viewModel.unreadCount;
  bool get hasNotifications => _viewModel.hasNotifications;
  List<NotificationModel> get unreadNotifications =>
      _viewModel.unreadNotifications;

  /// Load notifications for a specific user
  Future<void> loadNotificationsForUser(String userId) async {
    await _viewModel.loadNotificationsForUser(userId);
  }

  /// Listen to real-time notification updates for a user
  Stream<List<NotificationModel>> getNotificationsStreamForUser(String userId) {
    return _viewModel.getNotificationsStreamForUser(userId);
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    return await _viewModel.markAsRead(notificationId);
  }

  /// Mark all notifications as read for a user
  Future<bool> markAllAsRead(String userId) async {
    return await _viewModel.markAllAsRead(userId);
  }

  /// Load unread notifications count
  Future<void> loadUnreadCount(String userId) async {
    await _viewModel.loadUnreadCount(userId);
  }

  /// Delete a notification
  Future<bool> deleteNotification(String notificationId) async {
    return await _viewModel.deleteNotification(notificationId);
  }

  /// Delete all notifications for a user
  Future<bool> deleteAllNotifications(String userId) async {
    return await _viewModel.deleteAllNotifications(userId);
  }

  /// Create order notification for gas plant
  Future<void> createOrderNotification({
    required String plantId,
    required String distributorName,
    required String orderId,
  }) async {
    await _viewModel.createOrderNotification(
      plantId: plantId,
      distributorName: distributorName,
      orderId: orderId,
    );
  }

  /// Create order status notification for distributor
  Future<void> createOrderStatusNotification({
    required String distributorId,
    required String plantName,
    required String orderId,
    required String status,
  }) async {
    await _viewModel.createOrderStatusNotification(
      distributorId: distributorId,
      plantName: plantName,
      orderId: orderId,
      status: status,
    );
  }

  /// Refresh notifications
  Future<void> refreshNotifications(String userId) async {
    await _viewModel.refreshNotifications(userId);
  }

  /// Clear all data
  void clearData() {
    _viewModel.clearData();
  }

  /// Handle ViewModel changes
  void _onViewModelChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }
}