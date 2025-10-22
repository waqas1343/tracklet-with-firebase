import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet/core/utils/app_colors.dart';
import '../providers/profile_provider.dart';
import '../providers/notification_provider.dart';
import '../../features/common/view/notification_screen.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isLoadingUnreadCount = false;
  bool _unreadCountLoaded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final profileProvider = Provider.of<ProfileProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final currentUser = profileProvider.currentUser;
    final displayName = widget.userName ?? currentUser?.name ?? 'User';
    final initials =
        widget.userInitials ??
        (currentUser?.name.isNotEmpty == true
            ? currentUser!.name.substring(0, 1).toUpperCase()
            : 'U');

    // Load unread count when app bar builds, but only once
    if (currentUser != null && !_isLoadingUnreadCount && !_unreadCountLoaded) {
      setState(() {
        _isLoadingUnreadCount = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadUnreadCount(notificationProvider, currentUser.id);
      });
    }

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: widget.showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: widget.onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        children: [
          GestureDetector(
            onTap: widget.onProfilePressed,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
              child: Text(
                initials,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(displayName, style: textTheme.titleLarge),
          const Spacer(),
          if (widget.showNotificationIcon)
            _buildNotificationButton(
              context: context,
              onPressed: widget.onNotificationPressed,
              unreadCount: notificationProvider.unreadCount,
            ),
          const SizedBox(width: 8),
          ...?widget.actions,
        ],
      ),
    );
  }

  Widget _buildNotificationButton({
    required BuildContext context,
    VoidCallback? onPressed,
    required int unreadCount,
  }) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: IconButton(
            onPressed: onPressed ?? () => _navigateToNotifications(context),
            icon: Icon(Icons.notifications, color: AppColors.iconSecondary),
          ),
        ),
        if (unreadCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const NotificationScreen()));
  }

  Future<void> _loadUnreadCount(NotificationProvider notificationProvider, String userId) async {
    try {
      await notificationProvider.loadUnreadCount(userId);
    } catch (e) {
      // Handle error silently
      debugPrint('Failed to load unread count: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUnreadCount = false;
          _unreadCountLoaded = true;
        });
      }
    }
  }
}