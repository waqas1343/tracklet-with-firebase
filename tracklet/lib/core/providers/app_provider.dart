import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Services
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/firebase_service.dart';

// Providers
import '../../features/common/provider/auth_provider.dart';
import '../../features/common/provider/language_provider.dart';
import '../../features/common/provider/theme_provider.dart';
import '../../features/distributor/provider/driver_provider.dart';
import '../../features/distributor/provider/plant_request_provider.dart';
import '../../features/gas_plant/provider/expense_provider.dart';
import '../../features/gas_plant/provider/gas_rate_provider.dart';
import '../../features/gas_plant/provider/order_provider.dart';
import '../../features/gas_plant/provider/employee_provider.dart';
import 'user_role_provider.dart';
import 'navigation_view_model.dart';
import '../services/firebase_auth_provider.dart';

/// AppProvider: Central provider management class
///
/// This class acts as the root of all state management in the application.
/// It handles the registration and initialization of all services and providers.
///
/// Following MVVM principles:
/// - Services are provided as values (singleton instances)
/// - ViewModels (Providers) are created with their dependencies
class AppProvider extends StatelessWidget {
  final Widget child;
  final StorageService storageService;
  final ApiService apiService;
  final AuthService authService;
  final FirebaseService firebaseService;

  const AppProvider({
    super.key,
    required this.child,
    required this.storageService,
    required this.apiService,
    required this.authService,
    required this.firebaseService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ============================================================
        // SERVICES LAYER
        // ============================================================
        // Services are provided as singleton instances
        // These are the foundation of the app's business logic
        Provider<StorageService>.value(value: storageService),
        Provider<ApiService>.value(value: apiService),
        Provider<AuthService>.value(value: authService),
        Provider<FirebaseService>.value(value: firebaseService),

        // ============================================================
        // VIEWMODEL LAYER (PROVIDERS)
        // ============================================================
        // Providers act as ViewModels in MVVM architecture
        // They handle business logic and state management for views

        // --- Common Feature Providers ---
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authService: authService),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) => LanguageProvider(storageService: storageService),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(storageService: storageService),
        ),

        // --- Firebase Provider ---
        ChangeNotifierProvider<FirebaseAuthProvider>(
          create: (_) => FirebaseAuthProvider(),
        ),

        // --- Gas Plant Feature Providers ---
        ChangeNotifierProvider<OrderProvider>(
          create: (_) => OrderProvider(apiService: apiService),
        ),
        ChangeNotifierProvider<GasRateProvider>(
          create: (_) => GasRateProvider(apiService: apiService),
        ),
        ChangeNotifierProvider<ExpenseProvider>(
          create: (_) => ExpenseProvider(apiService: apiService),
        ),
        ChangeNotifierProvider<EmployeeProvider>(
          create: (_) => EmployeeProvider(),
        ),

        // --- Distributor Feature Providers ---
        ChangeNotifierProvider<DriverProvider>(
          create: (_) => DriverProvider(apiService: apiService),
        ),
        ChangeNotifierProvider<PlantRequestProvider>(
          create: (_) => PlantRequestProvider(apiService: apiService),
        ),

        // --- App-wide Providers ---
        ChangeNotifierProvider<UserRoleProvider>(
          create: (_) => UserRoleProvider(storageService: storageService),
        ),
        ChangeNotifierProvider<NavigationViewModel>(
          create: (_) => NavigationViewModel(),
        ),
      ],
      child: child,
    );
  }
}
