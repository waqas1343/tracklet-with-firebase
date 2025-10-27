// Custom App Bar - Top app bar with search, notifications, theme toggle
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/responsive_helper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearch;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMenuTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showSearch = true,
    this.onSearchTap,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isMobile = ResponsiveHelper.useMobileLayout(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.modernSurface,
        boxShadow: theme.shadowLevel1,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacingLg,
            vertical: theme.spacingSm,
          ),
          child: Row(
            children: [
              // Menu button on mobile
              if (isMobile && onMenuTap != null) ...[
                Container(
                  decoration: BoxDecoration(
                    color: theme.modernSurface,
                    borderRadius: BorderRadius.circular(theme.radiusFull),
                    boxShadow: theme.shadowLevel1,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.menu_rounded),
                    onPressed: onMenuTap,
                    color: theme.modernTextPrimary,
                    tooltip: 'Menu',
                    iconSize: 24,
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Title
              Text(
                title,
                style: theme.headlineSmall.copyWith(
                  color: theme.modernTextPrimary,
                ),
              ),

              const Spacer(),

              // Search
              if (showSearch)
                Container(
                  decoration: BoxDecoration(
                    color: theme.modernSurface,
                    borderRadius: BorderRadius.circular(theme.radiusFull),
                    boxShadow: theme.shadowLevel1,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search_rounded),
                    onPressed: onSearchTap,
                    color: theme.modernTextSecondary,
                    tooltip: 'Search',
                    iconSize: 24,
                  ),
                ),

              const SizedBox(width: 8),

              // Notifications with badge
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.modernSurface,
                      borderRadius: BorderRadius.circular(theme.radiusFull),
                      boxShadow: theme.shadowLevel1,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {
                        // Show notifications
                      },
                      color: theme.modernTextSecondary,
                      tooltip: 'Notifications',
                      iconSize: 24,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: theme.errorGradient,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                      child: Text(
                        '3',
                        style: theme.caption.copyWith(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),

              // Theme Toggle
              Container(
                decoration: BoxDecoration(
                  color: theme.modernSurface,
                  borderRadius: BorderRadius.circular(theme.radiusFull),
                  boxShadow: theme.shadowLevel1,
                ),
                child: IconButton(
                  icon: Icon(
                    theme.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                  onPressed: () => theme.toggleTheme(),
                  color: theme.modernTextSecondary,
                  tooltip: theme.isDarkMode ? 'Light Mode' : 'Dark Mode',
                  iconSize: 24,
                ),
              ),

              const SizedBox(width: 8),

              // User Avatar
              GestureDetector(
                onTap: () {
                  // Show user menu
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: theme.primaryGradient,
                    borderRadius: BorderRadius.circular(theme.radiusFull),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
