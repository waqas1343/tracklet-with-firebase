import 'package:flutter/material.dart';
import 'package:tracklet/core/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? userName;
  final String? userInitials;
  final List<Widget>? actions;
  final bool showNotificationIcon;
  final bool useDistributorProfile;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.userName,
    this.userInitials,
    this.actions,
    this.showNotificationIcon = true,
    this.useDistributorProfile = false,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        children: [
          GestureDetector(
            onTap: onProfilePressed,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
              child: Text(
                userInitials ?? 'U',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            userName ?? 'User',
            style: textTheme.titleLarge,
          ),
          const Spacer(),
          if (showNotificationIcon)
            _buildIconButton(
              context: context,
              onPressed: onNotificationPressed,
            ),
          const SizedBox(width: 8),
          ...?actions,
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required BuildContext context,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.notifications,
          color: AppColors.iconSecondary,
        ),
      ),
    );
  }
}