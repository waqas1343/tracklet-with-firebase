import 'package:flutter/material.dart';
import '../../core/utils/app_colors.dart';

/// TopSection: Reusable top section widget
///
/// Provides consistent header styling with title and subtitle
class TopSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? child;
  final EdgeInsets? padding;
  final CrossAxisAlignment crossAxisAlignment;

  const TopSection({
    super.key,
    required this.title,
    this.subtitle,
    this.child,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (child != null) ...[const SizedBox(height: 24), child!],
        ],
      ),
    );
  }
}
