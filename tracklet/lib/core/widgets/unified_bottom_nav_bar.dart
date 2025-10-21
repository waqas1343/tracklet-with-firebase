import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_role_provider.dart';
import '../providers/navigation_view_model.dart';
import '../utils/app_colors.dart';

/// UnifiedBottomNavBar: Automatically detects user role and shows appropriate tabs
///
/// Features:
/// - Role-based navigation (Gas Plant vs Distributor)
/// - Custom styling with active state
/// - Responsive design
/// - Provider-based state management
class UnifiedBottomNavBar extends StatelessWidget {
  const UnifiedBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final navigationViewModel = Provider.of<NavigationViewModel>(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavItems(
              context,
              userRoleProvider.currentRole,
              navigationViewModel.currentIndex,
            ),
          ),
        ),
      ),
    );
  }

  /// Build navigation items based on user role
  List<Widget> _buildNavItems(
    BuildContext context,
    UserRole role,
    int currentIndex,
  ) {
    if (role == UserRole.gasPlant) {
      // Gas Plant: 5 tabs
      return [
        _buildNavItem(
          context: context,
          icon: Icons.home,
          label: 'Home',
          index: 0,
          currentIndex: currentIndex,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.local_gas_station,
          label: 'Gas Rates',
          index: 1,
          currentIndex: currentIndex,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.shopping_cart,
          label: 'Orders',
          index: 2,
          currentIndex: currentIndex,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.account_balance_wallet,
          label: 'Expenses',
          index: 3,
          currentIndex: currentIndex,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.settings,
          label: 'Settings',
          index: 4,
          currentIndex: currentIndex,
        ),
      ];
    } else {
      // Distributor: 4 tabs
      return [
        _buildNavItem(
          context: context,
          icon: Icons.home,
          label: 'Home',
          index: 0,
          currentIndex: currentIndex,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.inventory_2,
          label: 'Orders',
          index: 1,
          currentIndex: currentIndex,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.people,
          label: 'Drivers',
          index: 2,
          currentIndex: currentIndex,
        ),
        _buildNavItem(
          context: context,
          icon: Icons.settings,
          label: 'Settings',
          index: 3,
          currentIndex: currentIndex,
        ),
      ];
    }
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    final bool isSelected = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Provider.of<NavigationViewModel>(
            context,
            listen: false,
          ).navigateToIndex(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
