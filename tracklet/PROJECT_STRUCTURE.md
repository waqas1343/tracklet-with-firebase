# Tracklet - Project Structure & Architecture

## Overview
Tracklet is a comprehensive gas delivery management system built with Flutter, following MVVM (Model-View-ViewModel) architecture with clean code principles and Provider state management.

## Architecture Pattern: MVVM

### Model
- Represents data and business logic
- Located in `lib/core/models/`
- Includes: UserModel, OrderModel, GasRateModel, ExpenseModel, DriverModel

### View
- UI components and screens
- Located in `lib/features/` and `lib/shared/widgets/`
- Stateless widgets only (no StatefulWidget)

### ViewModel (Providers)
- State management using Provider
- Located in `lib/core/providers/`
- Handles business logic and state updates
- Includes: AuthProvider, OrderProvider, GasRateProvider, ExpenseProvider, DriverProvider

## Project Structure

```
lib/
├── core/
│   ├── models/              # Data models
│   │   ├── user_model.dart
│   │   ├── order_model.dart
│   │   ├── gas_rate_model.dart
│   │   ├── expense_model.dart
│   │   └── driver_model.dart
│   │
│   ├── providers/           # State management (ViewModel)
│   │   ├── auth_provider.dart
│   │   ├── order_provider.dart
│   │   ├── gas_rate_provider.dart
│   │   ├── expense_provider.dart
│   │   ├── driver_provider.dart
│   │   ├── language_provider.dart
│   │   └── theme_provider.dart
│   │
│   ├── services/            # Business logic services
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── storage_service.dart
│   │
│   ├── routes/              # Navigation
│   │   └── app_routes.dart
│   │
│   └── utils/               # Utilities & helpers
│       ├── app_colors.dart
│       ├── app_theme.dart
│       ├── constants.dart
│       ├── responsive_utils.dart
│       └── validators.dart
│
├── features/                # Feature-based organization
│   ├── common/              # Common features
│   │   └── views/
│   │       ├── splash_screen.dart
│   │       ├── onboarding_screen.dart
│   │       ├── language_selection_screen.dart
│   │       └── login_screen.dart
│   │
│   ├── gas_plant/           # Gas Plant role features
│   │   └── views/
│   │       ├── gas_plant_dashboard_screen.dart
│   │       ├── gas_rate_screen.dart
│   │       ├── orders_screen.dart
│   │       ├── expenses_screen.dart
│   │       └── settings_screen.dart
│   │
│   └── distributor/         # Distributor role features
│       └── views/
│           ├── distributor_dashboard_screen.dart
│           ├── distributor_orders_screen.dart
│           ├── drivers_screen.dart
│           └── distributor_settings_screen.dart
│
├── shared/                  # Shared/reusable components
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── custom_card.dart
│       ├── loading_widget.dart
│       ├── empty_state_widget.dart
│       └── error_widget.dart
│
└── main.dart                # App entry point with MultiProvider
```

## Key Features

### Two User Roles

#### Gas Plant
- Dashboard with stats and analytics
- Gas Rate management
- Orders management
- Expenses tracking
- Settings & profile

#### Distributor
- Dashboard with delivery overview
- Orders management
- Driver management
- Settings & profile

### Common Features
- Splash screen
- Onboarding flow
- Multi-language support (English, Urdu, Arabic)
- Login/Authentication
- Dark/Light theme toggle
- Responsive design

## State Management

### Provider Setup
All providers are initialized in `main.dart` using `MultiProvider`:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => OrderProvider()),
    ChangeNotifierProvider(create: (_) => GasRateProvider()),
    // ... more providers
  ],
  child: MyApp(),
)
```

### Usage in Widgets
```dart
// Read once
final authProvider = context.read<AuthProvider>();

// Listen to changes
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return Text(authProvider.currentUser?.name ?? '');
  },
)
```

## Services Layer

### API Service
Handles all HTTP requests with proper error handling:
- GET, POST, PUT, DELETE methods
- Authorization header management
- Response parsing
- Custom exceptions

### Auth Service
Manages authentication:
- Login/Logout
- Registration
- Token management
- User profile updates

### Storage Service
Handles local data persistence:
- Shared Preferences wrapper
- Token storage
- User data caching
- Settings persistence

## Responsive Design

### Responsive Utils
Provides utilities for responsive layouts:
- `isMobile()`, `isTablet()`, `isDesktop()`
- `responsiveWidth()`, `responsiveHeight()`
- `responsiveFontSize()`
- Grid cross-axis count calculation

### Usage
```dart
// Using context extension
if (context.isMobile) {
  // Mobile layout
} else if (context.isTablet) {
  // Tablet layout
}

// Responsive padding
Padding(
  padding: context.responsivePadding,
  child: child,
)
```

## Theme System

### Light & Dark Themes
- Defined in `app_theme.dart`
- Colors defined in `app_colors.dart`
- Managed by `ThemeProvider`
- Persistent theme selection

### Usage
```dart
// Toggle theme
context.read<ThemeProvider>().toggleTheme();

// Check current theme
final isDark = context.read<ThemeProvider>().isDarkMode;
```

## Navigation

### Routes
Centralized route management in `app_routes.dart`:
- Named routes
- Route guards (can be added)
- Unknown route handling

### Navigation
```dart
// Push route
Navigator.of(context).pushNamed('/gas-plant/dashboard');

// Replace route
Navigator.of(context).pushReplacementNamed('/login');

// Pop
Navigator.of(context).pop();
```

## Validation

### Validators
Reusable form validators in `validators.dart`:
- Email validation
- Password validation
- Phone validation
- Required field validation
- Number/Decimal validation

### Usage
```dart
CustomTextField(
  label: 'Email',
  validator: Validators.validateEmail,
)
```

## Best Practices Followed

1. **No StatefulWidget**: Only StatelessWidget with Provider for state
2. **Separation of Concerns**: Clear separation between UI, business logic, and data
3. **Single Responsibility**: Each class has one clear purpose
4. **DRY Principle**: Reusable components and utilities
5. **Clean Code**: Readable, maintainable, and well-documented
6. **Type Safety**: Strong typing throughout the codebase
7. **Error Handling**: Proper try-catch and error states
8. **Responsive**: Works on mobile, tablet, and desktop
9. **Themeable**: Support for light and dark themes
10. **Scalable**: Easy to add new features and modules

## How to Extend

### Adding a New Feature
1. Create model in `lib/core/models/`
2. Create service methods in appropriate service
3. Create provider in `lib/core/providers/`
4. Create screens in `lib/features/[role]/views/`
5. Add routes in `lib/core/routes/app_routes.dart`
6. Register provider in `main.dart`

### Adding a New Screen
1. Create screen file in appropriate feature folder
2. Add route in `app_routes.dart`
3. Use existing providers or create new ones
4. Follow existing screen patterns

### Adding a New Widget
1. Create widget in `lib/shared/widgets/`
2. Make it reusable and configurable
3. Use theme colors and responsive utils
4. Document parameters and usage

## Dependencies

```yaml
dependencies:
  provider: ^6.1.1           # State management
  shared_preferences: ^2.2.2 # Local storage
  http: ^1.2.0              # API calls
  intl: ^0.19.0             # Internationalization
```

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

3. Build for production:
   ```bash
   flutter build apk --release  # Android
   flutter build ios --release  # iOS
   ```

## Notes

- Replace API base URL in `api_service.dart` with your actual API endpoint
- Implement actual API endpoints in backend
- Add authentication token to API requests
- Customize theme colors in `app_colors.dart`
- Add more languages in `language_provider.dart`
- Implement proper error handling for production

## Future Enhancements

- Push notifications
- Real-time tracking with maps
- Offline mode support
- Advanced analytics and reporting
- Export data functionality
- Multi-currency support
- Advanced search and filters
- Role-based permissions
- Audit logs
- Backup and restore

