// Dashboard Screen - Main dashboard with metrics and activity feed
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/activity_feed_item.dart';
import '../utils/responsive_helper.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final gridColumns = ResponsiveHelper.getGridColumns(context);

    return RefreshIndicator(
      onRefresh: () => dashboardProvider.refreshData(),
      color: theme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Text('Dashboard Overview', style: theme.heading2),
            const SizedBox(height: 8),
            Text(
              'Welcome back! Here\'s what\'s happening today.',
              style: theme.bodyMedium,
            ),

            const SizedBox(height: 32),

            // Summary Cards Grid
            dashboardProvider.showShimmer
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) => const SummaryCardShimmer(),
                  )
                : GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: gridColumns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      SummaryCard(
                        title: 'Total Users',
                        value: dashboardProvider.totalUsers,
                        icon: Icons.people_rounded,
                        color: theme.primary,
                        subtitle: '+12% from last month',
                        animationDelay: 0,
                      ),
                      SummaryCard(
                        title: 'Active Users',
                        value: dashboardProvider.activeUsers,
                        icon: Icons.people_alt_rounded,
                        color: theme.success,
                        subtitle: '71.5% active rate',
                        animationDelay: 100,
                      ),
                      SummaryCard(
                        title: 'Revenue',
                        value: dashboardProvider.totalRevenue,
                        icon: Icons.attach_money_rounded,
                        color: theme.secondary,
                        subtitle: '+8% growth',
                        animationDelay: 200,
                      ),
                      SummaryCard(
                        title: 'Pending Tasks',
                        value: dashboardProvider.pendingTasks,
                        icon: Icons.pending_actions_rounded,
                        color: theme.warning,
                        subtitle: '5 critical',
                        animationDelay: 300,
                      ),
                    ],
                  ),

            const SizedBox(height: 40),

            // Recent Activity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Activity', style: theme.heading3),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('View All'),
                  style: TextButton.styleFrom(foregroundColor: theme.primary),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Activity Feed
            dashboardProvider.showShimmer
                ? const ActivityFeedShimmer()
                : Column(
                    children: dashboardProvider.recentActivities
                        .take(10)
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (entry) => ActivityFeedItem(
                            activity: entry.value,
                            index: entry.key,
                          ),
                        )
                        .toList(),
                  ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
