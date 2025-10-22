// Activity/Log Model
class ActivityModel {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String action;
  final String description;
  final DateTime timestamp;
  final ActivityType type;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.action,
    required this.description,
    required this.timestamp,
    required this.type,
  });

  // Fake data generator
  static List<ActivityModel> generateSampleActivities(int count) {
    final actions = [
      'Logged in',
      'Updated profile',
      'Created new user',
      'Deleted user',
      'Changed settings',
      'Uploaded document',
      'Downloaded report',
      'Sent notification',
    ];

    final descriptions = [
      'from web dashboard',
      'via mobile app',
      'in user management',
      'in settings panel',
      'for quarterly review',
      'to all departments',
      'with admin privileges',
      'using API access',
    ];

    final types = [
      ActivityType.login,
      ActivityType.update,
      ActivityType.create,
      ActivityType.delete,
      ActivityType.settings,
      ActivityType.upload,
      ActivityType.download,
      ActivityType.notification,
    ];

    return List.generate(count, (index) {
      return ActivityModel(
        id: 'activity_${index + 1}',
        userId: 'user_${(index % 10) + 1}',
        userName: 'User ${(index % 10) + 1}',
        userAvatar: 'https://i.pravatar.cc/150?img=${(index % 10) + 1}',
        action: actions[index % actions.length],
        description: descriptions[index % descriptions.length],
        timestamp: DateTime.now().subtract(Duration(minutes: index * 15)),
        type: types[index % types.length],
      );
    });
  }
}

enum ActivityType {
  login,
  update,
  create,
  delete,
  settings,
  upload,
  download,
  notification,
}
