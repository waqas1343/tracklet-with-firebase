import 'package:flutter/material.dart';
import '../../../core/widgets/custom_appbar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showBackButton: false),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            // Header Section with User Profile and Title
            _buildHeaderSection(),

            // Tab Bar
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: Color(0xFF1A2B4C),
                unselectedLabelColor: Color(0xFF999999),
                indicatorColor: Color(0xFF1A2B4C),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 16),
                        SizedBox(width: 8),
                        Text('Completed'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hourglass_empty, size: 16),
                        SizedBox(width: 8),
                        Text('In Progress'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel, size: 16),
                        SizedBox(width: 8),
                        Text('Cancelled'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  _buildCompletedOrdersTab(),
                  _buildInProgressOrdersTab(),
                  _buildCancelledOrdersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Title and Download Button Row
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Orders History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              // Download Report Button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_download,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Download Report',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedOrdersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCompletedOrderCard(
            companyName: 'Arham Traders',
            time: '03:45 PM',
            date: '08-Oct-2025',
            driverName: 'Romail Ahmed',
            specialInstructions:
                'Please deliver after 2 PM.Handle cylinders carefully.',
            requestedItems: ['45.4 KG (3)', '15 KG (5)'],
            totalWeight: '225 KG',
          ),
          _buildCompletedOrderCard(
            companyName: 'Tech Solutions',
            time: '02:30 PM',
            date: '08-Oct-2025',
            driverName: 'Ahmed Ali',
            specialInstructions: 'Deliver during business hours only.',
            requestedItems: ['45.4 KG (2)', '15 KG (3)'],
            totalWeight: '150 KG',
          ),
          _buildCompletedOrderCard(
            companyName: 'Green Energy Co.',
            time: '01:15 PM',
            date: '08-Oct-2025',
            driverName: 'Saeed Khan',
            specialInstructions: 'Handle with care',
            requestedItems: ['45.4 KG (4)', '15 KG (2)'],
            totalWeight: '200 KG',
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressOrdersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInProgressOrderCard(
            companyName: 'Arham Traders',
            time: '03:45 PM',
            date: '08-Oct-2025',
            driverName: 'Ahmed Khan',
            specialInstructions:
                'Please deliver after 2 PM. Handle cylinders carefully.',
            requestedItems: ['45.4 KG (3)', '15 KG (5)'],
            totalWeight: '225 KG',
          ),
          _buildInProgressOrderCard(
            companyName: 'ABC Logistics',
            time: '02:00 PM',
            date: '08-Oct-2025',
            driverName: 'Sara Ali',
            specialInstructions: 'Urgent delivery required.',
            requestedItems: ['45.4 KG (2)', '15 KG (10)'],
            totalWeight: '230 KG',
          ),
          _buildInProgressOrderCard(
            companyName: 'XYZ Corp',
            time: '10:00 AM',
            date: '08-Oct-2025',
            driverName: 'Hassan Ahmed',
            specialInstructions: 'Deliver to warehouse gate 3.',
            requestedItems: ['45.4 KG (5)'],
            totalWeight: '227 KG',
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledOrdersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCancelledOrderCard(
            companyName: 'Industrial Gas Ltd.',
            time: '10:30 AM',
            date: '07-Oct-2025',
            specialInstructions: 'Customer cancelled due to delay',
            requestedItems: ['45.4 KG (5)', '15 KG (3)'],
            totalWeight: '300 KG',
          ),
          _buildCancelledOrderCard(
            companyName: 'Energy Solutions',
            time: '09:15 AM',
            date: '06-Oct-2025',
            specialInstructions: 'Payment issue - order cancelled',
            requestedItems: ['45.4 KG (2)', '15 KG (4)'],
            totalWeight: '180 KG',
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressOrderCard({
    required String companyName,
    required String time,
    required String date,
    required String driverName,
    required String specialInstructions,
    required List<String> requestedItems,
    required String totalWeight,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Name and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  companyName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'In Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time and Date
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Container(width: 1, height: 14, color: Colors.grey[300]),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                date,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Driver Name
          Text(
            'Driver Name: $driverName',
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 12),

          // Special Instructions
          const Text(
            'Special Instructions:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            specialInstructions,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 12),

          // Requested Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Requested Items',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              Row(
                children: requestedItems
                    .map((item) => _buildItemTag(item))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Total Weight
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Kg:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                totalWeight,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedOrderCard({
    required String companyName,
    required String time,
    required String date,
    required String driverName,
    required String specialInstructions,
    required List<String> requestedItems,
    required String totalWeight,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Name and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  companyName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time and Date
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Container(width: 1, height: 14, color: Colors.grey[300]),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                date,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Driver Name
          Text(
            'Driver Name: $driverName',
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 12),

          // Special Instructions
          const Text(
            'Special Instructions:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            specialInstructions,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 12),

          // Requested Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Requested Items',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              Row(
                children: requestedItems
                    .map((item) => _buildItemTag(item))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Total Weight
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Kg:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                totalWeight,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledOrderCard({
    required String companyName,
    required String time,
    required String date,
    required String specialInstructions,
    required List<String> requestedItems,
    required String totalWeight,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Name and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  companyName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF44336),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Cancelled',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time and Date
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Container(width: 1, height: 14, color: Colors.grey[300]),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                date,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Special Instructions
          const Text(
            'Special Instructions:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            specialInstructions,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 12),

          // Requested Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Requested Items',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              Row(
                children: requestedItems
                    .map((item) => _buildItemTag(item))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Total Weight
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Kg:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                totalWeight,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemTag(String item) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2, size: 12, color: Colors.white),
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
}
