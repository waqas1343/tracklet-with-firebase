import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../providers/user_role_provider.dart';
import '../providers/navigation_view_model.dart';
import '../widgets/unified_bottom_nav_bar.dart';
import '../utils/app_colors.dart';
import '../providers/profile_provider.dart';
import '../providers/company_provider.dart';
import '../models/company_model.dart';
import '../services/fcm_service.dart';
import '../../features/distributor/widgets/driver_assignment_dialog.dart';
import '../providers/order_provider.dart';
import '../../features/distributor/provider/driver_provider.dart';

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

// Driver Screens
import '../../features/driver/view/driver_dashboard_screen.dart';
import '../../features/driver/view/driver_list_screen.dart';

class UnifiedMainScreen extends StatefulWidget {
  const UnifiedMainScreen({super.key});

  @override
  State<UnifiedMainScreen> createState() => _UnifiedMainScreenState();
}

class _UnifiedMainScreenState extends State<UnifiedMainScreen> {
  CompanyModel? _company;

  @override
  void initState() {
    super.initState();
    // Set up notification tap handler
    _setupNotificationHandler();

    // Save FCM token for current user
    _saveFCMToken();
  }

  void _setupNotificationHandler() {
    // Set up callback for notification taps
    FCMService.instance.onNotificationTap = (String orderId) {
      if (kDebugMode) {
        print('🔔 Notification tap callback triggered for order: $orderId');
      }
      // Show driver assignment dialog when notification is tapped
      _showDriverAssignmentDialog(orderId);
    };

    if (kDebugMode) {
      print('✅ Notification tap callback set');
    }
  }

  void _showDriverAssignmentDialog(String orderId) {
    if (kDebugMode) {
      print('🔍 _showDriverAssignmentDialog called for order: $orderId');
    }

    // Get the order from the repository
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // We need to fetch the order by ID
    orderProvider
        .getOrderById(orderId)
        .then((order) {
          if (kDebugMode) {
            print('🔍 Order fetched: ${order?.id}');
          }

          if (order != null && mounted) {
            if (kDebugMode) {
              print(
                '✅ Showing driver assignment dialog for order: ${order.id}',
              );
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ChangeNotifierProvider(
                  create: (context) => DriverProvider(),
                  child: DriverAssignmentDialog(
                    order: order,
                    onAssignmentComplete: () {
                      // Refresh orders after assignment
                      final profileProvider = Provider.of<ProfileProvider>(
                        context,
                        listen: false,
                      );
                      if (profileProvider.currentUser != null) {
                        orderProvider.loadOrdersForDistributor(
                          profileProvider.currentUser!.id,
                        );
                      }
                    },
                  ),
                );
              },
            );
          } else if (mounted) {
            if (kDebugMode) {
              print('❌ Order is null or context not mounted');
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to load order details'),
                backgroundColor: Colors.red,
              ),
            );
          }
        })
        .catchError((error) {
          if (kDebugMode) {
            print('❌ Error fetching order: $error');
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading order: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }

  void _saveFCMToken() async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      if (profileProvider.currentUser != null) {
        final fcmService = FCMService.instance;
        await fcmService.saveFCMToken(profileProvider.currentUser!.id);
        if (kDebugMode) {
          print(
            '✅ FCM token saved for current user: ${profileProvider.currentUser!.id}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to save FCM token: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final companyProvider = Provider.of<CompanyProvider>(context);

    // Load company data if not already loaded
    if (_company == null &&
        profileProvider.currentUser != null &&
        companyProvider.companies.isNotEmpty) {
      // Try to find the company that matches the current user
      final userCompany = companyProvider.companies.firstWhere(
        (company) => company.id == profileProvider.currentUser!.id,
        orElse: () => companyProvider.companies.first,
      );

      setState(() {
        _company = userCompany;
      });
    }

    final pages = _getPages(
      userRoleProvider.currentRole,
      profileProvider,
      companyProvider,
    );
    final safeIndex = navigationViewModel.currentIndex < pages.length
        ? navigationViewModel.currentIndex
        : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: pages[safeIndex],
      bottomNavigationBar: const UnifiedBottomNavBar(),
    );
  }

  List<Widget> _getPages(
    UserRole role,
    ProfileProvider profileProvider,
    CompanyProvider companyProvider,
  ) {
    if (role == UserRole.gasPlant) {
      // Get company data for the current user
      CompanyModel companyToUse;

      if (_company != null) {
        companyToUse = _company!;
      } else if (profileProvider.currentUser != null) {
        // Create a company model from user data
        companyToUse = CompanyModel(
          id: profileProvider.currentUser!.id,
          companyName: profileProvider.currentUser!.companyName ?? '',
          contactNumber: profileProvider.currentUser!.phone,
          address: profileProvider.currentUser!.address ?? '',
          operatingHours: profileProvider.currentUser!.operatingHours ?? '',
          createdAt: profileProvider.currentUser!.createdAt,
          updatedAt: DateTime.now(),
        );
      } else {
        // Fallback company model with empty ID
        companyToUse = CompanyModel(
          id: '',
          companyName: '',
          contactNumber: '',
          address: '',
          operatingHours: '',
          createdAt: DateTime.now(),
        );
      }

      return [
        const GasPlantDashboardScreen(),
        GasRateScreen(company: companyToUse),
        const OrdersScreen(),
        const ExpensesScreen(),
        const SettingsScreen(),
      ];
    } else if (role == UserRole.distributor) {
      return const [
        DistributorDashboardScreen(),
        DistributorOrdersScreen(),
        DriversScreen(),
        DistributorSettingsScreen(),
      ];
    } else if (role == UserRole.driver) {
      return const [
        DriverDashboardScreen(),
        DriverListScreen(), // Show list of drivers and their orders
        DriverDashboardScreen(), // For now, using dashboard for history
        DriverDashboardScreen(), // For now, using dashboard for settings
      ];
    } else {
      // Fallback to distributor
      return const [
        DistributorDashboardScreen(),
        DistributorOrdersScreen(),
        DriversScreen(),
        DistributorSettingsScreen(),
      ];
    }
  }

  @override
  void dispose() {
    // Clear the callback when widget is disposed
    FCMService.instance.onNotificationTap = null;
    super.dispose();
  }
}
