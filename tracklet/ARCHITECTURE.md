# Tracklet App - Clean Architecture Documentation

## Overview

This Flutter application follows **Clean Architecture** principles with the **MVVM (Model-View-ViewModel)** pattern and uses **Provider** for state management.

## Architecture Principles

### 1. Separation of Concerns
- **Models**: Data structures (in `core/models/`)
- **Views**: UI components (in `features/*/view/`)
- **ViewModels**: Business logic and state (in `features/*/provider/`)
- **Services**: External dependencies and APIs (in `core/services/`)

### 2. Dependency Injection
- All dependencies are injected through constructors
- Services are initialized once and provided throughout the app
- Providers receive services as dependencies

### 3. Single Responsibility
- Each file/class has one clear purpose
- `main.dart` only handles app startup
- `app.dart` only contains the root MaterialApp widget
- `app_provider.dart` only manages provider setup

## Project Structure

```
lib/
├── main.dart                          # ✨ CLEAN - Only initialization & runApp()
├── app.dart                           # Root MaterialApp widget
│
├── core/                              # Core application components
│   ├── app/
│   │   └── app_initializer.dart      # Service initialization logic
│   ├── providers/
│   │   └── app_provider.dart         # 🎯 Central provider management
│   ├── models/                        # Data models
│   │   ├── user_model.dart
│   │   ├── order_model.dart
│   │   ├── driver_model.dart
│   │   ├── expense_model.dart
│   │   └── gas_rate_model.dart
│   ├── services/                      # Business services
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── storage_service.dart
│   ├── routes/
│   │   └── app_routes.dart            # Navigation configuration
│   └── utils/                         # Utilities and constants
│       ├── app_colors.dart
│       ├── app_theme.dart
│       ├── constants.dart
│       ├── responsive_utils.dart
│       └── validators.dart
│
├── features/                          # Feature modules (MVVM)
│   ├── common/
│   │   ├── provider/                  # ViewModels for common features
│   │   │   ├── auth_provider.dart
│   │   │   ├── language_provider.dart
│   │   │   └── theme_provider.dart
│   │   └── view/                      # Views for common features
│   │       ├── splash_screen.dart
│   │       ├── onboarding_screen.dart
│   │       ├── login_screen.dart
│   │       └── language_selection_screen.dart
│   │
│   ├── gas_plant/
│   │   ├── provider/                  # ViewModels for gas plant
│   │   │   ├── order_provider.dart
│   │   │   ├── gas_rate_provider.dart
│   │   │   └── expense_provider.dart
│   │   └── view/                      # Views for gas plant
│   │       ├── gas_plant_dashboard_screen.dart
│   │       ├── orders_screen.dart
│   │       ├── gas_rate_screen.dart
│   │       ├── expenses_screen.dart
│   │       └── settings_screen.dart
│   │
│   └── distributor/
│       ├── provider/                  # ViewModels for distributor
│       │   └── driver_provider.dart
│       └── view/                      # Views for distributor
│           ├── distributor_dashboard_screen.dart
│           ├── distributor_orders_screen.dart
│           ├── drivers_screen.dart
│           └── distributor_settings_screen.dart
│
└── shared/                            # Shared/reusable widgets
    └── widgets/
        ├── custom_button.dart
        ├── custom_card.dart
        ├── custom_text_field.dart
        ├── empty_state_widget.dart
        ├── error_widget.dart
        └── loading_widget.dart
```

## Key Components

### 1. `main.dart` - Entry Point ✨
**Purpose**: Application initialization only

```dart
void main() async {
  final initializer = AppInitializer();
  await initializer.initialize();
  
  runApp(
    AppProvider(
      storageService: initializer.storageService,
      apiService: initializer.apiService,
      authService: initializer.authService,
      child: const MyApp(),
    ),
  );
}
```

**Responsibilities**:
- Initialize services via `AppInitializer`
- Run the app with `AppProvider` wrapping `MyApp`
- **NO business logic, NO UI, NO provider setup**

---

### 2. `AppInitializer` - Service Setup
**Location**: `lib/core/app/app_initializer.dart`

**Purpose**: Initialize all services before app starts

```dart
final initializer = AppInitializer();
await initializer.initialize();
```

**Responsibilities**:
- Initialize Flutter bindings
- Set up `StorageService`, `ApiService`, `AuthService`
- Ensure all services are ready before app runs

---

### 3. `AppProvider` - Central Provider Management 🎯
**Location**: `lib/core/providers/app_provider.dart`

**Purpose**: Single source of truth for all providers

```dart
AppProvider(
  storageService: storageService,
  apiService: apiService,
  authService: authService,
  child: const MyApp(),
)
```

**Responsibilities**:
- Register all services with `Provider.value()`
- Register all feature providers with `ChangeNotifierProvider()`
- Manage dependency injection for all providers

**Provider Hierarchy**:
1. **Services** (singleton instances):
   - `StorageService`
   - `ApiService`
   - `AuthService`

2. **Feature Providers** (ViewModels):
   - Common: `AuthProvider`, `LanguageProvider`, `ThemeProvider`
   - Gas Plant: `OrderProvider`, `GasRateProvider`, `ExpenseProvider`
   - Distributor: `DriverProvider`

---

### 4. `MyApp` - Root Widget
**Location**: `lib/app.dart`

**Purpose**: Configure MaterialApp with theme and routing

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, _) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}
```

**Responsibilities**:
- Configure app theme (light/dark)
- Set up navigation routes
- Observe theme and language changes
- **Pure View component - no business logic**

---

## MVVM Implementation

### Model
**Location**: `lib/core/models/`

Data structures representing business entities:
- `UserModel`
- `OrderModel`
- `DriverModel`
- `ExpenseModel`
- `GasRateModel`

Example:
```dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  // ...
}
```

---

### View
**Location**: `lib/features/*/view/`

UI components that display data and handle user interactions:

```dart
class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        if (orderProvider.isLoading) {
          return LoadingWidget();
        }
        return ListView.builder(
          itemCount: orderProvider.orders.length,
          itemBuilder: (context, index) {
            // Build order item
          },
        );
      },
    );
  }
}
```

**Characteristics**:
- Stateless or Stateful widgets
- Use `Consumer` or `Provider.of()` to access ViewModels
- Handle user input and navigation
- **NO business logic - delegate to ViewModel**

---

### ViewModel (Provider)
**Location**: `lib/features/*/provider/`

Business logic and state management:

```dart
class OrderProvider extends ChangeNotifier {
  final ApiService _apiService;
  
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  
  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await _apiService.get('/orders');
      _orders = response['orders']
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } catch (e) {
      _errorMessage = 'Failed to fetch orders: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

**Characteristics**:
- Extends `ChangeNotifier`
- Manages state for a feature
- Communicates with services
- Notifies views of state changes via `notifyListeners()`

---

## Service Layer

### Services
**Location**: `lib/core/services/`

External dependencies and infrastructure:

#### `ApiService`
- HTTP requests (GET, POST, PUT, DELETE)
- API endpoint management
- Error handling

#### `AuthService`
- User authentication
- Token management
- Session handling

#### `StorageService`
- Local data persistence
- SharedPreferences wrapper
- Settings storage

---

## Data Flow

```
┌─────────────────────────────────────────────────┐
│                   main.dart                     │
│  (Initialize services → Run app with providers) │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│              AppInitializer                     │
│   (Create and initialize all services)          │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│               AppProvider                       │
│    (Provide services & ViewModels to tree)      │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│                  MyApp                          │
│         (MaterialApp configuration)             │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│              Feature Views                      │
│   (Consume ViewModels, display UI)              │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│          ViewModels (Providers)                 │
│   (Business logic, state management)            │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│              Services                           │
│        (API, Storage, Auth)                     │
└─────────────────────────────────────────────────┘
```

### User Action Flow Example

1. **User taps "Fetch Orders" button** (View)
2. **View calls** `orderProvider.fetchOrders()` (ViewModel)
3. **ViewModel** sets `_isLoading = true` and calls `notifyListeners()`
4. **View rebuilds** showing loading indicator
5. **ViewModel calls** `apiService.get('/orders')` (Service)
6. **Service** makes HTTP request and returns data
7. **ViewModel** processes data, updates `_orders` list
8. **ViewModel** sets `_isLoading = false` and calls `notifyListeners()`
9. **View rebuilds** showing the orders list

---

## Benefits of This Architecture

### ✅ Clean `main.dart`
- Only 20 lines
- Easy to understand
- No clutter

### ✅ Centralized Provider Management
- All providers in one place (`AppProvider`)
- Easy to add/remove providers
- Clear dependency tree

### ✅ Testability
- Services can be mocked
- ViewModels can be tested independently
- Views can be tested with mock providers

### ✅ Scalability
- Easy to add new features
- Clear folder structure
- Minimal coupling between features

### ✅ Maintainability
- Single Responsibility Principle
- Easy to locate code
- Clear separation of concerns

---

## Adding a New Feature

### Example: Adding a "Reports" feature

1. **Create folder structure**:
```
features/reports/
├── provider/
│   └── report_provider.dart
└── view/
    └── reports_screen.dart
```

2. **Create ViewModel**:
```dart
// features/reports/provider/report_provider.dart
class ReportProvider extends ChangeNotifier {
  final ApiService _apiService;
  
  ReportProvider({required ApiService apiService})
      : _apiService = apiService;
  
  // State and methods
}
```

3. **Register in AppProvider**:
```dart
// core/providers/app_provider.dart
ChangeNotifierProvider<ReportProvider>(
  create: (_) => ReportProvider(apiService: apiService),
),
```

4. **Create View**:
```dart
// features/reports/view/reports_screen.dart
class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder: (context, reportProvider, _) {
        // Build UI
      },
    );
  }
}
```

5. **Add route** in `AppRoutes`

**That's it!** No changes to `main.dart` required.

---

## Best Practices

### DO ✅
- Keep `main.dart` clean - only initialization
- Use `AppProvider` for all provider registration
- Follow MVVM pattern strictly
- Use `Consumer` or `Provider.of()` in views
- Call `notifyListeners()` after state changes
- Inject dependencies through constructors

### DON'T ❌
- Add business logic to views
- Access services directly from views
- Create providers inside views
- Use global variables
- Mix UI and business logic
- Put provider setup in `main.dart`

---

## Summary

This architecture provides:
- **Clean separation** between UI, business logic, and data
- **Centralized provider management** via `AppProvider`
- **Easy testing** with dependency injection
- **Scalability** for growing features
- **Maintainability** through clear structure

The app is production-ready and follows Flutter best practices! 🚀

