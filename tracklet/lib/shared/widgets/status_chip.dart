import 'package:flutter/material.dart';

/// StatusChip - A reusable status indicator widget
/// 
/// This widget provides a consistent way to display status information
/// throughout the application with standardized colors and styling.
class StatusChip extends StatelessWidget {
  final String status;
  final StatusType statusType;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? padding;
  final bool showIcon;

  const StatusChip({
    super.key,
    required this.status,
    required this.statusType,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(statusType);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: padding ?? 12,
        vertical: padding != null ? padding! / 2 : 6,
      ),
      decoration: BoxDecoration(
        color: statusInfo.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusInfo.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              statusInfo.icon,
              size: fontSize != null ? fontSize! * 1.2 : 14,
              color: statusInfo.textColor,
            ),
            SizedBox(width: 4),
          ],
          Text(
            status,
            style: TextStyle(
              fontSize: fontSize ?? 12,
              fontWeight: fontWeight ?? FontWeight.w600,
              color: statusInfo.textColor,
            ),
          ),
        ],
      ),
    );
  }

  StatusInfo _getStatusInfo(StatusType type) {
    switch (type) {
      case StatusType.pending:
        return StatusInfo(
          backgroundColor: const Color(0xFFFFF3E0),
          borderColor: const Color(0xFFFF9800),
          textColor: const Color(0xFFFF9800),
          icon: Icons.pending_actions,
        );
      case StatusType.inProgress:
        return StatusInfo(
          backgroundColor: const Color(0xFFE3F2FD),
          borderColor: const Color(0xFF1A2B4C),
          textColor: const Color(0xFF1A2B4C),
          icon: Icons.local_shipping,
        );
      case StatusType.completed:
        return StatusInfo(
          backgroundColor: const Color(0xFFE8F5E9),
          borderColor: const Color(0xFF4CAF50),
          textColor: const Color(0xFF4CAF50),
          icon: Icons.check_circle,
        );
      case StatusType.cancelled:
        return StatusInfo(
          backgroundColor: const Color(0xFFFFEBEE),
          borderColor: const Color(0xFFF44336),
          textColor: const Color(0xFFF44336),
          icon: Icons.cancel,
        );
      case StatusType.confirmed:
        return StatusInfo(
          backgroundColor: const Color(0xFFE8F5E9),
          borderColor: const Color(0xFF4CAF50),
          textColor: const Color(0xFF4CAF50),
          icon: Icons.check_circle_outline,
        );
      case StatusType.active:
        return StatusInfo(
          backgroundColor: const Color(0xFFE3F2FD),
          borderColor: const Color(0xFF1A2B4C),
          textColor: const Color(0xFF1A2B4C),
          icon: Icons.check,
        );
    }
  }
}

/// Status information data class
class StatusInfo {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final IconData icon;

  StatusInfo({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.icon,
  });
}

/// Status types used throughout the application
enum StatusType {
  pending,
  inProgress,
  completed,
  cancelled,
  confirmed,
  active,
}