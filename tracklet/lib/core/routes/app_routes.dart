import 'package:flutter/material.dart';
import '../../features/common/view/splash_screen.dart';
import '../../features/common/view/onboarding_screen.dart';
import '../../features/common/view/language_selection_screen.dart';
import '../../features/common/view/login_screen.dart';
import '../../features/gas_plant/view/gas_plant_dashboard_screen.dart';
import '../../features/gas_plant/view/gas_rate_screen.dart';
import '../../features/gas_plant/view/orders_screen.dart';
import '../../features/gas_plant/view/expenses_screen.dart';
import '../../features/gas_plant/view/settings_screen.dart';
import '../../features/gas_plant/view/total_stock_screen.dart';
import '../../features/gas_plant/view/employee/active_employees_screen.dart';
import '../../features/gas_plant/view/orders_in_progress_screen.dart';
import '../../features/distributor/view/distributor_dashboard_screen.dart';
import '../../features/distributor/view/distributor_orders_screen.dart';
import '../../features/distributor/view/drivers_screen.dart';
import '../../features/distributor/view/distributor_settings_screen.dart';
import '../../core/models/company_model.dart'; // Added import
import '../screens/unified_main_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String languageSelection = '/language-selection';
  static const String login = '/login';

  // Main Navigation Routes
  static const String unifiedMain = '/main';

  // Gas Plant Routes
  static const String gasPlantDashboard = '/gas-plant/dashboard';
  static const String gasPlantGasRate = '/gas-plant/gas-rate';
  static const String gasPlantOrders = '/gas-plant/orders';
  static const String gasPlantExpenses = '/gas-plant/expenses';
  static const String gasPlantSettings = '/gas-plant/settings';
  static const String gasPlantTotalStock = '/gas-plant/total-stock';
  static const String gasPlantActiveEmployees = '/gas-plant/active-employees';
  static const String gasPlantNewOrders = '/gas-plant/new-orders';
  static const String gasPlantOrdersInProgress =
      '/gas-plant/orders-in-progress';

  // Distributor Routes
  static const String distributorDashboard = '/distributor/dashboard';
  static const String distributorOrders = '/distributor/orders';
  static const String distributorDrivers = '/distributor/drivers';
  static const String distributorSettings = '/distributor/settings';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      languageSelection: (context) => const LanguageSelectionScreen(),
      login: (context) => const LoginScreen(),

      // Main Navigation Routes
      unifiedMain: (context) => const UnifiedMainScreen(),

      // Gas Plant Routes
      gasPlantDashboard: (context) => const GasPlantDashboardScreen(),
      gasPlantGasRate: (context) => GasRateScreen(
        company: CompanyModel(
          id: '',
          companyName: '',
          contactNumber: '',
          address: '',
          operatingHours: '',
          createdAt: DateTime.now(),
        ),
      ), // Updated to pass a default company
      gasPlantOrders: (context) => const OrdersScreen(),
      gasPlantExpenses: (context) => const ExpensesScreen(),
      gasPlantSettings: (context) => const SettingsScreen(),
      gasPlantTotalStock: (context) => const TotalStockScreen(),
      gasPlantActiveEmployees: (context) => const ActiveEmployeesScreen(),
      gasPlantOrdersInProgress: (context) => const OrdersInProgressScreen(),

      // Distributor Routes
      distributorDashboard: (context) => const DistributorDashboardScreen(),
      distributorOrders: (context) => const DistributorOrdersScreen(),
      distributorDrivers: (context) => const DriversScreen(),
      distributorSettings: (context) => const DistributorSettingsScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Handle routes with parameters
    if (settings.name == gasPlantOrders) {
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (context) => OrdersScreen(
          highlightedOrderId: args?['highlightedOrderId'] as String?,
        ),
      );
    }

    if (settings.name == gasPlantOrdersInProgress) {
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (context) => OrdersInProgressScreen(
          highlightedOrderId: args?['highlightedOrderId'] as String?,
        ),
      );
    }

    if (settings.name == gasPlantGasRate) {
      final args = settings.arguments as CompanyModel?;
      if (args != null) {
        return MaterialPageRoute(
          builder: (context) => GasRateScreen(company: args),
        );
      }
    }

    // Handle unknown routes
    return null;
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(child: Text('Route not found: ${settings.name}')),
      ),
    );
  }
}
