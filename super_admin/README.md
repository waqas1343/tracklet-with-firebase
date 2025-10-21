# Super Admin - Tracklet Management System

## Overview
Super Admin is a Flutter application that allows administrators to manage users in the Tracklet system. Administrators can create new users with specific roles (Distributor or Gas Plant) and assign them to the appropriate dashboards.

## Features
- User authentication with Firebase
- Create new users with default password "123123"
- Assign roles (Distributor or Gas Plant) to users
- Store additional information for Gas Plant users (company name and address)
- View and manage all created users
- Role-based navigation in the Tracklet app

## Tech Stack
- Flutter (Dart)
- Firebase Authentication
- Cloud Firestore
- Provider for state management
- MVVM architecture pattern

## Firebase Setup

### Prerequisites
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Register your app with the package name `com.example.super_admin`
3. Download the `google-services.json` file and place it in `android/app/`

### Enable Firebase Services
1. Enable Email/Password authentication in Firebase Console
2. Enable Cloud Firestore database

## Super Admin Credentials
For development purposes, the Super Admin login screen is pre-filled with:
- Email: agha@gmail.com
- Password: 123123

To use these credentials, you must first create this user in Firebase Authentication:
1. Go to Firebase Console
2. Navigate to Authentication > Users
3. Click "Add user"
4. Enter email: agha@gmail.com
5. Enter password: 123123
6. Click "Add user"

## Firebase Configuration
You must update the Firebase configuration with your actual project settings:
1. Refer to `GET_FIREBASE_API_KEY.md` for detailed instructions on creating a Firebase project
2. Refer to `../../FIX_API_KEY_ERROR.md` for specific instructions on fixing the "API key not valid" error
3. Update `lib/core/config/firebase_options.dart` with your actual Firebase configuration
4. Replace all placeholder values with your project-specific values

## Project Structure
```
lib/
├── core/
│   ├── app/
│   │   └── app_initializer.dart
│   ├── config/
│   │   └── firebase_options.dart
│   ├── models/
│   │   └── user_model.dart
│   ├── providers/
│   │   ├── admin_provider.dart
│   │   └── app_provider.dart
│   └── services/
│       └── admin_service.dart
├── features/
│   └── admin/
│       └── views/
│           ├── admin_dashboard_screen.dart
│           ├── admin_login_screen.dart
│           ├── admin_user_creation_form.dart
│           ├── splash_screen.dart
│           └── user_list_view.dart
├── services/
│   └── firebase_service.dart
└── main.dart
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Set up Firebase as described above
4. Create the Super Admin user (agha@gmail.com / 123123) in Firebase Authentication
5. Update Firebase configuration in `lib/core/config/firebase_options.dart`
6. Run the app with `flutter run`

## Usage

1. Log in as an administrator using agha@gmail.com / 123123
2. Navigate to the "Create User" tab
3. Enter user details:
   - Email (required)
   - Name (optional)
   - Role (Distributor or Gas Plant)
   - For Gas Plant users, also enter:
     - Company Name
     - Address
4. Click "Create User"
5. The user will be created with the default password "123123"
6. Users can change their password after logging into the Tracklet app

## Security

- All user data is stored securely in Firebase Authentication and Cloud Firestore
- Role-based access control is implemented through Firestore security rules
- Default passwords should be changed by users upon first login

## Architecture

This project follows the MVVM (Model-View-ViewModel) architecture pattern:
- **Models**: Data classes in `core/models/`
- **Views**: UI components in `features/admin/views/`
- **ViewModels**: Providers in `core/providers/`
- **Services**: Business logic in `core/services/` and `services/`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a pull request

## License

This project is proprietary and confidential.