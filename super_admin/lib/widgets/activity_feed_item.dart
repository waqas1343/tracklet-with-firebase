// Activity Feed Item - Single activity log item
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../models/activity_model.dart';

class ActivityFeedItem extends StatelessWidget {
  final ActivityModel activity;
  final int index;

  const ActivityFeedItem({
    super.key,
    required this.activity,
    required this.index,
  });

  IconData _getIconForType(ActivityType type) {
    switch (type) {
      case ActivityType.login:
        return Icons.login_rounded;
      case ActivityType.update:
        return Icons.edit_rounded;
      case ActivityType.create:
        return Icons.add_circle_rounded;
      case ActivityType.delete:
        return Icons.delete_rounded;
      case ActivityType.settings:
        return Icons.settings_rounded;
      case ActivityType.upload:
        return Icons.upload_rounded;
      case ActivityType.download:
        return Icons.download_rounded;
      case ActivityType.notification:
        return Icons.notifications_rounded;
    }
  }

  Color _getColorForType(ActivityType type, ThemeProvider theme) {
    switch (type) {
      case ActivityType.login:
        return theme.info;
      case ActivityType.update:
        return theme.warning;
      case ActivityType.create:
        return theme.success;
      case ActivityType.delete:
        return theme.error;
      case ActivityType.settings:
        return theme.textMuted;
      case ActivityType.upload:
        return theme.primary;
      case ActivityType.download:
        return theme.secondary;
      case ActivityType.notification:
        return theme.info;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final activityColor = _getColorForType(activity.type, theme);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.divider.withOpacity(0.5), width: 1),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: activityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIconForType(activity.type),
                color: activityColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.action,
                    style: theme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${activity.userName} • ${activity.description}',
                    style: theme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Timestamp
            Text(
              _formatTimestamp(activity.timestamp),
              style: theme.caption.copyWith(color: theme.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
