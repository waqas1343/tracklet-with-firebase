import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/models/order_model.dart';
import '../../../shared/widgets/section_header_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/driver_list_card.dart';
import '../../../core/utils/app_colors.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  bool _initialLoadCompleted = false;

  @override
  void initState() {
    super.initState();
  }

  void _refreshDriversList() {
    // Refresh the drivers list by reloading data
    setState(() {
      _initialLoadCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 14),
              _buildDriversListSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'All Drivers',
          onSeeAllPressed: () {
            _refreshDriversList();
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tap on any driver to see their assigned orders',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriversListSection(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        // Load orders when screen is first displayed
        if (!orderProvider.isLoading && !_initialLoadCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadAllOrders(orderProvider);
          });
        }

        if (orderProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Get all unique drivers from orders
        final allOrders = orderProvider.orders;
        final driversWithOrders = <String, List<OrderModel>>{};

        for (var order in allOrders) {
          if (order.driverName != null && order.driverName!.isNotEmpty) {
            if (!driversWithOrders.containsKey(order.driverName)) {
              driversWithOrders[order.driverName!] = [];
            }
            driversWithOrders[order.driverName!]!.add(order);
          }
        }

        if (driversWithOrders.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.person_off,
            message: 'No drivers with assigned orders found',
          );
        }

        return Column(
          children: [
            // Show all drivers with their order counts
            ...driversWithOrders.entries.map((entry) {
              final driverName = entry.key;
              final orders = entry.value;
              final activeOrders = orders
                  .where((order) => order.status == OrderStatus.inProgress)
                  .length;
              final completedOrders = orders
                  .where((order) => order.status == OrderStatus.completed)
                  .length;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DriverListCard(
                  driverName: driverName,
                  totalOrders: orders.length,
                  activeOrders: activeOrders,
                  completedOrders: completedOrders,
                  onTap: () => _showDriverOrders(driverName, orders),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Future<void> _loadAllOrders(OrderProvider orderProvider) async {
    if (_initialLoadCompleted) return;

    setState(() {
      _initialLoadCompleted = true;
    });

    try {
      // Load all orders to get driver information
      // This is a simplified approach - in a real app, you might want to load from a specific plant
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      final user = profileProvider.currentUser;

      if (user != null) {
        // Load orders for the current user's plant
        await orderProvider.loadOrdersForPlant(user.id);
      }
    } catch (e) {}
  }

  void _showDriverOrders(String driverName, List<OrderModel> orders) {
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
                        'Orders for $driverName',
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
              // Orders list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Order #${order.id.substring(0, 8)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      order.status,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _getStatusColor(order.status),
                                    ),
                                  ),
                                  child: Text(
                                    order.statusText,
                                    style: TextStyle(
                                      color: _getStatusColor(order.status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'From: ${order.distributorName}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'To: ${order.plantName}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Weight: ${order.totalKg.toInt()} KG',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            if (order.specialInstructions != null &&
                                order.specialInstructions!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Instructions: ${order.specialInstructions}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
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

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.inProgress:
        return AppColors.primary;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
