# Flutter + Firebase MVVM Architecture with Provider State Management

This guide explains the implementation of MVVM (Model-View-ViewModel) architecture with Provider state management for user profile data management in the Tracklet app.

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│      View       │    │   ViewModel      │    │     Model       │
│   (UI Layer)    │◄──►│ (Business Logic) │◄──►│  (Data Layer)   │
│                 │    │                  │    │                 │
│ - ProfileScreen │    │ ProfileViewModel │    │ UserModel       │
│ - CustomAppBar  │    │ ProfileProvider  │    │ ProfileRepository│
│ - UserWidgets   │    │                  │    │ FirebaseService │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 📁 File Structure

```
lib/
├── core/
│   ├── models/
│   │   └── user_model.dart              # Data Model
│   ├── repositories/
│   │   └── profile_repository.dart      # Data Access Layer
│   ├── viewmodels/
│   │   └── profile_viewmodel.dart       # Business Logic
│   ├── providers/
│   │   └── profile_provider.dart        # State Management
│   ├── services/
│   │   └── firebase_service.dart        # Firebase Integration
│   └── widgets/
│       ├── custom_appbar.dart           # UI Component
│       └── profile_initializer.dart     # Initialization Helper
├── features/
│   └── gas_plant/
│       └── settings/
│           └── profile_settings_screen.dart  # Main View
└── examples/
    └── profile_usage_example.dart       # Usage Examples
```

## 🔄 Data Flow

### 1. User Login Flow
```
User Login → Firebase Auth → ProfileProvider.initializeProfile() → 
ProfileViewModel.loadUserProfile() → ProfileRepository.getUserProfile() → 
Firestore → UserModel → ProfileViewModel → ProfileProvider → UI Update
```

### 2. Profile Update Flow
```
User Input → Form Validation → ProfileProvider.updateProfile() → 
ProfileViewModel.updateProfile() → ProfileRepository.updateProfile() → 
Firestore Update → Local Model Update → ProfileProvider.notifyListeners() → 
UI Real-time Update
```

### 3. Real-time Data Reflection
```
Firestore Change → ProfileRepository.profileStream → 
ProfileViewModel.profileStream → ProfileProvider.profileStream → 
Consumer<ProfileProvider> → UI Automatic Update
```

## 🛠️ Implementation Details

### 1. Model Layer (`UserModel`)

```dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? lastLogin;

  // JSON serialization methods
  factory UserModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
  UserModel copyWith({...});
}
```

### 2. Repository Layer (`ProfileRepository`)

```dart
class ProfileRepository {
  // Data access methods
  Future<UserModel?> getUserProfile(String uid);
  Future<bool> updateProfile(String uid, Map<String, dynamic> updates);
  Future<bool> createProfile(UserModel user);
  Stream<UserModel?> getProfileStream(String uid);
}
```

### 3. ViewModel Layer (`ProfileViewModel`)

```dart
class ProfileViewModel extends ChangeNotifier {
  // Business logic and state management
  Future<void> loadUserProfile(String uid);
  Future<bool> updateProfile({String? name, String? email, String? phone});
  Stream<UserModel?> get profileStream;
}
```

### 4. Provider Layer (`ProfileProvider`)

```dart
class ProfileProvider extends ChangeNotifier {
  // UI state management and ViewModel delegation
  UserModel? get currentUser;
  bool get isLoading;
  String? get error;
  Future<bool> updateProfile({...});
}
```

### 5. View Layer (`ProfileSettingsScreen`)

```dart
class ProfileSettingsScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        // Real-time UI updates based on provider state
        final user = profileProvider.currentUser;
        final isLoading = profileProvider.isLoading;
        // ... UI implementation
      },
    );
  }
}
```

## 🚀 Usage Examples

### 1. Basic Profile Display

```dart
Consumer<ProfileProvider>(
  builder: (context, profileProvider, child) {
    final user = profileProvider.currentUser;
    return Text('Welcome, ${user?.name ?? 'User'}!');
  },
)
```

### 2. Profile Update with Loading State

```dart
Future<void> _updateProfile() async {
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  
  final success = await profileProvider.updateProfile(
    name: 'New Name',
    phone: '1234567890',
  );
  
  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
  }
}
```

### 3. Real-time Profile Stream

```dart
StreamBuilder<UserModel?>(
  stream: Provider.of<ProfileProvider>(context, listen: false).profileStream,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text('Name: ${snapshot.data!.name}');
    }
    return const CircularProgressIndicator();
  },
)
```

## 🔧 Setup Instructions

### 1. Add Provider to AppProvider

```dart
ChangeNotifierProvider<ProfileProvider>(
  create: (_) => ProfileProvider(),
),
```

### 2. Initialize Profile After Login

```dart
// In your login success handler
final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
await profileProvider.initializeProfile();
```

### 3. Use ProfileInitializer Widget

```dart
ProfileInitializer(
  child: YourMainAppWidget(),
)
```

## 📱 Real-time Features

### 1. Automatic UI Updates
- Profile changes are automatically reflected across all screens
- CustomAppBar shows updated user name and initials
- Form fields are pre-populated with current data

### 2. Error Handling
- Network errors are displayed to users
- Loading states prevent multiple simultaneous requests
- Validation errors are shown inline

### 3. Offline Support
- Local model is updated immediately
- Changes are synced to Firestore when connection is available
- Real-time listeners reconnect automatically

## 🔒 Security Considerations

### 1. Data Validation
- Input validation on both client and server
- Email format validation
- Phone number format validation

### 2. Authentication
- User must be authenticated to access profile
- UID-based document access control
- Firebase Security Rules implementation

### 3. Error Handling
- Sensitive error information is not exposed to users
- Debug information is only shown in debug mode

## 🧪 Testing Strategy

### 1. Unit Tests
- Model serialization/deserialization
- Repository data operations
- ViewModel business logic

### 2. Integration Tests
- Provider state management
- Firebase integration
- Real-time updates

### 3. Widget Tests
- UI component behavior
- Form validation
- Error state display

## 📊 Performance Optimizations

### 1. Efficient Updates
- Only necessary fields are updated in Firestore
- Local model updates happen immediately
- Debounced real-time listeners

### 2. Memory Management
- Proper disposal of controllers and listeners
- Efficient state management with Provider
- Minimal rebuilds with selective Consumer usage

### 3. Network Optimization
- Batch updates when possible
- Connection state monitoring
- Retry mechanisms for failed requests

## 🎯 Benefits of This Architecture

### 1. Separation of Concerns
- Clear separation between UI, business logic, and data
- Easy to test and maintain
- Scalable for future features

### 2. Real-time Updates
- Automatic UI synchronization across the app
- Consistent user experience
- Reduced manual state management

### 3. Type Safety
- Strongly typed models and providers
- Compile-time error checking
- Better IDE support and autocomplete

### 4. Firebase Integration
- Seamless Firestore integration
- Real-time listeners
- Offline support

This architecture provides a robust, scalable, and maintainable solution for user profile management with real-time updates across the entire application.
