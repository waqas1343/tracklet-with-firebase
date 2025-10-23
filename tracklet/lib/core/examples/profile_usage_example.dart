import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

/// Example showing how to use ProfileProvider in different screens
/// This demonstrates real-time data reflection across the app
class ProfileUsageExample extends StatelessWidget {
  const ProfileUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Usage Example')),
      body: Builder(
        builder: (context) {
          final profileProvider = Provider.of<ProfileProvider>(context);
          final user = profileProvider.currentUser;
          final isLoading = profileProvider.isLoading;
          final error = profileProvider.error;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red.shade400),
                  const SizedBox(height: 16),
                  Text('Error: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => profileProvider.refreshProfile(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (user == null) {
            return const Center(child: Text('No user profile found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Profile Data',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        _buildProfileField('Name', user.name),
                        _buildProfileField('Email', user.email),
                        _buildProfileField('Phone', user.phone),
                        _buildProfileField(
                          'Role',
                          user.role.toString().split('.').last,
                        ),
                        _buildProfileField(
                          'Created At',
                          user.createdAt.toString(),
                        ),
                        if (user.lastLogin != null)
                          _buildProfileField(
                            'Last Login',
                            user.lastLogin!.toString(),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Update Example
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Real-time Updates',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              _updateProfileExample(context, profileProvider),
                          child: const Text('Update Profile Example'),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This will update the profile and you\'ll see the changes reflected immediately across the app.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Navigation Example
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Navigation',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _navigateToProfileSettings(context),
                          child: const Text('Go to Profile Settings'),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Navigate to profile settings and update your information. The changes will be reflected here when you return.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value.isEmpty ? 'Not set' : value)),
        ],
      ),
    );
  }

  Future<void> _updateProfileExample(
    BuildContext context,
    ProfileProvider profileProvider,
  ) async {
    final newName = 'Updated User ${DateTime.now().millisecondsSinceEpoch}';
    final newPhone = '+1234567890';

    await profileProvider.updateProfile(
      name: newName,
      phone: newPhone,
    );

    // Removed debugPrint statements
  }

  void _navigateToProfileSettings(BuildContext context) {
    Navigator.pushNamed(context, '/profile-settings');
  }
}

/// Example of a simple widget that displays user info
/// This shows how profile data is automatically updated across the app
class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.currentUser;

    if (user == null) {
      return const Text('No user data');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome, ${user.name}!'),
        Text('Email: ${user.email}'),
        Text('Phone: ${user.phone}'),
      ],
    );
  }
}

/// Example of a widget that shows user initials
/// This demonstrates how profile changes reflect in UI components
class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.currentUser;

    if (user == null) {
      return const CircleAvatar(child: Icon(Icons.person));
    }

    final initials = user.name.isNotEmpty
        ? user.name.substring(0, 1).toUpperCase()
        : 'U';

    return CircleAvatar(child: Text(initials));
  }
}