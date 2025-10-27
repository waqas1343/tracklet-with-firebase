// Modern Dashboard Screen - Redesigned UI for Super Admin
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/users_provider.dart';
import '../providers/login_provider.dart';
import '../utils/responsive_helper.dart';
import 'users_screen.dart';
import 'create_user_screen.dart';

class ModernDashboardScreen extends StatelessWidget {
  const ModernDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final gridColumns = ResponsiveHelper.getGridColumns(context);

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
                  _buildModernAppHeader(context, theme, loginProvider),

                  const SizedBox(height: 32),

                  // Quick Stats with Modern Design
                  _buildModernQuickStats(
                    context,
                    theme,
                    usersProvider,
                    gridColumns,
                  ),

                  const SizedBox(height: 32),

                  // Quick Actions with Modern Design
                  _buildModernQuickActions(context, theme),

                  const SizedBox(height: 32),

                  // Recent Users with Modern Design
                  _buildModernRecentUsers(context, theme, usersProvider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernAppHeader(
    BuildContext context,
    ThemeProvider theme,
    LoginProvider loginProvider,
  ) {
    return Container(
      padding: EdgeInsets.all(theme.spacingLg),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(theme.radiusXl),
        boxShadow: theme.shadowLevel3,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Admin!',
                  style: theme.displaySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Here\'s what\'s happening with your system today',
                  style: theme.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(theme.radiusLg),
                ),
                child: IconButton(
                  onPressed: () async {
                    final usersProvider = Provider.of<UsersProvider>(
                      context,
                      listen: false,
                    );
                    await usersProvider.refreshUsers();
                  },
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  tooltip: 'Refresh',
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(theme.radiusLg),
                ),
                child: IconButton(
                  onPressed: () => loginProvider.logout(),
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  tooltip: 'Logout',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernQuickStats(
    BuildContext context,
    ThemeProvider theme,
    UsersProvider usersProvider,
    int gridColumns,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('System Overview', style: theme.headlineMedium),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: gridColumns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2,
          children: [
            _buildModernStatCard(
              context,
              theme,
              'Total Users',
              usersProvider.allUsers.length.toString(),
              Icons.people_rounded,
              theme.primaryGradient,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              ),
            ),
            _buildModernStatCard(
              context,
              theme,
              'Gas Plant Users',
              usersProvider.allUsers
                  .where((u) => u.role == 'Gas Plant')
                  .length
                  .toString(),
              Icons.local_gas_station_rounded,
              theme.successGradient,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              ),
            ),
            _buildModernStatCard(
              context,
              theme,
              'Distributor Users',
              usersProvider.allUsers
                  .where((u) => u.role == 'Distributor')
                  .length
                  .toString(),
              Icons.local_shipping_rounded,
              theme.warningGradient,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              ),
            ),
            _buildModernStatCard(
              context,
              theme,
              'Active Users',
              usersProvider.allUsers.where((u) => u.isActive).length.toString(),
              Icons.check_circle_rounded,
              theme.infoGradient,
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

  Widget _buildModernStatCard(
    BuildContext context,
    ThemeProvider theme,
    String title,
    String value,
    IconData icon,
    Gradient gradient,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(theme.spacingLg),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(theme.radiusLg),
          boxShadow: theme.shadowLevel2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(theme.radiusFull),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: theme.displaySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernQuickActions(BuildContext context, ThemeProvider theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: theme.headlineMedium),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildModernActionButton(
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
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModernActionButton(
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModernActionButton(
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
        padding: EdgeInsets.all(theme.spacingLg),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(theme.radiusLg),
          boxShadow: theme.shadowLevel2,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(theme.radiusFull),
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernRecentUsers(
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
            Text('Recent Activity', style: theme.headlineMedium),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              ),
              child: Text(
                'View All',
                style: theme.labelLarge.copyWith(
                  color: theme.modernPrimaryStart,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (recentUsers.isEmpty)
          Container(
            padding: EdgeInsets.all(theme.spacingXl),
            decoration: BoxDecoration(
              color: theme.modernSurface,
              borderRadius: BorderRadius.circular(theme.radiusLg),
              boxShadow: theme.shadowLevel1,
              border: Border.all(color: theme.modernBorder),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.modernPrimaryStart.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(theme.radiusFull),
                  ),
                  child: Icon(
                    Icons.people_outline,
                    size: 48,
                    color: theme.modernPrimaryStart,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No users created yet',
                  style: theme.headlineSmall.copyWith(
                    color: theme.modernTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first user to get started',
                  style: theme.bodyMedium.copyWith(
                    color: theme.modernTextSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    gradient: theme.primaryGradient,
                    borderRadius: BorderRadius.circular(theme.radiusMd),
                    boxShadow: theme.shadowLevel2,
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateUserScreen(),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacingXl,
                        vertical: theme.spacingLg,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(theme.radiusMd),
                      ),
                    ),
                    child: Text(
                      'Create User',
                      style: theme.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(theme.spacingSm),
            decoration: BoxDecoration(
              color: theme.modernSurface,
              borderRadius: BorderRadius.circular(theme.radiusLg),
              boxShadow: theme.shadowLevel1,
              border: Border.all(color: theme.modernBorder),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentUsers.length,
              itemBuilder: (context, index) {
                final user = recentUsers[index];
                return Container(
                  margin: EdgeInsets.only(
                    bottom: index == recentUsers.length - 1
                        ? 0
                        : theme.spacingSm,
                  ),
                  padding: EdgeInsets.all(theme.spacingLg),
                  decoration: BoxDecoration(
                    color: theme.modernSurface,
                    borderRadius: BorderRadius.circular(theme.radiusMd),
                    border: Border.all(color: theme.modernBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: theme.primaryGradient,
                          borderRadius: BorderRadius.circular(theme.radiusFull),
                        ),
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
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                ),
                              )
                            : Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: theme.titleMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.modernTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.role,
                              style: theme.bodySmall.copyWith(
                                color: theme.modernTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: theme.spacingMd,
                          vertical: theme.spacingSm,
                        ),
                        decoration: BoxDecoration(
                          color: user.isActive
                              ? theme.success.withOpacity(0.1)
                              : theme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(theme.radiusFull),
                          border: Border.all(
                            color: user.isActive
                                ? theme.success.withOpacity(0.3)
                                : theme.error.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: user.isActive
                                    ? theme.success
                                    : theme.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              user.isActive ? 'Active' : 'Inactive',
                              style: theme.labelSmall.copyWith(
                                color: user.isActive
                                    ? theme.success
                                    : theme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
