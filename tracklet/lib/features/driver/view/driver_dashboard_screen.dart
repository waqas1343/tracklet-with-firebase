import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/models/order_model.dart';
import '../../../shared/widgets/section_header_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/driver_order_card.dart';
import '../../../core/utils/app_colors.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  bool _initialLoadCompleted = false;

  @override
  void initState() {
    super.initState();
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
              _buildDriverSummarySection(context),
              const SizedBox(height: 14),
              _buildAssignedOrdersSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverSummarySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(title: 'Driver Summary', onSeeAllPressed: () {}),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Active Orders',
                subtitle: "In Progress",
                value: '0', // Will be updated with real data
                icon: Icons.local_shipping,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Completed',
                subtitle: "This Month",
                value: '0', // Will be updated with real data
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedOrdersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'Assigned Orders',
          onSeeAllPressed: () {
            // Navigate to all orders screen
          },
        ),
        const SizedBox(height: 16),
        Consumer<OrderProvider>(
          builder: (context, orderProvider, child) {
            // Load orders when screen is first displayed
            if (!orderProvider.isLoading && !_initialLoadCompleted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadDriverOrders(orderProvider);
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

            // Get orders assigned to this driver
            final profileProvider = Provider.of<ProfileProvider>(
              context,
              listen: false,
            );
            final user = profileProvider.currentUser;

            if (user == null) {
              return const EmptyStateWidget(
                icon: Icons.person_off,
                message: 'User Not Found\nPlease log in again',
              );
            }

            final assignedOrders = orderProvider.orders
                .where((order) => order.driverName == user.name)
                .toList();

            if (assignedOrders.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.local_shipping,
                message:
                    'No Assigned Orders\nYou don\'t have any assigned orders yet',
              );
            }

            return Column(
              children: [
                // Show only the first 3 assigned orders
                ...assignedOrders
                    .take(3)
                    .map(
                      (order) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DriverOrderCard(
                          order: order,
                          onCompletePressed:
                              null, // Drivers cannot complete orders
                          onTap: () {
                            // Navigate to order details if needed
                          },
                        ),
                      ),
                    ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _loadDriverOrders(OrderProvider orderProvider) async {
    if (_initialLoadCompleted) return;

    setState(() {
      _initialLoadCompleted = true;
    });

    try {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      final user = profileProvider.currentUser;

      if (user != null) {
        await orderProvider.loadOrdersForDriver(user.name);
      }
    } catch (e) {
    }
  }
}
