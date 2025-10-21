import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_role_provider.dart';
import '../providers/navigation_view_model.dart';
import '../widgets/unified_bottom_nav_bar.dart';
import '../utils/app_colors.dart';

// Gas Plant Screens
import '../../features/gas_plant/view/gas_plant_dashboard_screen.dart';
import '../../features/gas_plant/view/gas_rate_screen.dart';
import '../../features/gas_plant/view/orders_screen.dart';
import '../../features/gas_plant/view/expenses_screen.dart';
import '../../features/gas_plant/view/settings_screen.dart';

// Distributor Screens
import '../../features/distributor/view/distributor_dashboard_screen.dart';
import '../../features/distributor/view/distributor_orders_screen.dart';
import '../../features/distributor/view/drivers_screen.dart';
import '../../features/distributor/view/distributor_settings_screen.dart';

/// UnifiedMainScreen: Automatically detects user role and shows appropriate screens
///
/// Features:
/// - Role-based screen switching
/// - Unified navigation
/// - Provider-based state management
/// - Responsive design
class UnifiedMainScreen extends StatelessWidget {
  const UnifiedMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final navigationViewModel = Provider.of<NavigationViewModel>(context);

    // Debug: Print current role
    print(
      '🏠 UnifiedMainScreen - Current role: ${userRoleProvider.currentRole}',
    );

    // Get pages based on user role
    final pages = _getPages(userRoleProvider.currentRole);

    // Ensure currentIndex is within bounds to prevent RangeError
    final safeIndex = navigationViewModel.currentIndex < pages.length
        ? navigationViewModel.currentIndex
        : 0; // Default to first tab if index is out of bounds

    return Scaffold(
      backgroundColor: AppColors.background,
      body: pages[safeIndex],
      bottomNavigationBar: const UnifiedBottomNavBar(),
    );
  }

  /// Get pages based on user role
  List<Widget> _getPages(UserRole role) {
    print('📱 _getPages called with role: $role');

    if (role == UserRole.gasPlant) {
      print('✅ Loading GAS PLANT screens (5 tabs)');
      return const [
        GasPlantDashboardScreen(),
        GasRateScreen(),
        OrdersScreen(),
        ExpensesScreen(),
        SettingsScreen(),
      ];
    } else {
      print('✅ Loading DISTRIBUTOR screens (4 tabs)');
      // Distributor - Only 4 screens for 4 tabs
      return const [
        DistributorDashboardScreen(),
        DistributorOrdersScreen(),
        DriversScreen(),
        DistributorSettingsScreen(),
      ];
    }
  }
}