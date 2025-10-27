// New Modern Users Screen - Professional UI for User Management
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/users_provider.dart';
import '../models/user_model.dart';
import 'create_user_screen.dart';

class NewUsersScreen extends StatelessWidget {
  const NewUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context);

    return Scaffold(
      backgroundColor: theme.modernBackground,
      body: Column(
        children: [
          // Header
          _buildHeader(context, theme, usersProvider),

          // Users List
          Expanded(
            child: usersProvider.isLoading
                ? _buildLoadingIndicator(theme)
                : usersProvider.filteredUsers.isEmpty
                ? _buildEmptyState(context, theme)
                : _buildUsersList(context, theme, usersProvider),
          ),

          // Pagination
          if (!usersProvider.isLoading && usersProvider.totalPages > 1)
            _buildPagination(context, theme, usersProvider),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeProvider theme,
    UsersProvider usersProvider,
  ) {
    return Container(
      padding: EdgeInsets.all(theme.spacingLg),
      decoration: BoxDecoration(
        color: theme.modernSurface,
        boxShadow: theme.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Management',
                style: theme.headlineMedium.copyWith(
                  color: theme.modernTextPrimary,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: theme.primaryGradient,
                  borderRadius: BorderRadius.circular(theme.radiusMd),
                  boxShadow: theme.shadowLevel2,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreateUserScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: Text(
                    'Create User',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.spacingLg,
                      vertical: theme.spacingMd,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(theme.radiusMd),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => usersProvider.searchUsers(value),
            decoration: InputDecoration(
              hintText: 'Search users by name, email or role...',
              hintStyle: theme.bodyMedium.copyWith(
                color: theme.modernTextSecondary,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: theme.modernTextSecondary,
              ),
              suffixIcon: usersProvider.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: theme.modernTextSecondary,
                      ),
                      onPressed: () => usersProvider.searchUsers(''),
                    )
                  : null,
              filled: true,
              fillColor: theme.modernSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(theme.radiusMd),
                borderSide: BorderSide(color: theme.modernBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(theme.radiusMd),
                borderSide: BorderSide(color: theme.modernBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(theme.radiusMd),
                borderSide: BorderSide(
                  color: theme.modernPrimaryStart,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${usersProvider.filteredUsers.length} users found',
            style: theme.bodySmall.copyWith(color: theme.modernTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeProvider theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.modernPrimaryStart),
          const SizedBox(height: 16),
          Text(
            'Loading users...',
            style: theme.bodyLarge.copyWith(color: theme.modernTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeProvider theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.modernPrimaryStart.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(theme.radiusFull),
            ),
            child: Icon(
              Icons.people_outline,
              size: 64,
              color: theme.modernPrimaryStart,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: theme.headlineSmall.copyWith(color: theme.modernTextPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or create a new user',
            style: theme.bodyMedium.copyWith(color: theme.modernTextSecondary),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              gradient: theme.primaryGradient,
              borderRadius: BorderRadius.circular(theme.radiusMd),
              boxShadow: theme.shadowLevel2,
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateUserScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add_rounded, color: Colors.white),
              label: Text('Create User', style: TextStyle(color: Colors.white)),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(
    BuildContext context,
    ThemeProvider theme,
    UsersProvider usersProvider,
  ) {
    return Container(
      padding: EdgeInsets.all(theme.spacingLg),
      child: ListView.builder(
        itemCount: usersProvider.paginatedUsers.length,
        itemBuilder: (context, index) {
          final user = usersProvider.paginatedUsers[index];
          return _buildUserTile(context, theme, user, usersProvider);
        },
      ),
    );
  }

  Widget _buildUserTile(
    BuildContext context,
    ThemeProvider theme,
    UserModel user,
    UsersProvider usersProvider,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: theme.spacingMd),
      padding: EdgeInsets.all(theme.spacingLg),
      decoration: BoxDecoration(
        color: theme.modernSurface,
        borderRadius: BorderRadius.circular(theme.radiusMd),
        boxShadow: theme.shadowLevel1,
        border: Border.all(color: theme.modernBorder),
      ),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.modernPrimaryStart.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(theme.radiusFull),
              border: Border.all(
                color: theme.modernPrimaryStart.withValues(alpha: 0.3),
              ),
            ),
            child: user.avatarUrl.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      user.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person_rounded,
                        color: theme.modernPrimaryStart,
                        size: 24,
                      ),
                    ),
                  )
                : Icon(
                    Icons.person_rounded,
                    color: theme.modernPrimaryStart,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: theme.titleMedium.copyWith(
                    color: theme.modernTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: theme.bodySmall.copyWith(
                    color: theme.modernTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacingSm,
                        vertical: theme.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(
                          theme,
                          user.role,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(theme.radiusSm),
                      ),
                      child: Text(
                        user.role,
                        style: theme.labelSmall.copyWith(
                          color: _getRoleColor(theme, user.role),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacingSm,
                        vertical: theme.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: user.isActive
                            ? theme.success.withValues(alpha: 0.1)
                            : theme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(theme.radiusSm),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: user.isActive
                                  ? theme.success
                                  : theme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user.isActive ? 'Active' : 'Inactive',
                            style: theme.labelSmall.copyWith(
                              color: user.isActive
                                  ? theme.success
                                  : theme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Actions
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: theme.modernTextSecondary,
            ),
            onSelected: (String result) {
              if (result == 'toggle') {
                usersProvider.toggleUserStatus(user.id);
              } else if (result == 'delete') {
                _confirmDeleteUser(context, theme, usersProvider, user);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'toggle',
                child: Text(
                  user.isActive ? 'Deactivate' : 'Activate',
                  style: theme.bodyMedium.copyWith(
                    color: theme.modernTextPrimary,
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: theme.bodyMedium.copyWith(color: theme.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(ThemeProvider theme, String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return theme.modernPrimaryStart;
      case 'manager':
        return theme.modernSecondary;
      case 'developer':
        return theme.modernAccent;
      case 'designer':
        return theme.warning;
      case 'analyst':
        return theme.info;
      default:
        return theme.modernTextSecondary;
    }
  }

  void _confirmDeleteUser(
    BuildContext context,
    ThemeProvider theme,
    UsersProvider usersProvider,
    UserModel user,
  ) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete User',
            style: theme.titleLarge.copyWith(color: theme.modernTextPrimary),
          ),
          content: Text(
            'Are you sure you want to delete ${user.name}? This action cannot be undone.',
            style: theme.bodyMedium.copyWith(color: theme.modernTextSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: theme.labelLarge.copyWith(
                  color: theme.modernTextSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                usersProvider.deleteUser(user.id);
              },
              child: Text(
                'Delete',
                style: theme.labelLarge.copyWith(color: theme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPagination(
    BuildContext context,
    ThemeProvider theme,
    UsersProvider usersProvider,
  ) {
    return Container(
      padding: EdgeInsets.all(theme.spacingLg),
      decoration: BoxDecoration(
        color: theme.modernSurface,
        boxShadow: theme.shadowLevel1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radiusMd),
              border: Border.all(color: theme.modernBorder),
            ),
            child: OutlinedButton.icon(
              onPressed: usersProvider.currentPage > 0
                  ? () => usersProvider.previousPage()
                  : null,
              icon: const Icon(Icons.chevron_left_rounded),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.modernPrimaryStart,
                side: BorderSide(color: theme.modernPrimaryStart, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(theme.radiusMd),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacingLg,
                  vertical: theme.spacingMd,
                ),
              ),
            ),
          ),

          // Page Indicator
          Text(
            'Page ${usersProvider.currentPage + 1} of ${usersProvider.totalPages}',
            style: theme.bodyMedium.copyWith(color: theme.modernTextPrimary),
          ),

          // Next Button
          Container(
            decoration: BoxDecoration(
              gradient: theme.primaryGradient,
              borderRadius: BorderRadius.circular(theme.radiusMd),
              boxShadow: theme.shadowLevel2,
            ),
            child: ElevatedButton.icon(
              onPressed:
                  usersProvider.currentPage < usersProvider.totalPages - 1
                  ? () => usersProvider.nextPage()
                  : null,
              icon: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
              label: Text('Next', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(theme.radiusMd),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacingLg,
                  vertical: theme.spacingMd,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
