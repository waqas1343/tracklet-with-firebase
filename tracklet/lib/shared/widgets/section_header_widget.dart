import 'package:flutter/material.dart';
import '../../core/utils/app_colors.dart';
import 'custom_button.dart';

/// SectionHeaderWidget: Reusable section header with title and "See All" button
///
/// Provides consistent section header styling across the app
class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String? seeAllText;
  final VoidCallback? onSeeAllPressed;
  final EdgeInsets? padding;
  final bool showSeeAll;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.seeAllText,
    this.onSeeAllPressed,
    this.padding,
    this.showSeeAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (showSeeAll)
            CustomButton(
              text: seeAllText ?? 'See All',
              onPressed:
                  onSeeAllPressed ??
                  () {
                    // Default navigation - can be overridden
                    Navigator.of(context).pushNamed('/see-all');
                  },
              backgroundColor: Colors.transparent,
              textColor: AppColors.primary,
              borderColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              fontSize: 14,
            ),
        ],
      ),
    );
  }
}
