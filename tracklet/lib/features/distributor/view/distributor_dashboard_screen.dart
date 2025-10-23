import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
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
import 'order_analytics_screen.dart';
import '../widgets/order_card.dart';
import '../../../shared/widgets/custom_flushbar.dart';

class DistributorDashboardScreen extends StatefulWidget {
  const DistributorDashboardScreen({super.key});

  @override
  State<DistributorDashboardScreen> createState() =>
      _DistributorDashboardScreenState();
}

class _DistributorDashboardScreenState
    extends State<DistributorDashboardScreen> {
  bool _isOrdersLoading = false;
  bool _ordersLoaded = false;
  bool _initialOrdersLoadCompleted = false;
  StreamSubscription<List<CompanyModel>>? _companiesSubscription;

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

    // Subscribe to real-time company updates
    if (_companiesSubscription == null) {
      _companiesSubscription = companyProvider.companiesStream.listen((
        companies,
      ) {
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
    if (_isOrdersLoading &&
        !orderProvider.isLoading &&
        !_initialOrdersLoadCompleted) {
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
      appBar: CustomAppBar(userName: user?.name ?? '', showBackButton: true),
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
                _navigateToAllPlants(context);
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Request Cylinder',
                        onPressed: () =>
                            _navigateToCylinderRequest(context, company),
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.white,
                        height: 40,
                        borderRadius: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousOrdersSection(
    BuildContext context,
    OrderProvider orderProvider,
  ) {
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
                Navigator.pushNamed(context, '/distributor/orders');
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
                .map<Widget>(
                  (OrderModel order) => OrderCard(
                    order: order,
                    onTap: () => _showOrderDetails(order),
                  ),
                )
                .toList(growable: false),
          ),
      ],
    );
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Order Details',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Order details
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: OrderCard(
                    order: order,
                    onTap: null, // Disable tap in modal
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCylinderRequest(BuildContext context, CompanyModel company) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CylinderRequestScreen(company: company),
      ),
    );
  }

  void _navigateToAnalytics(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const OrderAnalyticsScreen()),
    );
  }

  void _navigateToAllPlants(BuildContext context) {
    // Navigate to all plants screen or show all plants in a modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Gas Plants',
                      style: AppTextTheme.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<CompanyProvider>(
                  builder: (context, companyProvider, child) {
                    if (companyProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final allPlants = companyProvider.companies;

                    if (allPlants.isEmpty) {
                      return const Center(child: Text('No plants available'));
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: allPlants.length,
                      itemBuilder: (context, index) {
                        final plant = allPlants[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.1,
                              ),
                              child: Icon(
                                Icons.business,
                                color: AppColors.primary,
                              ),
                            ),
                            title: Text(plant.companyName),
                            subtitle: Text(plant.address),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.pop(context);
                                _navigateToCylinderRequest(context, plant);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadDistributorOrders(
    OrderProvider orderProvider,
    String userId,
  ) async {
    try {
      await orderProvider.loadOrdersForDistributor(userId);
    } catch (e) {
      // Handle error silently or show a snackbar
      if (mounted) {
        CustomFlushbar.showError(context, message: 'Failed to load orders: $e');
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
}
