# How to Fix the "API key not valid" Error

## Current Situation
You're getting the "API key not valid" error because the Firebase configuration files in both apps contain placeholder values instead of real configuration from your Firebase project.

From the tracklet app's `google-services.json`, I can see you have a Firebase project with:
- Project ID: tracklet-4db05
- API Key: AIzaSyBUsQJqwqMNunBYxfFJmxjEfLLZodjC-gM

However, this configuration is only for Android. You need to add web apps to your Firebase project.

## Step-by-Step Solution

### Step 1: Add Web Apps to Your Existing Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your existing project "tracklet-4db05"
3. In the Project Overview, click the "Add app" button (or the web icon `</>`)
4. Register the Super Admin Web App:
   - Click the web icon `</>`
   - Enter app nickname: "Super Admin Web"
   - Check "Also set up Firebase Hosting" if you plan to deploy
   - Click "Register app"
   - Copy the configuration values from the code snippet shown
   - Click "Continue to console"

5. Add the Tracklet Web App:
   - Click "Add app" again
   - Click the web icon `</>`
   - Enter app nickname: "Tracklet Web"
   - Check "Also set up Firebase Hosting" if you plan to deploy
   - Click "Register app"
   - Copy the configuration values from the code snippet shown
   - Click "Continue to console"

### Step 2: Update Firebase Configuration Files

#### For Super Admin App:
1. Open `super_admin/lib/core/config/firebase_options.dart`
2. Replace the placeholder values with your actual Firebase web configuration:

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyBUsQJqwqMNunBYxfFJmxjEfLLZodjC-gM",  // Use the API key from your web app config
      authDomain: "tracklet-4db05.firebaseapp.com",
      projectId: "tracklet-4db05",
      storageBucket: "tracklet-4db05.firebasestorage.app",
      messagingSenderId: "862271235339",
      appId: "YOUR_WEB_APP_ID",  // This will be provided when you register the web app
      measurementId: "YOUR_MEASUREMENT_ID", // Only for web, provided when you register the web app
    );
  }
}
```

#### For Tracklet App:
1. Open `tracklet/lib/core/config/firebase_options.dart`
2. Replace the placeholder values with your actual Firebase web configuration:

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyBUsQJqwqMNunBYxfFJmxjEfLLZodjC-gM",  // Use the API key from your web app config
      authDomain: "tracklet-4db05.firebaseapp.com",
      projectId: "tracklet-4db05",
      storageBucket: "tracklet-4db05.firebasestorage.app",
      messagingSenderId: "862271235339",
      appId: "YOUR_WEB_APP_ID",  // This will be provided when you register the web app
      measurementId: "YOUR_MEASUREMENT_ID", // Only for web, provided when you register the web app
    );
  }
}
```

### Step 3: Enable Required Firebase Services

1. In Firebase Console, click "Authentication" in the left sidebar
2. Click "Get started"
3. Enable "Email/Password" sign-in method
4. Click "Save"
5. In Firebase Console, click "Firestore Database" in the left sidebar
6. Click "Create database"
7. Choose "Start in test mode" (for development only)
8. Choose a location near you
9. Click "Enable"

### Step 4: Create the Super Admin User

1. In Firebase Console, click "Authentication" > "Users" tab
2. Click "Add user"
3. Enter:
   - Email: agha@gmail.com
   - Password: 123123
4. Click "Add user"

## Testing the Fix

After updating the configuration:

1. Run the Super Admin app:
```bash
cd super_admin
flutter pub get
flutter run -d chrome
```

2. Run the Tracklet app:
```bash
cd tracklet
flutter pub get
flutter run -d chrome
```

## Troubleshooting

If you're still getting the "API key not valid" error:

1. Double-check that you've updated all the placeholder values in both firebase_options.dart files
2. Make sure you're using the web app configuration values, not the Android ones
3. Ensure you've registered both web apps in your Firebase project
4. Verify that you've enabled Firebase Authentication and Firestore services
5. Check that you've created the super admin user (agha@gmail.com / 123123) in Firebase Authentication

## Additional Notes

- The API key from the Android configuration (AIzaSyBUsQJqwqMNunBYxfFJmxjEfLLZodjC-gM) might work for web, but it's better to use the dedicated web app configuration
- Each platform (Android, iOS, Web) should ideally have its own app registration in Firebase for proper analytics and functionality
- For production, you should implement proper Firestore security rules instead of using test mode