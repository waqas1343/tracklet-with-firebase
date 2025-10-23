import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/driver_model.dart';
import '../../../core/models/order_model.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../../../shared/widgets/status_chip.dart';

class DriverDetailsScreen extends StatefulWidget {
  final DriverModel driver;

  const DriverDetailsScreen({super.key, required this.driver});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  String _selectedTab = 'In progress';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Driver Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Driver Information Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Driver Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(widget.driver.name),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Driver Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.driver.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.driver.phone,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () => _makePhoneCall(widget.driver.phone),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.message,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () => _sendMessage(widget.driver.phone),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status Tabs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTab(
                      'In progress',
                      _selectedTab == 'In progress',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTab('Completed', _selectedTab == 'Completed'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Orders List
            Expanded(
              child: Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {
                  // Load orders for this driver
                  if (orderProvider.orders.isEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      orderProvider.loadOrdersForDriver(widget.driver.name);
                    });
                  }

                  final driverOrders = orderProvider.orders
                      .where((order) => order.driverName == widget.driver.name)
                      .toList();

                  final filteredOrders = _selectedTab == 'In progress'
                      ? driverOrders
                            .where(
                              (order) => order.status == OrderStatus.inProgress,
                            )
                            .toList()
                      : driverOrders
                            .where(
                              (order) => order.status == OrderStatus.completed,
                            )
                            .toList();

                  if (filteredOrders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _selectedTab == 'In progress'
                                ? Icons.local_shipping_outlined
                                : Icons.check_circle_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedTab == 'In progress'
                                ? 'No orders in progress'
                                : 'No completed orders',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _buildOrderCard(order);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header with plant name and status
          Row(
            children: [
              Expanded(
                child: Text(
                  order.plantName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              StatusChip(
                status: order.statusText,
                statusType: _mapOrderStatusToStatusType(order.status),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Time and Date
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatTime(order.createdAt),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatDate(order.createdAt),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Driver Name
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              children: [
                const TextSpan(text: 'Driver Name: '),
                TextSpan(
                  text: widget.driver.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Special Instructions
          if (order.specialInstructions != null &&
              order.specialInstructions!.isNotEmpty) ...[
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  const TextSpan(
                    text: 'Special Instructions: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: order.specialInstructions!),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Location
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              children: [
                const TextSpan(
                  text: 'Location: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: 'Plot #45, Industrial Area, Lahore, Pakistan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Requested Items
          const Text(
            'Requested Items',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          // Item tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: order.formattedQuantities.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Total Weight
          Row(
            children: [
              const Text(
                'Total Kg: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '${order.totalKg.toInt()} KG',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dateTime.day}-${months[dateTime.month - 1]}-${dateTime.year}';
  }


  StatusType _mapOrderStatusToStatusType(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return StatusType.pending;
      case OrderStatus.confirmed:
        return StatusType.confirmed;
      case OrderStatus.inProgress:
        return StatusType.inProgress;
      case OrderStatus.completed:
        return StatusType.completed;
      case OrderStatus.cancelled:
        return StatusType.cancelled;
    }
  }

  void _makePhoneCall(String phoneNumber) {
    // Implement phone call functionality

  }

  void _sendMessage(String phoneNumber) {
    // Implement message functionality

  }
}
