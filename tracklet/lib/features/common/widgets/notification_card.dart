import 'package:flutter/material.dart';
import '../../../core/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationCard({super.key, required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {}
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with circular background
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  _getNotificationIcon(),
                  color: _getIconColor(),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                        ),
                        Text(
                          _formatTime(notification.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon() {
    final title = notification.title.toLowerCase();

    // Employee/User related
    if (title.contains('employee') || title.contains('added successfully')) {
      return Icons.person_add;
    }
    // Report related
    if (title.contains('report') || title.contains('downloaded')) {
      return Icons.description;
    }
    // Gas/Tank related
    if (title.contains('gas') && !title.contains('freeze')) {
      return Icons.add_circle_outline;
    }
    // Maintenance related
    if (title.contains('maintenance')) {
      return Icons.warning;
    }
    // Tank related
    if (title.contains('tank')) {
      return Icons.local_shipping;
    }
    // Freeze related
    if (title.contains('freeze')) {
      return Icons.ac_unit;
    }
    // Order cancelled
    if (title.contains('cancelled')) {
      return Icons.cancel;
    }
    // Order completed
    if (title.contains('completed')) {
      return Icons.check_circle;
    }
    // Driver assigned
    if (title.contains('driver')) {
      return Icons.local_shipping;
    }
    // Order approved
    if (title.contains('approved')) {
      return Icons.check_circle;
    }
    // New request
    if (title.contains('request')) {
      return Icons.receipt_long;
    }

    // Default
    return Icons.notifications;
  }

  Color _getIconBackgroundColor() {
    final title = notification.title.toLowerCase();

    // Employee - Green
    if (title.contains('employee') || title.contains('added successfully')) {
      return const Color(0xFFE8F5E9);
    }
    // Report - Blue
    if (title.contains('report') || title.contains('downloaded')) {
      return const Color(0xFFE3F2FD);
    }
    // Gas Added - Light Green
    if (title.contains('gas') && !title.contains('freeze')) {
      return const Color(0xFFE8F5E9);
    }
    // Maintenance - Yellow/Orange
    if (title.contains('maintenance')) {
      return const Color(0xFFFFF9C4);
    }
    // Tank - Blue
    if (title.contains('tank')) {
      return const Color(0xFFE3F2FD);
    }
    // Freeze - Light Blue
    if (title.contains('freeze')) {
      return const Color(0xFFE0F7FA);
    }
    // Cancelled - Red
    if (title.contains('cancelled')) {
      return const Color(0xFFFFEBEE);
    }
    // Completed - Green
    if (title.contains('completed')) {
      return const Color(0xFFE8F5E9);
    }
    // Driver - Yellow
    if (title.contains('driver')) {
      return const Color(0xFFFFF9C4);
    }
    // Approved - Green
    if (title.contains('approved')) {
      return const Color(0xFFE8F5E9);
    }
    // Request - Blue
    if (title.contains('request')) {
      return const Color(0xFFE3F2FD);
    }

    // Default - Grey
    return const Color(0xFFF5F5F5);
  }

  Color _getIconColor() {
    final title = notification.title.toLowerCase();

    // Employee - Green
    if (title.contains('employee') || title.contains('added successfully')) {
      return const Color(0xFF4CAF50);
    }
    // Report - Blue
    if (title.contains('report') || title.contains('downloaded')) {
      return const Color(0xFF2196F3);
    }
    // Gas Added - Green
    if (title.contains('gas') && !title.contains('freeze')) {
      return const Color(0xFF4CAF50);
    }
    // Maintenance - Orange
    if (title.contains('maintenance')) {
      return const Color(0xFFFFC107);
    }
    // Tank - Blue
    if (title.contains('tank')) {
      return const Color(0xFF2196F3);
    }
    // Freeze - Cyan
    if (title.contains('freeze')) {
      return const Color(0xFF00BCD4);
    }
    // Cancelled - Red
    if (title.contains('cancelled')) {
      return const Color(0xFFF44336);
    }
    // Completed - Green
    if (title.contains('completed')) {
      return const Color(0xFF4CAF50);
    }
    // Driver - Orange/Yellow
    if (title.contains('driver')) {
      return const Color(0xFFFFC107);
    }
    // Approved - Green
    if (title.contains('approved')) {
      return const Color(0xFF4CAF50);
    }
    // Request - Blue
    if (title.contains('request')) {
      return const Color(0xFF2196F3);
    }

    // Default - Grey
    return const Color(0xFF9E9E9E);
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }
}
