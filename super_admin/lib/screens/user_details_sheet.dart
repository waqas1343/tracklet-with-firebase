              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primary.withAlpha((0.8 * 255).round()),
                      theme.secondary.withAlpha((0.6 * 255).round()),
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
                                ? theme.success.withAlpha((0.1 * 255).round())
                                : theme.error.withAlpha((0.1 * 255).round()),
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