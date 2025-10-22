import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/models/order_model.dart';
import '../../../core/models/company_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/section_header_widget.dart';
import '../../../core/utils/app_text_theme.dart';
import '../../../core/utils/app_colors.dart';
import 'cylinder_request_screen.dart';
import '../widgets/driver_assignment_dialog.dart';

class DistributorDashboardScreen extends StatefulWidget {
  const DistributorDashboardScreen({super.key});

  @override
  State<DistributorDashboardScreen> createState() => _DistributorDashboardScreenState();
}

class _DistributorDashboardScreenState extends State<DistributorDashboardScreen> {
  bool _isOrdersLoading = false;
  bool _ordersLoaded = false;
  bool _initialOrdersLoadCompleted = false;
  StreamSubscription<List<CompanyModel>>? _companiesSubscription;
  bool _companiesLoaded = false;

  @override
  void initState() {
    super.initState();
    // Listen for notification taps
    _listenForNotificationTaps();
  }

  @override
  void dispose() {
    _companiesSubscription?.cancel();
    super.dispose();
  }

  void _listenForNotificationTaps() {
    // This would be implemented to listen for notification taps
    // For now, we'll handle this through the FCM service
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.currentUser;

    // Debug print to see company data
    if (kDebugMode) {
      print('=== Distributor Dashboard Debug ===');
      print('Companies count: ${companyProvider.companies.length}');
      for (var company in companyProvider.companies) {
        print('Company: ${company.companyName}, Rate: ${company.currentRate}, Operating Hours: ${company.operatingHours}');
      }
      print('===================================');
    }

    // Subscribe to real-time company updates
    if (_companiesSubscription == null) {
      _companiesSubscription = companyProvider.companiesStream.listen((companies) {
        if (kDebugMode) {
          print('=== Real-time Company Update ===');
          print('Updated companies count: ${companies.length}');
          for (var company in companies) {
            print('Company: ${company.companyName}, Rate: ${company.currentRate}, Operating Hours: ${company.operatingHours}');
          }
          print('================================');
        }
        // The companies are automatically updated through the provider
        // We just need to ensure the subscription is active
      });
      
      // Load initial companies
      WidgetsBinding.instance.addPostFrameCallback((_) {
        companyProvider.loadAllCompanies();
      });
    }

    // Load orders for distributor only once
    if (user != null && !_isOrdersLoading && !_ordersLoaded) {
      setState(() {
        _isOrdersLoading = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadDistributorOrders(orderProvider, user.id);
      });
    }

    // Mark initial orders load as completed after first data load
    if (_isOrdersLoading && !orderProvider.isLoading && !_initialOrdersLoadCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _initialOrdersLoadCompleted = true;
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        userName: user?.name ?? '',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              _buildSearchBar(),
              const SizedBox(height: 24),

              // Top Plants Section
              _buildTopPlantsSection(context),
              const SizedBox(height: 24),

              // Previous Orders Section
              _buildPreviousOrdersSection(context, orderProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Builder(
        builder: (context) {
          final companyProvider = Provider.of<CompanyProvider>(
            context,
            listen: false,
          );
          return TextField(
            onChanged: (value) {
              companyProvider.searchCompanies(value);
            },
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: AppTextTheme.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopPlantsSection(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    final topPlants = companyProvider.topPlants;
    final isLoading = companyProvider.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Top Plants', style: AppTextTheme.displaySmall),
            SeeAllButton(
              onTap: () {
                // TODO: Navigate to see all plants
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : topPlants.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.business_outlined,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No plants available',
                        style: AppTextTheme.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topPlants.length,
                  itemBuilder: (context, index) {
                    return _buildPlantCard(context, topPlants[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPlantCard(BuildContext context, CompanyModel company) {
    // Debug print for individual company
    if (kDebugMode) {
      print('Building plant card for: ${company.companyName}, Rate: ${company.currentRate}, Operating Hours: ${company.operatingHours}');
    }
    
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plant Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: Colors.grey.shade200,
            ),
            child: company.imageUrl != null && company.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      company.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.landscape,
                          size: 48,
                          color: AppColors.primary,
                        );
                      },
                    ),
                  )
                : Icon(Icons.landscape, size: 48, color: AppColors.primary),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.companyName,
                  style: AppTextTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  company.address,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Replaced operating hours with current rate
                if (company.currentRate != null)
                  Text(
                    'Rate: ${company.currentRate} PKR/KG',
                    style: AppTextTheme.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  Text(
                    company.operatingHours,
                    style: AppTextTheme.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Request Cylinder',
                  onPressed: () => _navigateToCylinderRequest(context, company),
                  width: double.infinity,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                  height: 36,
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousOrdersSection(BuildContext context, OrderProvider orderProvider) {
    final orders = orderProvider.distributorOrders;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Previous Orders', style: AppTextTheme.displaySmall),
            SeeAllButton(
              onTap: () {
                // TODO: Navigate to see all orders
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Only show loading indicator during initial load, not for real-time updates
        if (_isOrdersLoading && !_initialOrdersLoadCompleted)
          const Center(child: CircularProgressIndicator())
        else if (orders.isEmpty)
          Center(
            child: Text(
              'No previous orders',
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          Column(
            children: orders
                .take(3) // Show only the first 3 orders
                .map<Widget>((OrderModel order) => _buildOrderCard(context, order))
                .toList(growable: false),
          ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.plantName,
                style: AppTextTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  order.statusText,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Total: ${order.finalPrice.toInt()} PKR',
            style: AppTextTheme.bodyMedium.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            'Ordered: ${_formatDateTime(order.createdAt)}',
            style: AppTextTheme.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          // Show driver name if assigned
          if (order.driverName != null && order.driverName!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Driver: ${order.driverName}',
              style: AppTextTheme.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          // Add button to assign driver if not already assigned
          if (order.driverName == null || order.driverName!.isEmpty) ...[
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _showDriverAssignmentDialog(context, order),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(30),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                'Assign Driver',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToCylinderRequest(BuildContext context, CompanyModel company) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CylinderRequestScreen(company: company),
      ),
    );
  }

  Future<void> _loadDistributorOrders(OrderProvider orderProvider, String userId) async {
    try {
      await orderProvider.loadOrdersForDistributor(userId);
    } catch (e) {
      // Handle error silently or show a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load orders: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isOrdersLoading = false;
          _ordersLoaded = true;
        });
      }
    }
  }

  // Method to show driver assignment dialog
  void _showDriverAssignmentDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DriverAssignmentDialog(
          order: order,
          onAssignmentComplete: () {
            // Refresh orders after assignment
            final orderProvider = Provider.of<OrderProvider>(context, listen: false);
            final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
            if (profileProvider.currentUser != null) {
              _loadDistributorOrders(orderProvider, profileProvider.currentUser!.id);
            }
          },
        );
      },
    );
  }
}