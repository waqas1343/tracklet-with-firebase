// User Row - Single user item in users list
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/users_provider.dart';
import '../models/user_model.dart';

class UserRow extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;

  const UserRow({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.divider.withOpacity(0.5), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar with Hero animation
                Hero(
                  tag: 'avatar_${user.id}',
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(user.avatarUrl),
                    backgroundColor: theme.primary.withOpacity(0.1),
                  ),
                ),
                const SizedBox(width: 16),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.name,
                              style: theme.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.textPrimary,
                              ),
                            ),
                          ),
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: user.isActive
                                  ? theme.success.withOpacity(0.1)
                                  : theme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              user.isActive ? 'Active' : 'Inactive',
                              style: theme.caption.copyWith(
                                color: user.isActive
                                    ? theme.success
                                    : theme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: theme.bodySmall.copyWith(color: theme.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.work_outline_rounded,
                            size: 12,
                            color: theme.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(user.role, style: theme.caption),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.business_outlined,
                            size: 12,
                            color: theme.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(user.department, style: theme.caption),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Action Menu
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_rounded, color: theme.textMuted),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) async {
                    switch (value) {
                      case 'view':
                        if (onTap != null) onTap!();
                        break;
                      case 'edit':
                        // Handle edit
                        break;
                      case 'toggle':
                        await usersProvider.toggleUserStatus(user.id);
                        break;
                      case 'delete':
                        await usersProvider.deleteUser(user.id);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(
                            Icons.visibility_rounded,
                            size: 18,
                            color: theme.textMuted,
                          ),
                          const SizedBox(width: 12),
                          const Text('View Details'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: theme.textMuted,
                          ),
                          const SizedBox(width: 12),
                          const Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'toggle',
                      child: Row(
                        children: [
                          Icon(
                            user.isActive
                                ? Icons.block_rounded
                                : Icons.check_circle_rounded,
                            size: 18,
                            color: theme.textMuted,
                          ),
                          const SizedBox(width: 12),
                          Text(user.isActive ? 'Deactivate' : 'Activate'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_rounded,
                            size: 18,
                            color: theme.error,
                          ),
                          const SizedBox(width: 12),
                          Text('Delete', style: TextStyle(color: theme.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
