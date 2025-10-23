import 'package:flutter/material.dart';

class CustomFlushbar {
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFlushbar(
      context: context,
      message: message,
      title: title,
      duration: duration,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
      iconColor: Colors.white,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showFlushbar(
      context: context,
      message: message,
      title: title,
      duration: duration,
      backgroundColor: Colors.red,
      icon: Icons.error,
      iconColor: Colors.white,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFlushbar(
      context: context,
      message: message,
      title: title,
      duration: duration,
      backgroundColor: Colors.blue,
      icon: Icons.info,
      iconColor: Colors.white,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFlushbar(
      context: context,
      message: message,
      title: title,
      duration: duration,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
      iconColor: Colors.white,
    );
  }

  static void _showFlushbar({
    required BuildContext context,
    required String message,
    String? title,
    required Duration duration,
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
  }) {
    final scaffold = ScaffoldMessenger.of(context);
    
    // Remove any existing snackbars
    scaffold.removeCurrentSnackBar();
    
    // Show the custom flushbar
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  if (title != null) const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        elevation: 6,
      ),
    );
  }
}