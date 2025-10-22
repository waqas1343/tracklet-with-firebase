import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/models/order_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/utils/app_text_theme.dart';
import '../../../core/utils/app_colors.dart';

class NewOrdersScreen extends StatelessWidget {
  const NewOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.currentUser;

    // Load orders when screen builds
    if (user != null &&
        !orderProvider.isLoading &&
        orderProvider.newOrders.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProvider.loadOrdersForPlant(user.id);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'New Orders',circularBack: , showBackButton: true),
      body: SafeArea(
        child: user == null
            ? const Center(child: Text('User not logged in'))
            : StreamBuilder<List<OrderModel>>(
                stream: orderProvider.getOrdersStreamForPlant(user.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final allOrders = snapshot.data ?? [];
                  
                  // Debug information
                  if (kDebugMode) {
                    print('Gas Plant ID: ${user.id}');
                    print('Total orders loaded: ${allOrders.length}');
                    for (var order in allOrders) {
                      print('Order ID: ${order.id}, Plant ID: ${order.plantId}, Status: ${order.statusText}');
                    }
                  }

                  final newOrders = allOrders
                      .where(
                        (order) =>
                            order.status == OrderStatus.pending ||
                            order.status == OrderStatus.confirmed,
                      )
                      .toList();

                  if (kDebugMode) {
                    print('Filtered new orders (pending/confirmed): ${newOrders.length}');
                  }

                  if (newOrders.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () => orderProvider.refreshOrders(user.id),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: newOrders.length,
                      itemBuilder: (context, index) {
                        final order = newOrders[index];
                        return _buildOrderCard(context, order);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'No new orders',
            style: AppTextTheme.titleLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'New cylinder requests will appear here',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header with distributor name and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.distributorName,
                      style: AppTextTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order #${order.id.substring(0, 8)}...',
                      style: AppTextTheme.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
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

          const SizedBox(height: 16),

          // Order details
          _buildOrderDetailRow('Total Weight', '${order.totalKg.toInt()} KG'),
          const SizedBox(height: 8),
          _buildOrderDetailRow(
            'Total Price',
            '${order.finalPrice.toInt()} PKR',
          ),
          const SizedBox(height: 8),
          _buildOrderDetailRow(
            'Requested Items',
            order.formattedQuantities.join(', '),
          ),
          const SizedBox(height: 8),
          _buildOrderDetailRow('Order Time', _formatDateTime(order.createdAt)),

          if (order.specialInstructions != null &&
              order.specialInstructions!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Special Instructions:',
                    style: AppTextTheme.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.specialInstructions!,
                    style: AppTextTheme.bodySmall.copyWith(
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Action buttons
          if (order.status == OrderStatus.pending) ...[
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Confirm',
                    onPressed: () => _updateOrderStatus(
                      context,
                      order.id,
                      OrderStatus.confirmed,
                    ),
                    backgroundColor: AppColors.success,
                    textColor: AppColors.white,
                    height: 40,
                    borderRadius: 8,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Reject',
                    onPressed: () => _updateOrderStatus(
                      context,
                      order.id,
                      OrderStatus.cancelled,
                    ),
                    backgroundColor: AppColors.error,
                    textColor: AppColors.white,
                    height: 40,
                    borderRadius: 8,
                  ),
                ),
              ],
            ),
          ] else if (order.status == OrderStatus.confirmed) ...[
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Start Processing',
                    onPressed: () => _updateOrderStatus(
                      context,
                      order.id,
                      OrderStatus.inProgress,
                      driverName: 'Romail Ahmed', // Default driver
                    ),
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.white,
                    height: 40,
                    borderRadius: 8,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Complete',
                    onPressed: () => _updateOrderStatus(
                      context,
                      order.id,
                      OrderStatus.completed,
                    ),
                    backgroundColor: AppColors.success,
                    textColor: AppColors.white,
                    height: 40,
                    borderRadius: 8,
                  ),
                ),
              ],
            ),
          ] else if (order.status == OrderStatus.inProgress) ...[
            CustomButton(
              text: 'Mark as Delivered',
              onPressed: () =>
                  _updateOrderStatus(context, order.id, OrderStatus.completed),
              backgroundColor: AppColors.success,
              textColor: AppColors.white,
              height: 40,
              borderRadius: 8,
              width: double.infinity,
            ),
          ],

          const SizedBox(height: 8),

          // Order time
          Text(
            'Ordered: ${_formatDateTime(order.createdAt)}',
            style: AppTextTheme.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: AppTextTheme.bodyMedium.copyWith(color: Colors.black),
        ),
        Text(
          value,
          style: AppTextTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _updateOrderStatus(
    BuildContext context,
    String orderId,
    OrderStatus status, {
    String? driverName,
  }) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    final success = await orderProvider.updateOrderStatus(
      orderId,
      status,
      driverName: driverName,
    );

    if (success) {
      String message = '';
      switch (status) {
        case OrderStatus.confirmed:
          message = 'Order confirmed successfully!';
          break;
        case OrderStatus.inProgress:
          message = 'Order processing started!';
          break;
        case OrderStatus.completed:
          message = 'Order completed successfully!';
          break;
        case OrderStatus.cancelled:
          message = 'Order cancelled!';
          break;
        case OrderStatus.pending:
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.success),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.error ?? 'Failed to update order status'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}