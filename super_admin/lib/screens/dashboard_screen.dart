// Dashboard Screen - App-like interface for user management
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/users_provider.dart';
import '../providers/login_provider.dart';
import '../utils/responsive_helper.dart';
import 'users_screen.dart';
import 'create_user_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final gridColumns = ResponsiveHelper.getGridColumns(context);

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Consumer<UsersProvider>(
          builder: (context, usersProvider, child) {
            if (usersProvider.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: theme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Loading users...',
                      style: theme.bodyLarge.copyWith(color: theme.textMuted),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Header
                  _buildAppHeader(context, theme, loginProvider),

                  const SizedBox(height: 32),

                  // Quick Stats
                  _buildQuickStats(context, theme, usersProvider, gridColumns),

                  const SizedBox(height: 32),

                  // Quick Actions
                  _buildQuickActions(context, theme),

                  const SizedBox(height: 32),

                  // Recent Users
                  _buildRecentUsers(context, theme, usersProvider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppHeader(
    BuildContext context,
    ThemeProvider theme,
    LoginProvider loginProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primary, theme.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Super Admin!',
                  style: theme.heading1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your Tracklet users and system',
                  style: theme.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  // Refresh users data
                  final usersProvider = Provider.of<UsersProvider>(
                    context,
                    listen: false,
                  );
                  await usersProvider.refreshUsers();
                },
                icon: Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Refresh',
              ),
              IconButton(
                onPressed: () => loginProvider.logout(),
                icon: Icon(Icons.logout, color: Colors.white),
                tooltip: 'Logout',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    ThemeProvider theme,
    UsersProvider usersProvider,
    int gridColumns,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Stats', style: theme.heading2),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: gridColumns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              context,
              theme,
              'Total Users',
              usersProvider.allUsers.length.toString(),
              Icons.people_rounded,
              theme.primary,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              ),
            ),
            _buildStatCard(
              context,
              theme,
              'Gas Plant Users',
              usersProvider.allUsers
                  .where((u) => u.role == 'Gas Plant')
                  .length
                  .toString(),
              Icons.local_gas_station_rounded,
              theme.success,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              ),
            ),
            _buildStatCard(
              context,
              theme,
              'Distributor Users',
              usersProvider.allUsers
                  .where((u) => u.role == 'Distributor')
                  .length
                  .toString(),
              Icons.local_shipping_rounded,
              theme.warning,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              ),
            ),
            _buildStatCard(
              context,
              theme,
              'Active Users',
              usersProvider.allUsers.where((u) => u.isActive).length.toString(),
              Icons.check_circle_rounded,
              theme.info,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              ),
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
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.divider.withValues(alpha: 0.5)),
          boxShadow: theme.shadowSm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.heading1.copyWith(
                color: theme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.bodyMedium.copyWith(color: theme.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeProvider theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: theme.heading2),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                theme,
                'Create User',
                Icons.person_add_rounded,
                theme.primary,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateUserScreen()),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                context,
                theme,
                'View Users',
                Icons.people_rounded,
                theme.success,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UsersScreen()),
                ),
              ),
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
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.bodyLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentUsers(
    BuildContext context,
    ThemeProvider theme,
    UsersProvider usersProvider,
  ) {
    final recentUsers = usersProvider.allUsers.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Users', style: theme.heading2),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              ),
              child: Text(
                'View All',
                style: theme.bodyMedium.copyWith(color: theme.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (recentUsers.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.divider.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Icon(Icons.people_outline, size: 48, color: theme.textMuted),
                const SizedBox(height: 16),
                Text(
                  'No users created yet',
                  style: theme.bodyLarge.copyWith(color: theme.textMuted),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first user to get started',
                  style: theme.bodyMedium.copyWith(color: theme.textMuted),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateUserScreen()),
                  ),
                  icon: Icon(Icons.person_add, color: Colors.white),
                  label: Text(
                    'Create User',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentUsers.length,
            itemBuilder: (context, index) {
              final user = recentUsers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.divider.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: theme.primary.withValues(alpha: 0.1),
                      child: user.avatarUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                user.avatarUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.person,
                                      color: theme.primary,
                                      size: 20,
                                    ),
                              ),
                            )
                          : Icon(Icons.person, color: theme.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: theme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.textPrimary,
                            ),
                          ),
                          Text(
                            user.role,
                            style: theme.bodyMedium.copyWith(
                              color: theme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: user.isActive
                            ? theme.success.withValues(alpha: 0.1)
                            : theme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.isActive ? 'Active' : 'Inactive',
                        style: theme.caption.copyWith(
                          color: user.isActive ? theme.success : theme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
