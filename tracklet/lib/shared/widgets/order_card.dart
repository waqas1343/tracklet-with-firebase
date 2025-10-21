import 'package:flutter/material.dart';
import '../../core/models/order_model.dart';
import '../../core/utils/app_text_theme.dart';
import '../../core/utils/app_colors.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onConfirm;
  final VoidCallback? onReject;
  final VoidCallback? onStartProcessing;
  final VoidCallback? onComplete;
  final VoidCallback? onMarkDelivered;

  const OrderCard({
    super.key,
    required this.order,
    this.onConfirm,
    this.onReject,
    this.onStartProcessing,
    this.onComplete,
    this.onMarkDelivered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // White background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown), // Brown border
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
                        color: Colors.black, // Black text
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
                  color: _getStatusColor(order.status), // Black background for chips
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  order.statusText,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: Colors.white, // White text for chips
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

          if (order.specialInstructions != null &&
              order.specialInstructions!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Special Instructions:',
                    style: AppTextTheme.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.specialInstructions!,
                    style: AppTextTheme.bodySmall.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Action buttons based on status
          _buildActionButtons(),

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
          style: AppTextTheme.bodyMedium.copyWith(
            color: Colors.black, // Black text
          ),
        ),
        Text(
          value,
          style: AppTextTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black, // Black text
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (order.status == OrderStatus.pending) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Confirm'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onReject,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Reject'),
            ),
          ),
        ],
      );
    } else if (order.status == OrderStatus.confirmed) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onStartProcessing,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Start Processing'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Complete'),
            ),
          ),
        ],
      );
    } else if (order.status == OrderStatus.inProgress) {
      return ElevatedButton(
        onPressed: onMarkDelivered,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          minimumSize: const Size(double.infinity, 40),
        ),
        child: const Text('Mark as Delivered'),
      );
    }
    
    return const SizedBox.shrink();
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange.shade800; // Dark orange for pending
      case OrderStatus.confirmed:
        return Colors.blue.shade800; // Dark blue for confirmed
      case OrderStatus.inProgress:
        return Colors.purple.shade800; // Dark purple for in progress
      case OrderStatus.completed:
        return Colors.green.shade800; // Dark green for completed
      case OrderStatus.cancelled:
        return Colors.red.shade800; // Dark red for cancelled
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}