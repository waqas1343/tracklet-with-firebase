import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/utils/app_text_theme.dart';
import '../../../core/utils/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.currentUser;

    // Load notifications when screen builds
    if (user != null &&
        !notificationProvider.isLoading &&
        notificationProvider.notifications.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (kDebugMode) {
          print('📥 Loading notifications for user: ${user.id}');
        }
        notificationProvider.loadNotificationsForUser(user.id);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        userName: 'Notifications',
        showBackButton: true,
      ),
      body: SafeArea(
        child: user == null
            ? const Center(child: Text('User not logged in'))
            : notificationProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : notificationProvider.notifications.isEmpty
            ? _buildEmptyState()
            : Column(
                children: [
                  // Mark all as read button
                  if (notificationProvider.unreadCount > 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: TextButton(
                        onPressed: () => _markAllAsRead(
                          context,
                          user.id,
                          notificationProvider,
                        ),
                        child: Text(
                          'Mark all as read',
                          style: AppTextTheme.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Notifications list
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () =>
                          notificationProvider.refreshNotifications(user.id),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notificationProvider.notifications.length,
                        itemBuilder: (context, index) {
                          final notification =
                              notificationProvider.notifications[index];
                          return _buildNotificationCard(
                            context,
                            notification,
                            notificationProvider,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: AppTextTheme.titleLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll receive notifications here',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel notification,
    NotificationProvider notificationProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead
              ? Colors.grey.shade300
              : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: notification.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(notification.icon, color: notification.color, size: 24),
        ),
        title: Text(
          notification.title,
          style: AppTextTheme.titleMedium.copyWith(
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notification.formattedTime,
              style: AppTextTheme.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () =>
            _onNotificationTap(context, notification, notificationProvider),
      ),
    );
  }

  void _onNotificationTap(
    BuildContext context,
    NotificationModel notification,
    NotificationProvider notificationProvider,
  ) {
    // Mark as read if not already read
    if (!notification.isRead) {
      notificationProvider.markAsRead(notification.id);
    }

    // Navigate based on notification type and related ID
    if (notification.type == NotificationType.order &&
        notification.relatedId != null) {
      // Navigate to order details or new orders screen
      // You can implement navigation logic here
    }
  }

  Future<void> _markAllAsRead(
    BuildContext context,
    String userId,
    NotificationProvider notificationProvider,
  ) async {
    final success = await notificationProvider.markAllAsRead(userId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'All notifications marked as read',
            style: AppTextTheme.bodyMedium.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
