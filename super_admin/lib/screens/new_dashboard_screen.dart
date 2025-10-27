// New Modern Dashboard Screen - Professional UI for Super Admin
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/users_provider.dart';
import '../providers/login_provider.dart';
import '../utils/responsive_helper.dart';
import '../models/activity_model.dart';
import 'users_screen.dart';
import 'create_user_screen.dart';

class NewDashboardScreen extends StatelessWidget {
  const NewDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: theme.modernBackground,
      body: SafeArea(
        child: Consumer<UsersProvider>(
          builder: (context, usersProvider, child) {
            if (usersProvider.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: theme.modernPrimaryStart),
                    const SizedBox(height: 16),
                    Text(
                      'Loading dashboard...',
                      style: theme.bodyLarge.copyWith(
                        color: theme.modernTextSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  _buildWelcomeHeader(context, theme, loginProvider),

                  const SizedBox(height: 24),

                  // Stats Overview
                  _buildStatsOverview(
                    context,
                    theme,
                    usersProvider,
                    dashboardProvider,
                  ),

                  const SizedBox(height: 24),

                  // Recent Activity
                  _buildRecentActivity(context, theme, dashboardProvider),

                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildQuickActions(context, theme),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(
    BuildContext context,
    ThemeProvider theme,
    LoginProvider loginProvider,
  ) {
    return Container(
      padding: EdgeInsets.all(theme.spacingLg),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(theme.radiusLg),
        boxShadow: theme.shadowLevel2,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(theme.spacingSm),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(theme.radiusFull),
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning, Admin!',
                  style: theme.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Here\'s what\'s happening with your system today',
                  style: theme.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => loginProvider.logout(),
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(
    BuildContext context,
    ThemeProvider theme,
    UsersProvider usersProvider,
    DashboardProvider dashboardProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: theme.headlineMedium.copyWith(color: theme.modernTextPrimary),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: theme.spacingMd,
          mainAxisSpacing: theme.spacingMd,
          childAspectRatio: 2.2,
          children: [
            _buildStatCard(
              context,
              theme,
              'Total Users',
              usersProvider.allUsers.length.toString(),
              Icons.people_rounded,
              theme.primaryGradient,
              Colors.white,
            ),
            _buildStatCard(
              context,
              theme,
              'Active Users',
              usersProvider.allUsers.where((u) => u.isActive).length.toString(),
              Icons.check_circle_rounded,
              theme.successGradient,
              Colors.white,
            ),
            _buildStatCard(
              context,
              theme,
              'Gas Plant',
              usersProvider.allUsers
                  .where((u) => u.role == 'Gas Plant')
                  .length
                  .toString(),
              Icons.local_gas_station_rounded,
              theme.warningGradient,
              Colors.white,
            ),
            _buildStatCard(
              context,
              theme,
              'Distributor',
              usersProvider.allUsers
                  .where((u) => u.role == 'Distributor')
                  .length
                  .toString(),
              Icons.local_shipping_rounded,
              theme.infoGradient,
              Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ThemeProvider theme,
    String title,
    String value,
    IconData icon,
    Gradient gradient,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.all(theme.spacingMd),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(theme.radiusMd),
        boxShadow: theme.shadowLevel1,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(theme.spacingSm),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(theme.radiusFull),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: theme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: theme.labelSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    ThemeProvider theme,
    DashboardProvider dashboardProvider,
  ) {
    final recentActivities = dashboardProvider.recentActivities
        .take(5)
        .toList();

    return Container(
      padding: EdgeInsets.all(theme.spacingLg),
      decoration: BoxDecoration(
        color: theme.modernSurface,
        borderRadius: BorderRadius.circular(theme.radiusLg),
        boxShadow: theme.shadowLevel1,
        border: Border.all(color: theme.modernBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: theme.headlineSmall.copyWith(
                  color: theme.modernTextPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full activity log
                },
                child: Text(
                  'View All',
                  style: theme.labelMedium.copyWith(
                    color: theme.modernPrimaryStart,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (recentActivities.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 48,
                    color: theme.modernTextSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recent activity',
                    style: theme.bodyMedium.copyWith(
                      color: theme.modernTextSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentActivities.length,
              separatorBuilder: (context, index) =>
                  Divider(height: theme.spacingLg, color: theme.modernBorder),
              itemBuilder: (context, index) {
                final activity = recentActivities[index];
                return _buildActivityItem(context, theme, activity);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    ThemeProvider theme,
    ActivityModel activity,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(theme.spacingSm),
          decoration: BoxDecoration(
            color: _getActivityColor(
              theme,
              activity.type,
            ).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(theme.radiusFull),
          ),
          child: Icon(
            _getActivityIcon(activity.type),
            color: _getActivityColor(theme, activity.type),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${activity.userName} ${activity.action}',
                style: theme.bodyMedium.copyWith(
                  color: theme.modernTextPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                activity.description,
                style: theme.labelSmall.copyWith(
                  color: theme.modernTextSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          _formatTime(activity.timestamp),
          style: theme.labelSmall.copyWith(color: theme.modernTextSecondary),
        ),
      ],
    );
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.login:
        return Icons.login_rounded;
      case ActivityType.update:
        return Icons.edit_rounded;
      case ActivityType.create:
        return Icons.add_rounded;
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

  Color _getActivityColor(ThemeProvider theme, ActivityType type) {
    switch (type) {
      case ActivityType.login:
        return theme.modernPrimaryStart;
      case ActivityType.update:
        return theme.modernAccent;
      case ActivityType.create:
        return theme.success;
      case ActivityType.delete:
        return theme.error;
      case ActivityType.settings:
        return theme.modernSecondary;
      case ActivityType.upload:
        return theme.warning;
      case ActivityType.download:
        return theme.info;
      case ActivityType.notification:
        return theme.modernPrimaryEnd;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Widget _buildQuickActions(BuildContext context, ThemeProvider theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.headlineSmall.copyWith(color: theme.modernTextPrimary),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: theme.spacingMd,
          mainAxisSpacing: theme.spacingMd,
          childAspectRatio: 2.5,
          children: [
            _buildActionButton(
              context,
              theme,
              'Create User',
              Icons.person_add_rounded,
              theme.primaryGradient,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateUserScreen()),
              ),
            ),
            _buildActionButton(
              context,
              theme,
              'View Users',
              Icons.people_rounded,
              theme.successGradient,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              ),
            ),
            _buildActionButton(
              context,
              theme,
              'Settings',
              Icons.settings_rounded,
              theme.infoGradient,
              () {
                // Navigate to settings
                final dashboardProvider = Provider.of<DashboardProvider>(
                  context,
                  listen: false,
                );
                dashboardProvider.setCurrentPage(3);
              },
            ),
            _buildActionButton(
              context,
              theme,
              'Analytics',
              Icons.analytics_rounded,
              theme.warningGradient,
              () {
                // Navigate to analytics
                final dashboardProvider = Provider.of<DashboardProvider>(
                  context,
                  listen: false,
                );
                dashboardProvider.setCurrentPage(2);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    ThemeProvider theme,
    String title,
    IconData icon,
    Gradient gradient,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(theme.spacingMd),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(theme.radiusMd),
          boxShadow: theme.shadowLevel1,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(theme.spacingSm),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(theme.radiusFull),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: theme.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
