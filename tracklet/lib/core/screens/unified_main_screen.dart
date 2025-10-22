import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_role_provider.dart';
import '../providers/navigation_view_model.dart';
import '../widgets/unified_bottom_nav_bar.dart';
import '../utils/app_colors.dart';
import '../providers/profile_provider.dart'; // Add this import

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

class UnifiedMainScreen extends StatelessWidget {
  const UnifiedMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    Provider.of<ProfileProvider>(context); 
    final pages = _getPages(userRoleProvider.currentRole);
    final safeIndex = navigationViewModel.currentIndex < pages.length
        ? navigationViewModel.currentIndex
        : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: pages[safeIndex],
      bottomNavigationBar: const UnifiedBottomNavBar(),
    );
  }

  List<Widget> _getPages(UserRole role) {
    if (role == UserRole.gasPlant) {
      return const [
        GasPlantDashboardScreen(),
        GasRateScreen(),
        OrdersScreen(),
        ExpensesScreen(),
        SettingsScreen(),
      ];
    } else {
      return const [
        DistributorDashboardScreen(),
        DistributorOrdersScreen(),
        DriversScreen(),
        DistributorSettingsScreen(),
      ];
    }
  }
}