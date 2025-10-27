// Modern Users Screen - Redesigned UI for user management
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/users_provider.dart';
import '../widgets/user_row.dart';
import '../widgets/shimmer_loader.dart';
import 'create_user_screen.dart';

class ModernUsersScreen extends StatelessWidget {
  const ModernUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context);

    return Column(
      children: [
        // Modern Header with Search
        Container(
          padding: EdgeInsets.all(theme.spacingLg),
          decoration: BoxDecoration(
            color: theme.modernSurface,
            boxShadow: theme.shadowLevel1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Management', style: theme.headlineMedium),
              const SizedBox(height: 16),

              // Modern Search Bar
              Container(
                decoration: BoxDecoration(
                  color: theme.modernSurface,
                  borderRadius: BorderRadius.circular(theme.radiusLg),
                  boxShadow: theme.shadowLevel1,
                  border: Border.all(color: theme.modernBorder),
                ),
                child: TextField(
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
                      borderRadius: BorderRadius.circular(theme.radiusLg),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(theme.radiusLg),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(theme.radiusLg),
                      borderSide: BorderSide(
                        color: theme.modernPrimaryStart,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Header with Create Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${usersProvider.filteredUsers.length} users found',
                    style: theme.bodySmall.copyWith(
                      color: theme.modernTextSecondary,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(theme.radiusMd),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Users List
        Expanded(
          child: usersProvider.isLoading
              ? ListView.builder(
                  padding: EdgeInsets.all(theme.spacingLg),
                  itemCount: 5,
                  itemBuilder: (context, index) => const UserRowShimmer(),
                )
              : usersProvider.paginatedUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.modernPrimaryStart.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(theme.radiusFull),
                        ),
                        child: Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: theme.modernPrimaryStart,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No users found',
                        style: theme.headlineSmall.copyWith(
                          color: theme.modernTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your search',
                        style: theme.bodyMedium.copyWith(
                          color: theme.modernTextSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(theme.spacingLg),
                  itemCount: usersProvider.paginatedUsers.length,
                  itemBuilder: (context, index) {
                    final user = usersProvider.paginatedUsers[index];
                    return Container(
                      margin: EdgeInsets.only(
                        bottom: index == usersProvider.paginatedUsers.length - 1
                            ? 0
                            : theme.spacingSm,
                      ),
                      decoration: BoxDecoration(
                        color: theme.modernSurface,
                        borderRadius: BorderRadius.circular(theme.radiusMd),
                        boxShadow: theme.shadowLevel1,
                        border: Border.all(color: theme.modernBorder),
                      ),
                      child: UserRow(user: user, onTap: () {}),
                    );
                  },
                ),
        ),

        // Pagination Controls
        if (!usersProvider.isLoading && usersProvider.totalPages > 1)
          Container(
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
                      side: BorderSide(
                        color: theme.modernPrimaryStart,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(theme.radiusMd),
                      ),
                    ),
                  ),
                ),

                // Page Indicator
                Text(
                  'Page ${usersProvider.currentPage + 1} of ${usersProvider.totalPages}',
                  style: theme.bodyMedium.copyWith(
                    color: theme.modernTextPrimary,
                  ),
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
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
