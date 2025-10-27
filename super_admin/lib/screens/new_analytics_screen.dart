// New Analytics Screen - Professional UI for Data Visualization
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/users_provider.dart';
import '../models/activity_model.dart';

class NewAnalyticsScreen extends StatelessWidget {
  const NewAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context);

    return Scaffold(
      backgroundColor: theme.modernBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Analytics Dashboard',
              style: theme.headlineMedium.copyWith(
                color: theme.modernTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track and analyze system performance',
              style: theme.bodyMedium.copyWith(
                color: theme.modernTextSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Key Metrics
            _buildKeyMetrics(context, theme, usersProvider, dashboardProvider),

            const SizedBox(height: 24),

            // User Distribution
            _buildUserDistribution(context, theme, usersProvider),

            const SizedBox(height: 24),

            // Activity Trends
            _buildActivityTrends(context, theme, dashboardProvider),

            const SizedBox(height: 24),

            // Recent Activity Log
            _buildRecentActivityLog(context, theme, dashboardProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetrics(
    BuildContext context,
    ThemeProvider theme,
    UsersProvider usersProvider,
    DashboardProvider dashboardProvider,
  ) {
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
          Text(
            'Key Metrics',
            style: theme.headlineSmall.copyWith(color: theme.modernTextPrimary),
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
              _buildMetricCard(
                context,
                theme,
                'Total Users',
                usersProvider.allUsers.length.toString(),
                Icons.people_rounded,
                theme.primaryGradient,
                Colors.white,
              ),
              _buildMetricCard(
                context,
                theme,
                'Active Users',
                usersProvider.allUsers
                    .where((u) => u.isActive)
                    .length
                    .toString(),
                Icons.check_circle_rounded,
                theme.successGradient,
                Colors.white,
              ),
              _buildMetricCard(
                context,
                theme,
                'User Growth',
                '+12%',
                Icons.trending_up_rounded,
                theme.infoGradient,
                Colors.white,
              ),
              _buildMetricCard(
                context,
                theme,
                'System Health',
                '98%',
                Icons.monitor_heart_rounded,
                theme.warningGradient,
                Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
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

  Widget _buildUserDistribution(
    BuildContext context,
    ThemeProvider theme,
    UsersProvider usersProvider,
  ) {
    final gasPlantUsers = usersProvider.allUsers
        .where((u) => u.role == 'Gas Plant')
        .length;
    final distributorUsers = usersProvider.allUsers
        .where((u) => u.role == 'Distributor')
        .length;
    final otherUsers =
        usersProvider.allUsers.length - gasPlantUsers - distributorUsers;

    final total = usersProvider.allUsers.length;
    final gasPlantPercentage = total > 0 ? (gasPlantUsers / total) * 100 : 0;
    final distributorPercentage = total > 0
        ? (distributorUsers / total) * 100
        : 0;
    final otherPercentage = total > 0 ? (otherUsers / total) * 100 : 0;

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
          Text(
            'User Distribution',
            style: theme.headlineSmall.copyWith(color: theme.modernTextPrimary),
          ),
          const SizedBox(height: 16),
          // Chart visualization
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: theme.modernBackground,
              borderRadius: BorderRadius.circular(theme.radiusSm),
            ),
            child: Row(
              children: [
                if (gasPlantPercentage > 0)
                  Expanded(
                    flex: gasPlantPercentage.toInt(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.modernPrimaryStart,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                if (distributorPercentage > 0)
                  Expanded(
                    flex: distributorPercentage.toInt(),
                    child: Container(color: theme.modernSecondary),
                  ),
                if (otherPercentage > 0)
                  Expanded(
                    flex: otherPercentage.toInt(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.modernAccent,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(
                theme,
                'Gas Plant',
                gasPlantUsers.toString(),
                theme.modernPrimaryStart,
              ),
              _buildLegendItem(
                theme,
                'Distributor',
                distributorUsers.toString(),
                theme.modernSecondary,
              ),
              _buildLegendItem(
                theme,
                'Other',
                otherUsers.toString(),
                theme.modernAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    ThemeProvider theme,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: $value',
          style: theme.labelMedium.copyWith(color: theme.modernTextSecondary),
        ),
      ],
    );
  }

  Widget _buildActivityTrends(
    BuildContext context,
    ThemeProvider theme,
    DashboardProvider dashboardProvider,
  ) {
    // Generate sample data for the last 7 days
    final List<Map<String, dynamic>> trendData = [
      {'day': 'Mon', 'count': 24},
      {'day': 'Tue', 'count': 32},
      {'day': 'Wed', 'count': 28},
      {'day': 'Thu', 'count': 45},
      {'day': 'Fri', 'count': 38},
      {'day': 'Sat', 'count': 22},
      {'day': 'Sun', 'count': 18},
    ];

    final maxCount = trendData
        .map((e) => e['count'] as int)
        .reduce((a, b) => a > b ? a : b);

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
          Text(
            'Activity Trends',
            style: theme.headlineSmall.copyWith(color: theme.modernTextPrimary),
          ),
          const SizedBox(height: 16),
          // Trend visualization
          Container(
            height: 150,
            padding: const EdgeInsets.all(16),
            child: CustomPaint(
              painter: ActivityTrendPainter(trendData, maxCount, theme),
              size: const Size(double.infinity, 150),
            ),
          ),
          const SizedBox(height: 16),
          // X-axis labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: trendData
                .map(
                  (data) => Text(
                    data['day'] as String,
                    style: theme.labelSmall.copyWith(
                      color: theme.modernTextSecondary,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityLog(
    BuildContext context,
    ThemeProvider theme,
    DashboardProvider dashboardProvider,
  ) {
    final recentActivities = dashboardProvider.recentActivities
        .take(10)
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
          Text(
            'Recent Activity',
            style: theme.headlineSmall.copyWith(color: theme.modernTextPrimary),
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
}

// Custom painter for activity trends
class ActivityTrendPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final int maxCount;
  final ThemeProvider theme;

  ActivityTrendPainter(this.data, this.maxCount, this.theme);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.modernPrimaryStart
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = theme.modernPrimaryStart.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final pointSpacing = size.width / (data.length - 1);
    final heightFactor = size.height / (maxCount > 0 ? maxCount : 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * pointSpacing;
      final y = size.height - (data[i]['count'] as int) * heightFactor;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = theme.modernPrimaryStart
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final x = i * pointSpacing;
      final y = size.height - (data[i]['count'] as int) * heightFactor;
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
