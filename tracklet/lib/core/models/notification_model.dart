import 'package:flutter/material.dart';

/// Notification Model - Represents a notification
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final String? relatedId; // Order ID, User ID, etc.
  final String recipientId;
  final String? senderId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    required this.recipientId,
    this.senderId,
    this.isRead = false,
    required this.createdAt,
  });

  /// Create NotificationModel from Firestore JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: _parseNotificationType(json['type']),
      relatedId: json['relatedId'],
      recipientId: json['recipientId'] ?? '',
      senderId: json['senderId'],
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Convert NotificationModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'relatedId': relatedId,
      'recipientId': recipientId,
      'senderId': senderId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    String? relatedId,
    String? recipientId,
    String? senderId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
      recipientId: recipientId ?? this.recipientId,
      senderId: senderId ?? this.senderId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static NotificationType _parseNotificationType(dynamic type) {
    if (type == null) return NotificationType.order;

    final typeString = type.toString().toLowerCase();
    switch (typeString) {
      case 'order':
        return NotificationType.order;
      case 'system':
        return NotificationType.system;
      case 'reminder':
        return NotificationType.reminder;
      case 'alert':
        return NotificationType.alert;
      default:
        return NotificationType.order;
    }
  }

  /// Get notification icon
  IconData get icon {
    switch (type) {
      case NotificationType.order:
        return Icons.shopping_cart;
      case NotificationType.system:
        return Icons.system_update;
      case NotificationType.reminder:
        return Icons.notifications;
      case NotificationType.alert:
        return Icons.warning;
    }
  }

  /// Get notification color
  Color get color {
    switch (type) {
      case NotificationType.order:
        return Colors.blue;
      case NotificationType.system:
        return Colors.green;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.alert:
        return Colors.red;
    }
  }

  /// Get formatted time
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

enum NotificationType { order, system, reminder, alert }
