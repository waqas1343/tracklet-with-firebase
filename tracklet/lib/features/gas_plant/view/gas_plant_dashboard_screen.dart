import 'package:flutter/material.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../shared/widgets/section_header_widget.dart';
import '../widgets/plant_summary_card.dart';
import '../widgets/completed_order_card.dart';
import '../widgets/new_order_card.dart';

class GasPlantDashboardScreen extends StatelessWidget {
  const GasPlantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showBackButton: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar with User Profile

              // Main Content
              _buildPlantSummarySection(context),
              const SizedBox(height: 24),

              _buildNewOrdersSection(),
              const SizedBox(height: 24),

              // Previous Orders Section
              _buildPreviousOrdersSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlantSummarySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'Plant Summary',
          onSeeAllPressed: () {
            // TODO: Navigate to see all summary
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PlantSummaryCard(
                title: 'Total Stock',
                value: '12.5 Tons',
                icon: Icons.local_drink,
                backgroundColor: const Color(0xFF1A2B4C),
                textColor: Colors.white,
                iconColor: Colors.white,
                onTap: () {
                  Navigator.pushNamed(context, '/gas-plant/total-stock');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PlantSummaryCard(
                title: 'Active Employees',
                value: '20',
                icon: Icons.person,
                iconColor: const Color(0xFF1A2B4C),
                onTap: () {
                  Navigator.pushNamed(context, '/gas-plant/active-employees');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PlantSummaryCard(
                title: 'Orders in progress',
                value: '07',
                icon: Icons.shopping_cart,
                iconColor: const Color(0xFF1A2B4C),
                onTap: () {
                  Navigator.pushNamed(context, '/gas-plant/orders-in-progress');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'New Orders',
          onSeeAllPressed: () {
            // TODO: Navigate to see all new orders
          },
        ),
        const SizedBox(height: 16),
        NewOrderCard(
          companyName: 'Arham Traders',
          description: 'Arham Traders placed a request for mentioned cylinders',
          time: '03:45 PM',
          date: '08-Oct-2025',
          specialInstructions:
              'Please deliver after 2 PM.Handle cylinders carefully.',
          requestedItems: ['45.4 KG (3)', '15 KG (5)'],
          totalWeight: '225 KG',
          customerImage: 'assets/images/customer.png',
          onApprovePressed: () {
            // TODO: Handle approve
          },
        ),
      ],
    );
  }

  Widget _buildPreviousOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'Previous Orders',
          onSeeAllPressed: () {
            // TODO: Navigate to see all previous orders
          },
        ),
        const SizedBox(height: 16),
        CompletedOrderCard(
          companyName: 'Arham Traders',
          time: '03:45 PM',
          date: '08-Oct-2025',
          driverName: 'Romail Ahmed',
          specialInstructions:
              'Please deliver after 2 PM.Handle cylinders carefully.',
          requestedItems: ['45.4 KG (3)', '15 KG (5)'],
          totalWeight: '225 KG',
        ),
      ],
    );
  }
}
