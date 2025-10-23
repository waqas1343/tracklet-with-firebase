import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/models/order_model.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../../../shared/widgets/custom_flushbar.dart';
import '../../distributor/provider/driver_provider.dart';
import '../../distributor/widgets/driver_assignment_dialog.dart';
import '../widgets/notification_card.dart';

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
        notificationProvider.loadNotificationsForUser(user.id);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: user == null
            ? const Center(child: Text('User not logged in'))
            : notificationProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : Column(
                children: [
                  // Simple Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Section Title
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: const Text(
                      'Order Updates & Alerts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  ),

                  // Notifications list
                  Expanded(
                    child: notificationProvider.notifications.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  size: 80,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No notifications yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'You\'ll see notifications here when they arrive',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => notificationProvider
                                .refreshNotifications(user.id),
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount:
                                  notificationProvider.notifications.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey[100],
                                indent: 84,
                              ),
                              itemBuilder: (context, index) {
                                final notification =
                                    notificationProvider.notifications[index];
                                return NotificationCard(
                                  notification: notification,
                                  onTap: () => _onNotificationTap(
                                    context,
                                    notification,
                                    notificationProvider,
                                  ),
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



  void _onNotificationTap(
    BuildContext context,
    NotificationModel notification,
    NotificationProvider notificationProvider,
  ) async {

    // Mark as read if not already read
    if (!notification.isRead) {
      notificationProvider.markAsRead(notification.id);
    }

    // Navigate based on notification type and related ID
    if (notification.type == NotificationType.order &&
        notification.relatedId != null) {
      // Get the order to determine its status and navigate accordingly
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      final user = profileProvider.currentUser;

      if (user != null) {
        try {
          final order = await orderProvider.getOrderById(
            notification.relatedId!,
          );

          if (order != null) {

            // Check if this is a Distributor user and the order is approved (inProgress)
            if ((user.role == 'distributor' || user.role == 'Distributor') &&
                order.status == OrderStatus.inProgress) {

              // Show driver assignment dialog for Distributor users
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ChangeNotifierProvider(
                      create: (context) => DriverProvider(),
                      child: DriverAssignmentDialog(
                        order: order,
                        onAssignmentComplete: () {
                          // Refresh orders after assignment
                          orderProvider.loadOrdersForDistributor(user.id);
                        },
                      ),
                    );
                  },
                );
              }
              return;
            }

            // Fallback: Check if this is an order approval notification for any user
            if (notification.title == 'Order Approved' &&
                notification.message.contains('assign a driver') &&
                order.status == OrderStatus.inProgress) {

              // Show driver assignment dialog
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ChangeNotifierProvider(
                      create: (context) => DriverProvider(),
                      child: DriverAssignmentDialog(
                        order: order,
                        onAssignmentComplete: () {
                          // Refresh orders after assignment
                          if (user.role == 'distributor' ||
                              user.role == 'Distributor') {
                            orderProvider.loadOrdersForDistributor(user.id);
                          }
                        },
                      ),
                    );
                  },
                );
              }
              return;
            }

            // Navigate to the appropriate screen based on order status and user role
            if (user.role == 'gas_plant') {
              // Gas Plant user navigation
              switch (order.status) {
                case OrderStatus.pending:
                case OrderStatus.confirmed:
                  // Navigate to new orders screen (dashboard)
                  if (context.mounted) {
                    Navigator.pushNamed(context, '/gas-plant/dashboard');
                    // Show a snackbar to indicate which order was selected
                    if (context.mounted) {
                      CustomFlushbar.showInfo(
                        context,
                        message: 'Check new orders for order from ${order.distributorName}',
                      );
                    }
                  }
                  break;
                case OrderStatus.inProgress:
                  // Navigate to orders in progress screen with highlighted order
                  if (context.mounted) {
                    Navigator.pushNamed(
                      context,
                      '/gas-plant/orders-in-progress',
                      arguments: {'highlightedOrderId': order.id},
                    );
                  }
                  break;
                case OrderStatus.completed:
                case OrderStatus.cancelled:
                  // Navigate to orders history screen with highlighted order
                  if (context.mounted) {
                    Navigator.pushNamed(
                      context,
                      '/gas-plant/orders',
                      arguments: {'highlightedOrderId': order.id},
                    );
                  }
                  break;
              }
            } else if (user.role == 'distributor') {
              // Distributor user navigation
              if (context.mounted) {
                Navigator.pushNamed(context, '/distributor/orders');
                if (context.mounted) {
                  CustomFlushbar.showInfo(
                    context,
                    message: 'Showing order from ${order.plantName}',
                  );
                }
              }
            }
          } else {
            // If order not found, navigate to the appropriate screen based on user role
            if (context.mounted) {
              if (user.role == 'gas_plant') {
                Navigator.pushNamed(context, '/gas-plant/orders');
              } else if (user.role == 'distributor') {
                Navigator.pushNamed(context, '/distributor/orders');
              }
              if (context.mounted) {
                CustomFlushbar.showWarning(
                  context,
                  message: 'Order not found, showing all orders',
                );
              }
            }
          }
        } catch (e) {
          // Navigate to appropriate orders screen as fallback
          if (context.mounted) {
            if (user.role == 'gas_plant') {
              Navigator.pushNamed(context, '/gas-plant/orders');
            } else if (user.role == 'distributor') {
              Navigator.pushNamed(context, '/distributor/orders');
            }
            if (context.mounted) {
              CustomFlushbar.showError(
                context,
                message: 'Error loading order, showing all orders',
              );
            }
          }
        }
      }
    }
  }
}
