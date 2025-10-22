import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/models/order_model.dart';
import '../../../core/utils/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../core/providers/profile_provider.dart';
import '../provider/driver_provider.dart';
import '../widgets/driver_assignment_dialog.dart';

class DistributorOrdersScreen extends StatefulWidget {
  const DistributorOrdersScreen({super.key});

  @override
  State<DistributorOrdersScreen> createState() => _DistributorOrdersScreenState();
}

class _DistributorOrdersScreenState extends State<DistributorOrdersScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _initialLoadCompleted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            // Only show loading indicator during initial load, not for real-time updates
            if (orderProvider.isLoading && !_initialLoadCompleted) {
              return const LoadingWidget(message: 'Loading orders...');
            }
            
            // Mark initial load as completed after first data load
            if (!_initialLoadCompleted && !orderProvider.isLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _initialLoadCompleted = true;
                  });
                }
              });
            }

            return TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(
                  context,
                  orderProvider.pendingOrders,
                  'No pending orders',
                ),
                _buildOrderList(
                  context,
                  orderProvider.processingOrders,
                  'No active orders',
                ),
                _buildOrderList(
                  context,
                  orderProvider.completedOrders,
                  'No completed orders',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    List<OrderModel> orders,
    String emptyMessage,
  ) {
    if (orders.isEmpty) {
      return EmptyStateWidget(
        message: emptyMessage,
        icon: Icons.receipt_long_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<OrderProvider>().refreshOrders(''),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(context, order);
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.distributorName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order #${order.id.substring(0, 8)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              _buildStatusChip(order.status),
            ],
          ),
          const SizedBox(height: 12),
          if (order.driverName != null && order.driverName!.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  'Driver: ${order.driverName}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
          ]
          else ...[
            // Add button to assign driver if not already assigned
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Show driver assignment dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ChangeNotifierProvider(
                      create: (context) => DriverProvider(),
                      child: DriverAssignmentDialog(
                        order: order,
                        onAssignmentComplete: () {
                          // Refresh orders after assignment
                          final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                          final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                          if (profileProvider.currentUser != null) {
                            orderProvider.loadOrdersForDistributor(profileProvider.currentUser!.id);
                          }
                        },
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(30),
              ),
              child: const Text(
                'Assign Driver',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${order.totalKg.toInt()} kg',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Amount',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'PKR ${order.finalPrice.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (order.specialInstructions != null && order.specialInstructions!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.note, size: 16, color: AppColors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.specialInstructions!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    String text;

    switch (status) {
      case OrderStatus.pending:
        color = AppColors.orderPending;
        text = 'Pending';
        break;
      case OrderStatus.confirmed:
        color = AppColors.orderProcessing;
        text = 'Confirmed';
        break;
      case OrderStatus.inProgress:
        color = AppColors.orderProcessing;
        text = 'In Progress';
        break;
      case OrderStatus.completed:
        color = AppColors.orderCompleted;
        text = 'Completed';
        break;
      case OrderStatus.cancelled:
        color = AppColors.orderCancelled;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}