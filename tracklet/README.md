# Tracklet - Gas Delivery Management System

## Overview
Tracklet is a comprehensive gas delivery management system built with Flutter. It supports two user roles:
- **Gas Plant**: For gas plant company management
- **Distributor**: For distributor company operations

## Features
- Role-based dashboards (Gas Plant vs Distributor)
- User authentication with Firebase
- Order management
- Gas rate tracking
- Expense management
- Driver management
- Real-time data synchronization

## Tech Stack
- Flutter (Dart)
- Firebase Authentication
- Cloud Firestore
- Provider for state management
- MVVM architecture pattern

## Firebase Setup

### Prerequisites
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Register your app with the package name `com.example.tracklet`
3. Download the `google-services.json` file and place it in `android/app/`

### Enable Firebase Services
1. Enable Email/Password authentication in Firebase Console
2. Enable Cloud Firestore database

## Firebase Configuration
You must update the Firebase configuration with your actual project settings:
1. Refer to `../GET_FIREBASE_API_KEY.md` for detailed instructions on creating a Firebase project
2. Refer to `../FIX_API_KEY_ERROR.md` for specific instructions on fixing the "API key not valid" error
3. Update `lib/core/config/firebase_options.dart` with your actual Firebase configuration
4. Replace all placeholder values with your project-specific values

## Super Admin Integration
This app works with the Super Admin application:
- Users are created through the Super Admin app
- All users share the same Firebase project
- Default password for new users is "123123"

## Project Structure
```
lib/
├── core/
│   ├── app/
│   │   └── app_initializer.dart
│   ├── config/
│   │   └── firebase_options.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── order_model.dart
│   │   ├── gas_rate_model.dart
│   │   ├── expense_model.dart
│   │   └── driver_model.dart
│   ├── providers/
│   │   ├── app_provider.dart
│   │   ├── user_role_provider.dart
│   │   └── navigation_view_model.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   ├── storage_service.dart
│   │   ├── firebase_service.dart
│   │   └── firebase_auth_provider.dart
│   ├── routes/
│   │   └── app_routes.dart
│   ├── screens/
│   │   └── unified_main_screen.dart
│   ├── utils/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── constants.dart
│   └── widgets/
│       ├── custom_appbar.dart
│       └── unified_bottom_nav_bar.dart
├── features/
│   ├── common/
│   │   ├── provider/
│   │   └── view/
│   │       ├── splash_screen.dart
│   │       ├── login_screen.dart
│   │       ├── profile_screen.dart
│   │       └── language_selection_screen.dart
│   ├── gas_plant/
│   │   ├── provider/
│   │   ├── view/
│   │   └── widgets/
│   └── distributor/
│       ├── provider/
│       ├── view/
│       └── widgets/
├── shared/
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_card.dart
│       └── custom_text_field.dart
├── app.dart
└── main.dart
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Set up Firebase as described above
4. Update Firebase configuration in `lib/core/config/firebase_options.dart`
5. Run the app with `flutter run`

## Usage

1. Users are created through the Super Admin app
2. Log in with credentials provided by Super Admin
3. Default password for new users is "123123"
4. Users are automatically directed to the appropriate dashboard based on their role
5. Users can change their password in their profile settings

## Security

- All user data is stored securely in Firebase Authentication and Cloud Firestore
- Role-based access control is implemented through Firestore security rules
- Default passwords should be changed by users upon first login

## Architecture

This project follows the MVVM (Model-View-ViewModel) architecture pattern:
- **Models**: Data classes in `core/models/`
- **Views**: UI components in `features/`
- **ViewModels**: Providers in `core/providers/` and `features/*/provider/`
- **Services**: Business logic in `core/services/`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a pull request

## License

This project is proprietary and confidential.