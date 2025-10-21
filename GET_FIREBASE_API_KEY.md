# How to Get Your Firebase API Key and Configuration

## Overview
The "API key not valid" error occurs because the Firebase configuration in your app contains placeholder values. You need to replace these with actual values from your Firebase project.

## Step-by-Step Guide

### Step 1: Create a Firebase Project
If you haven't already created a Firebase project:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter a project name (e.g., "Tracklet System")
4. Accept the terms and conditions
5. Click "Create project"

### Step 2: Register Your Web Apps

#### For Super Admin App:
1. In the Firebase Console, click the gear icon > "Project settings"
2. In the "General" tab, click "Add app" and select the Web icon (</>)
3. Enter an app nickname: "Super Admin Web"
4. **Important**: Check the box "Also set up Firebase Hosting" if you plan to deploy
5. Click "Register app"
6. Copy the Firebase configuration object that appears (you'll need this in Step 3)
7. Click "Continue to console"

#### For Tracklet App:
1. In the Firebase Console, click "Add app" and select the Web icon (</>)
2. Enter an app nickname: "Tracklet Web"
3. **Important**: Check the box "Also set up Firebase Hosting" if you plan to deploy
4. Click "Register app"
5. Copy the Firebase configuration object that appears (you'll need this in Step 3)
6. Click "Continue to console"

### Step 3: Update Your Configuration Files

#### Update Super Admin Firebase Options:
1. Open `super_admin/lib/core/config/firebase_options.dart`
2. Replace the placeholder values with your actual Firebase configuration from Step 2:

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Replace these values with your actual Firebase config from Step 2
    return const FirebaseOptions(
      apiKey: "AIzaSyBUsQJqwqMNunBYxfFJmxjEfLLZodjC-gM",
      authDomain: "your-project-id.firebaseapp.com",
      projectId: "tracklet-4db05",
      storageBucket: "your-project-id.appspot.com",
      messagingSenderId: "123456789012",
      appId: "1:123456789012:web:abcd1234abcd1234abcd12",
      measurementId: "G-ABCDEF1234", // Only for web
    );
  }
}
```

#### Update Tracklet Firebase Options:
1. Open `tracklet/lib/core/config/firebase_options.dart`
2. Replace the placeholder values with your actual Firebase configuration from Step 2:

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Replace these values with your actual Firebase config from Step 2
    return const FirebaseOptions(
      apiKey: "AIzaSyD_actual_api_key_from_firebase",
      authDomain: "your-project-id.firebaseapp.com",
      projectId: "your-project-id",
      storageBucket: "your-project-id.appspot.com",
      messagingSenderId: "123456789012",
      appId: "1:123456789012:web:abcd1234abcd1234abcd12",
      measurementId: "G-ABCDEF1234", // Only for web
    );
  }
}
```

### Step 4: Enable Required Firebase Services

#### Enable Authentication:
1. In Firebase Console, click "Authentication" in the left sidebar
2. Click "Get started"
3. Enable "Email/Password" sign-in method
4. Click "Save"

#### Enable Firestore Database:
1. In Firebase Console, click "Firestore Database" in the left sidebar
2. Click "Create database"
3. Choose "Start in test mode" (for development only)
4. Choose a location near you
5. Click "Enable"

### Step 5: Create the Super Admin User

1. In Firebase Console, click "Authentication" > "Users" tab
2. Click "Add user"
3. Enter:
   - Email: agha@gmail.com
   - Password: 123123
4. Click "Add user"

## Configuration Values Explanation

When you register your web apps, you'll get a configuration object like this:
```javascript
const firebaseConfig = {
  apiKey: "AIzaSyD_example_api_key_xHw",
  authDomain: "your-project-id.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcd1234abcd1234abcd12",
  measurementId: "G-ABCDEF1234"
};
```

Map these values to your Dart configuration:
- `apiKey` → `apiKey`
- `authDomain` → `authDomain`
- `projectId` → `projectId`
- `storageBucket` → `storageBucket`
- `messagingSenderId` → `messagingSenderId`
- `appId` → `appId`
- `measurementId` → `measurementId` (only for web)

## Testing the Configuration

After updating the configuration:

1. Run the Super Admin app:
```bash
cd super_admin
flutter pub get
flutter run
```

2. Run the Tracklet app:
```bash
cd tracklet
flutter pub get
flutter run
```

## Troubleshooting

### Common Issues:

1. **"API key not valid"**: Double-check that you've updated all the placeholder values in the firebase_options.dart files with your actual Firebase configuration.

2. **"FirebaseOptions cannot be null"**: Make sure you're providing all required configuration values.

3. **Authentication failures**: Ensure you've enabled the Email/Password sign-in method in Firebase Console.

4. **Firestore permission denied**: Check your Firestore security rules in the Firebase Console.

### Additional Tips:

1. **Development vs Production**: The current setup uses "test mode" for Firestore which allows open access. For production, you should implement proper security rules.

2. **Multiple Platforms**: If you're targeting mobile platforms (Android/iOS), you'll also need to add the respective platform configurations.

3. **Environment Variables**: For better security, consider using environment variables to store sensitive configuration values.

## Example Configuration

Here's an example of what your actual configuration might look like (these are fake values for illustration):

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyD_example_api_key_xHw",
      authDomain: "tracklet-system.firebaseapp.com",
      projectId: "tracklet-system",
      storageBucket: "tracklet-system.appspot.com",
      messagingSenderId: "123456789012",
      appId: "1:123456789012:web:abcd1234abcd1234abcd12",
      measurementId: "G-ABCDEF1234",
    );
  }
}
```

## Support

For any issues with Firebase configuration, refer to the official Firebase documentation:
- [Firebase Web Setup](https://firebase.google.com/docs/web/setup)
- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)