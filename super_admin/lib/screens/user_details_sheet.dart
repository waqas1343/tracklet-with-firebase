// User Details Sheet - Detailed user view with hero animation
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../providers/users_provider.dart';

class UserDetailsSheet extends StatelessWidget {
  const UserDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context);
    final user = usersProvider.selectedUser;

    if (user == null) {
      Navigator.pop(context);
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: theme.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Avatar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: theme.surface,
            leading: IconButton(
              icon: Icon(Icons.close_rounded, color: theme.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primary.withOpacity(0.8),
                      theme.secondary.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Hero Avatar
                    Hero(
                      tag: 'avatar_${user.id}',
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.avatarUrl),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Status
                  Center(
                    child: Column(
                      children: [
                        Text(
                          user.name,
                          style: theme.heading2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: user.isActive
                                ? theme.success.withOpacity(0.1)
                                : theme.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: user.isActive
                                  ? theme.success
                                  : theme.error,
                            ),
                          ),
                          child: Text(
                            user.isActive ? 'Active' : 'Inactive',
                            style: theme.bodySmall.copyWith(
                              color: user.isActive
                                  ? theme.success
                                  : theme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Info Cards
                  _InfoCard(
                    icon: Icons.email_rounded,
                    label: 'Email',
                    value: user.email,
                  ),
                  const SizedBox(height: 12),

                  _InfoCard(
                    icon: Icons.phone_rounded,
                    label: 'Phone',
                    value: user.phone,
                  ),
                  const SizedBox(height: 12),

                  _InfoCard(
                    icon: Icons.work_rounded,
                    label: 'Role',
                    value: user.role,
                  ),
                  const SizedBox(height: 12),

                  _InfoCard(
                    icon: Icons.business_rounded,
                    label: 'Department',
                    value: user.department,
                  ),
                  const SizedBox(height: 12),

                  _InfoCard(
                    icon: Icons.calendar_today_rounded,
                    label: 'Joined',
                    value: DateFormat('MMM d, yyyy').format(user.createdAt),
                  ),
                  const SizedBox(height: 12),

                  _InfoCard(
                    icon: Icons.access_time_rounded,
                    label: 'Last Login',
                    value: DateFormat(
                      'MMM d, yyyy · hh:mm a',
                    ).format(user.lastLogin),
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await usersProvider.toggleUserStatus(user.id);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(
                            user.isActive
                                ? Icons.block_rounded
                                : Icons.check_circle_rounded,
                          ),
                          label: Text(
                            user.isActive ? 'Deactivate' : 'Activate',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.warning,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Handle edit
                          },
                          icon: const Icon(Icons.edit_rounded),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.primary,
                            side: BorderSide(color: theme.primary),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Delete Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete User'),
                            content: const Text(
                              'Are you sure you want to delete this user? This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.error,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && context.mounted) {
                          await usersProvider.deleteUser(user.id);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      icon: const Icon(Icons.delete_rounded),
                      label: const Text('Delete User'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.error,
                        side: BorderSide(color: theme.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.divider.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: theme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.caption.copyWith(color: theme.textMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
