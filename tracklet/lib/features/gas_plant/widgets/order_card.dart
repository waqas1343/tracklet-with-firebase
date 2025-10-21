import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_button.dart';

/// OrderCard: Reusable card for displaying order information
///
/// Shows order details with company name, description, items, and actions
class OrderCard extends StatelessWidget {
  final String companyName;
  final String description;
  final String time;
  final String date;
  final String specialInstructions;
  final List<String> requestedItems;
  final String totalWeight;
  final String? status;
  final String? driverName;
  final String? customerImage;
  final List<OrderAction>? actions;
  final bool isNewOrder;

  const OrderCard({
    super.key,
    required this.companyName,
    required this.description,
    required this.time,
    required this.date,
    required this.specialInstructions,
    required this.requestedItems,
    required this.totalWeight,
    this.status,
    this.driverName,
    this.customerImage,
    this.actions,
    this.isNewOrder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with company name and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  companyName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              if (status != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 8),

          // Time and date
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                date,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Driver name (for previous orders)
          if (driverName != null) ...[
            Text(
              'Driver Name: $driverName',
              style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 8),
          ],

          // Special instructions
          Text(
            'Special Instructions:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            specialInstructions,
            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 12),

          // Requested items
          Text(
            'Requested Items',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: requestedItems
                .map((item) => _buildItemTag(item))
                .toList(),
          ),
          const SizedBox(height: 12),

          // Total weight
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Kg:',
                style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
              ),
              Text(
                totalWeight,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),

          // Actions (for new orders)
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: actions!
                  .map((action) => _buildActionButton(action))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemTag(String item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            item,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(OrderAction action) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: CustomButton(
          text: action.text,
          onPressed: action.onPressed,
          backgroundColor: action.isPrimary
              ? const Color(0xFF1A2B4C)
              : Colors.white,
          textColor: action.isPrimary ? Colors.white : const Color(0xFF1A2B4C),
          borderColor: const Color(0xFF1A2B4C),
          height: 40,
          borderRadius: 8,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class OrderAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const OrderAction({
    required this.text,
    this.onPressed,
    this.isPrimary = false,
  });
}
