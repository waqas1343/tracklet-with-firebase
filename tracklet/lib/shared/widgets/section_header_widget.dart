import 'package:flutter/material.dart';
import '../../core/utils/app_colors.dart';

/// Custom SeeAllButton widget
class SeeAllButton extends StatelessWidget {
  final VoidCallback onTap;

  const SeeAllButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.softBlue,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 11,
            left: 11,
            bottom: 4,
            top: 4,
          ),
          child: Text("See all", style: TextStyle(color: AppColors.onBackground,fontSize: 14)), // Replaced onPrimary with onBackground
        ),
      ),
    );
  }
}

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
    return Row(
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
          SeeAllButton(
            onTap: onSeeAllPressed ?? () {
              Navigator.of(context).pushNamed('/see-all');
            },
          ),
      ],
    );
  }
}
