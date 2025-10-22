import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/profile_provider.dart';
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
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlantSummarySection(context),
              const SizedBox(height: 14),
                            _buildNewOrdersSection(context),
              const SizedBox(height: 24),

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
          },
        ),
        Row(
          children: [
            Expanded(
              child: PlantSummaryCard(
                title: 'Total',
                subtitle: "card",
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
                title: 'Active',
                subtitle: "Employees",   
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
                title: 'Orders',  
                subtitle: "in progress",

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

  Widget _buildNewOrdersSection(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.currentUser;

    if (user != null &&
        !orderProvider.isLoading &&
        orderProvider.newOrders.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProvider.loadOrdersForPlant(user.id);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'New Orders',
          onSeeAllPressed: () {
            Navigator.pushNamed(context, '/gas-plant/new-orders');
          },
        ),
        const SizedBox(height: 16),
        if (user == null)
          const Center(child: Text('User not logged in'))
        else if (orderProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (orderProvider.newOrders.isEmpty)
          const Center(child: Text('No new orders'))
        else ...orderProvider.newOrders.take(3).map((order) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: NewOrderCard(
                companyName: order.distributorName,
                description: '${order.distributorName} placed a request for mentioned cylinders',
                time: _formatTime(order.createdAt),
                date: _formatDate(order.createdAt),
                specialInstructions: order.specialInstructions ?? '',
                requestedItems: order.formattedQuantities,
                totalWeight: '${order.totalKg.toInt()} KG',
                customerImage: 'assets/images/customer.png',
                onApprovePressed: () {                },
              ),
            )),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dateTime.day}-${months[dateTime.month - 1]}-${dateTime.year}';
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
