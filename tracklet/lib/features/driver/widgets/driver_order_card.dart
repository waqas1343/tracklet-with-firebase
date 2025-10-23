import 'package:flutter/material.dart';
import '../../../core/models/order_model.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_text_theme.dart';

class DriverOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onCompletePressed;
  final VoidCallback onTap;

  const DriverOrderCard({
    super.key,
    required this.order,
    this.onCompletePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with order info and status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id.substring(0, 8)}',
                          style: AppTextTheme.titleLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'From: ${order.distributorName}',
                          style: AppTextTheme.bodyMedium.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'To: ${order.plantName}',
                          style: AppTextTheme.bodyMedium.copyWith(
                            color: Colors.grey[600],
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
                      color: _getStatusColor(order.status).withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(order.status),
                        width: 1,
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
              const SizedBox(height: 16),

              // Order details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Details',
                      style: AppTextTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            'Total Weight',
                            '${order.totalKg.toInt()} KG',
                            Icons.scale,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            'Items',
                            '${order.quantities.length} types',
                            Icons.inventory,
                          ),
                        ),
                      ],
                    ),
                    if (order.specialInstructions != null &&
                        order.specialInstructions!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Special Instructions:',
                        style: AppTextTheme.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.specialInstructions!,
                        style: AppTextTheme.bodySmall.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Requested items
              if (order.formattedQuantities.isNotEmpty) ...[
                Text(
                  'Requested Items:',
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                ...order.formattedQuantities.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $item',
                      style: AppTextTheme.bodySmall.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Action buttons - only show if onCompletePressed is provided
              if (onCompletePressed != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onCompletePressed,
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text('Mark Complete'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Show status info instead of action button
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withAlpha((0.3 * 255).round())),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Order assigned to you. Gas Plant will mark it complete.',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextTheme.bodySmall.copyWith(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: AppTextTheme.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
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
