import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../gas_plant/provider/order_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class DistributorOrdersScreen extends StatelessWidget {
  const DistributorOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            if (orderProvider.isLoading) {
              return const LoadingWidget(message: 'Loading orders...');
            }

            return TabBarView(
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
    List<dynamic> orders,
    String emptyMessage,
  ) {
    if (orders.isEmpty) {
      return EmptyStateWidget(
        message: emptyMessage,
        icon: Icons.receipt_long_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<OrderProvider>().fetchOrders(),
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

  Widget _buildOrderCard(BuildContext context, order) {
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
                      order.customerName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order #${order.id}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              _buildStatusChip(order.status),
            ],
          ),
          const SizedBox(height: 12),
          if (order.driverName != null) ...[
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
                    '${order.quantity} kg',
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
                    'PKR ${order.totalPrice}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (order.deliveryAddress != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.deliveryAddress!,
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

  Widget _buildStatusChip(status) {
    Color color;
    String text;

    switch (status.toString()) {
      case 'OrderStatus.pending':
        color = AppColors.orderPending;
        text = 'Pending';
        break;
      case 'OrderStatus.processing':
        color = AppColors.orderProcessing;
        text = 'Active';
        break;
      case 'OrderStatus.completed':
        color = AppColors.orderCompleted;
        text = 'Completed';
        break;
      default:
        color = AppColors.orderCancelled;
        text = 'Cancelled';
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
