# Firebase Integration Documentation

## Overview
This document explains how Firebase is integrated into both the Tracklet and Super Admin applications to provide a unified authentication and data management system.

## Architecture

### Shared Firebase Project
Both applications use the same Firebase project, allowing them to share:
- Authentication database
- User profiles and roles
- Real-time data
- Security rules

### Data Flow
1. Super Admin creates users with roles in Firebase Authentication + Firestore
2. Users log into Tracklet app using their credentials
3. Tracklet app retrieves user role from Firestore
4. Based on role, user is directed to appropriate dashboard
5. Users can change their password through their profile

## Firebase Services Used

### Firebase Authentication
- User authentication with email/password
- Default password management
- Password reset functionality
- User session management

### Cloud Firestore
- User profile storage
- Role-based data access
- Real-time data synchronization
- Security rules implementation

## Implementation Details

### Super Admin Application

#### User Creation Process
1. Admin fills user creation form with:
   - Email (required)
   - Role (Distributor or Gas Plant)
   - Name (optional)
   - Company Name and Address (required for Gas Plant users)
2. System creates user in Firebase Authentication with default password "123123"
3. Additional user data is stored in Firestore collection "users"
4. User can log into Tracklet app with these credentials

#### Data Structure
```
users/{userId}
├── id: string (Firebase Auth UID)
├── email: string
├── role: string ("distributor" | "gas_plant")
├── name: string? (optional)
├── companyName: string? (required for gas_plant)
├── address: string? (required for gas_plant)
├── createdAt: timestamp
└── lastLogin: timestamp?
```

### Tracklet Application

#### Login Process
1. User enters email and password
2. Firebase Authentication validates credentials
3. If valid, app fetches user data from Firestore
4. Role is determined from user data
5. User is directed to appropriate dashboard:
   - `distributor` → Distributor Dashboard
   - `gas_plant` → Gas Plant Dashboard

#### Password Change
1. User navigates to Profile screen
2. Enters current password for re-authentication
3. Enters and confirms new password
4. Firebase Authentication updates password
5. User receives confirmation

## Security Rules

### Firestore Security Rules
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Admins can read all user data
    match /users/{userId} {
      allow read: if request.auth != null && 
        // Check if user has admin role (would need custom claims implementation)
        // This is a simplified example
        request.auth.token.admin == true;
    }
  }
}
```

## Role-Based Navigation

### Tracklet App
- **Distributor Role**: Access to distributor dashboard, orders, drivers, settings
- **Gas Plant Role**: Access to gas plant dashboard, orders, gas rates, expenses, settings

### Implementation
The role is stored in both:
1. User's custom claims in Firebase Authentication (for quick access)
2. User document in Firestore (for detailed information)

## Setup Instructions

### Firebase Project Setup
1. Create Firebase project at https://console.firebase.google.com/
2. Enable Email/Password authentication
3. Enable Cloud Firestore database
4. Set up security rules

### App Configuration
1. Add both apps to Firebase project:
   - Tracklet: Package name `com.example.tracklet`
   - Super Admin: Package name `com.example.super_admin`
2. Download `google-services.json` for each app
3. Place in respective `android/app/` directories

### Dependencies
Both apps use:
```yaml
dependencies:
  firebase_core: ^3.1.1
  firebase_auth: ^5.1.1
  cloud_firestore: ^5.2.1
  provider: ^6.1.1
```

## Code Structure

### Super Admin
```
lib/
├── core/
│   ├── app/
│   │   └── app_initializer.dart
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

### Tracklet
```
lib/
├── core/
│   ├── app/
│   │   └── app_initializer.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   └── ...
│   ├── providers/
│   │   ├── user_role_provider.dart
│   │   └── ...
│   ├── services/
│   │   ├── firebase_service.dart
│   │   └── ...
│   └── ...
├── features/
│   ├── common/
│   │   └── view/
│   │       ├── login_screen.dart
│   │       ├── profile_screen.dart
│   │       └── ...
│   ├── gas_plant/
│   │   └── view/
│   │       ├── settings_screen.dart
│   │       └── ...
│   └── distributor/
│       └── view/
│           ├── distributor_settings_screen.dart
│           └── ...
└── main.dart
```

## Best Practices

### Security
- Never store passwords in plain text
- Use Firebase Authentication for password management
- Implement proper security rules in Firestore
- Validate all user inputs

### Performance
- Use Provider for efficient state management
- Implement pagination for large data sets
- Use Firestore listeners for real-time updates
- Cache frequently accessed data

### User Experience
- Provide clear error messages
- Implement loading states
- Validate forms before submission
- Offer password strength indicators

## Troubleshooting

### Common Issues
1. **Authentication failures**: Check Firebase Auth configuration
2. **Data not loading**: Verify Firestore security rules
3. **Role-based navigation not working**: Ensure user data is correctly stored
4. **Password change failures**: Verify re-authentication step

### Debugging Tips
1. Use Firebase Console to view Authentication and Firestore data
2. Check app logs for error messages
3. Verify `google-services.json` is correctly placed
4. Test with Firebase Emulator Suite during development

## Future Enhancements
1. Implement custom claims for role-based access in Firebase Auth
2. Add email verification for new users
3. Implement password strength requirements
4. Add multi-factor authentication
5. Create admin dashboard with analytics
6. Implement push notifications