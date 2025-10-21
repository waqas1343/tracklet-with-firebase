# Firebase Setup Guide for Tracklet and Super Admin Projects

## Overview
This guide explains how to set up Firebase for both the Tracklet and Super Admin Flutter projects to use the same Firebase project.

## Prerequisites
- A Google account
- Flutter SDK installed
- Android Studio (for Android development)

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter a project name (e.g., "Tracklet System")
4. Accept the terms and conditions
5. Click "Create project"

## Step 2: Add Both Apps to the Firebase Project

### For Tracklet App:
1. In the Firebase Console, click "Add app" or the gear icon > "Project settings"
2. Select the Android icon
3. Enter the package name: `com.example.tracklet`
4. Enter an app nickname: "Tracklet"
5. Click "Register app"
6. Download the `google-services.json` file
7. Place this file in: `tracklet/android/app/` directory

### For Super Admin App:
1. In the Firebase Console, click "Add app" or the gear icon > "Project settings"
2. Select the Android icon
3. Enter the package name: `com.example.super_admin`
4. Enter an app nickname: "Super Admin"
5. Click "Register app"
6. Download the `google-services.json` file
7. Place this file in: `super_admin/android/app/` directory

## Step 3: Enable Firebase Services

### Enable Authentication:
1. In Firebase Console, click "Authentication" in the left sidebar
2. Click "Get started"
3. Enable "Email/Password" sign-in method
4. Click "Save"

### Enable Firestore Database:
1. In Firebase Console, click "Firestore Database" in the left sidebar
2. Click "Create database"
3. Choose "Start in test mode" (for development only)
4. Choose a location near you
5. Click "Enable"

## Step 4: Test the Setup

### For Tracklet App:
```bash
cd tracklet
flutter pub get
flutter run
```

### For Super Admin App:
```bash
cd super_admin
flutter pub get
flutter run
```

## Step 5: Shared Data Structure (Optional)

To share data between both apps, you can use the same Firestore collections with proper security rules:

Example structure:
```
users/
  - userId/
    - email
    - role (gasPlant, distributor, admin)
    - name
    - createdAt

orders/
  - orderId/
    - customerId
    - status
    - items
    - createdAt
    - updatedAt

gasRates/
  - rateId/
    - type
    - price
    - effectiveDate
```

## Security Rules Example

In Firestore Database > Rules, you can set rules like:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow admins to read and write everything
    match /{document=**} {
      allow read, write: if request.auth != null && 
        request.auth.token.role == 'admin';
    }
    
    // Allow gas plant users to read orders and gas rates
    match /orders/{order} {
      allow read, write: if request.auth != null && 
        (request.auth.token.role == 'admin' || 
         request.auth.token.role == 'gasPlant');
    }
    
    match /gasRates/{rate} {
      allow read, write: if request.auth != null && 
        (request.auth.token.role == 'admin' || 
         request.auth.token.role == 'gasPlant');
    }
  }
}
```

## Troubleshooting

### Common Issues:

1. **Missing google-services.json**: Make sure you've downloaded and placed the config file in the correct directory.

2. **Gradle sync failed**: Ensure you have the Google Services plugin in both `settings.gradle.kts` and `app/build.gradle.kts`.

3. **Firebase not initialized**: Make sure you're calling `Firebase.initializeApp()` before using any Firebase services.

4. **Authentication errors**: Check that you've enabled the sign-in methods in Firebase Console.

## Next Steps

1. Implement user roles and permissions
2. Set up proper security rules
3. Add Firebase Analytics for tracking
4. Implement real-time data synchronization
5. Add push notifications with Firebase Cloud Messaging

## Support

For any issues, refer to the official Firebase documentation:
- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)