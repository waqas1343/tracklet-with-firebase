import 'package:flutter/material.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../shared/widgets/section_header_widget.dart';
import '../widgets/delivery_summary_card.dart';
import '../widgets/delivery_card.dart';
import '../dashboard/distributor_request_dashboard.dart';

class DistributorDashboardScreen extends StatelessWidget {
  const DistributorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        userName: 'Distributor Dashboard',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Top App Bar with User Profile
          _buildTopAppBar(),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Summary Section
                  _buildDeliverySummarySection(),
                  const SizedBox(height: 24),

                  // Request Cylinders Button
                  _buildRequestCylindersButton(context),
                  const SizedBox(height: 24),

                  // Active Deliveries Section
                  _buildActiveDeliveriesSection(context),
                  const SizedBox(height: 24),

                  // Recent Deliveries Section
                  _buildRecentDeliveriesSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'Delivery Summary',
          onSeeAllPressed: () {
            // TODO: Navigate to see all deliveries
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DeliverySummaryCard(
                title: 'Active Deliveries',
                value: '12',
                icon: Icons.local_shipping,
                backgroundColor: const Color(0xFF1A2B4C),
                textColor: Colors.white,
                iconColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DeliverySummaryCard(
                title: 'Completed Today',
                value: '08',
                icon: Icons.check_circle,
                iconColor: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DeliverySummaryCard(
                title: 'Total Drivers',
                value: '15',
                icon: Icons.person,
                iconColor: const Color(0xFF1A2B4C),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequestCylindersButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DistributorRequestDashboard(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A2B4C), Color(0xFF2C4170)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A2B4C).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.propane_tank,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request Cylinders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Request gas cylinders from the plant',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveDeliveriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Active Deliveries',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A2B4C),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/distributor/orders');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'See all',
                  style: TextStyle(
                    color: Color(0xFF1A2B4C),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DeliveryCard(
          companyName: 'Tech Solutions',
          address: '123 Main Street, Downtown',
          deliveryTime: '2:30 PM',
          driverName: 'Ahmed Ali',
          status: 'In Transit',
          specialInstructions: 'Handle with care',
          onTap: () {
            // TODO: Handle delivery details
          },
        ),
        DeliveryCard(
          companyName: 'Green Energy Co.',
          address: '456 Business Ave, Uptown',
          deliveryTime: '4:15 PM',
          driverName: 'Saeed Khan',
          status: 'Out for Delivery',
          specialInstructions: 'Call before delivery',
          onTap: () {
            // TODO: Handle delivery details
          },
        ),
      ],
    );
  }

  Widget _buildRecentDeliveriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'Recent Deliveries',
          onSeeAllPressed: () {
            Navigator.pushNamed(context, '/distributor/orders');
          },
        ),
        const SizedBox(height: 16),
        DeliveryCard(
          companyName: 'Industrial Gas Ltd.',
          address: '789 Industrial Zone',
          deliveryTime: '11:30 AM',
          driverName: 'Romail Ahmed',
          status: 'Completed',
          specialInstructions: 'Delivered successfully',
          isCompleted: true,
          onTap: () {
            // TODO: Handle delivery details
          },
        ),
      ],
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // User Profile
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF1A2B4C),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'DA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Distributor Admin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          // Notifications
          IconButton(
            onPressed: () {
              // TODO: Handle notifications
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF333333),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
