// Users Screen - User management with search and pagination
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/users_provider.dart';
import '../widgets/user_row.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/animated_page_route.dart';
import 'user_details_sheet.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context);

    return Column(
      children: [
        // Header with Search
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Management', style: theme.heading2),
              const SizedBox(height: 16),

              // Search Bar
              TextField(
                onChanged: (value) => usersProvider.searchUsers(value),
                decoration: InputDecoration(
                  hintText: 'Search users by name, email or role...',
                  hintStyle: theme.bodyMedium.copyWith(color: theme.textMuted),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: theme.textMuted,
                  ),
                  suffixIcon: usersProvider.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: theme.textMuted,
                          ),
                          onPressed: () => usersProvider.searchUsers(''),
                        )
                      : null,
                  filled: true,
                  fillColor: theme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.primary, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Results count
              Text(
                '${usersProvider.filteredUsers.length} users found',
                style: theme.bodySmall,
              ),
            ],
          ),
        ),

        // Users List
        Expanded(
          child: usersProvider.isLoading
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: 5,
                  itemBuilder: (context, index) => const UserRowShimmer(),
                )
              : usersProvider.paginatedUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: theme.textMuted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No users found',
                        style: theme.heading3.copyWith(color: theme.textMuted),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your search',
                        style: theme.bodyMedium,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: usersProvider.paginatedUsers.length,
                  itemBuilder: (context, index) {
                    final user = usersProvider.paginatedUsers[index];
                    return UserRow(user: user, onTap: () {});
                  },
                ),
        ),

        // Pagination Controls
        if (!usersProvider.isLoading && usersProvider.totalPages > 1)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.surface,
              boxShadow: theme.shadowSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Button
                OutlinedButton.icon(
                  onPressed: usersProvider.currentPage > 0
                      ? () => usersProvider.previousPage()
                      : null,
                  icon: const Icon(Icons.chevron_left_rounded),
                  label: const Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.primary,
                    side: BorderSide(color: theme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // Page Indicator
                Text(
                  'Page ${usersProvider.currentPage + 1} of ${usersProvider.totalPages}',
                  style: theme.bodyMedium,
                ),

                // Next Button
                ElevatedButton.icon(
                  onPressed:
                      usersProvider.currentPage < usersProvider.totalPages - 1
                      ? () => usersProvider.nextPage()
                      : null,
                  icon: const Icon(Icons.chevron_right_rounded),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: theme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
