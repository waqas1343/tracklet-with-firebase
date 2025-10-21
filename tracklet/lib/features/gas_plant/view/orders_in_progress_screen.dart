import 'package:flutter/material.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/in_progress_order_card.dart';

class OrdersInProgressScreen extends StatelessWidget {
  const OrdersInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
   
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Overview Card
              _buildProgressOverviewCard(),
              const SizedBox(height: 24),

              // In Progress Orders
              _buildInProgressOrdersSection(),
              const SizedBox(height: 24),

              // Update Progress Button
              CustomButton(
                text: 'Update Progress',
                onPressed: () {
                  // TODO: Handle update progress
                  // Update progress functionality
                },
                width: double.infinity,
                backgroundColor: const Color(0xFF1A2B4C),
                textColor: Colors.white,
                height: 50,
                borderRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B4C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Orders in Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '07',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Last updated: 08-Oct-2025',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Orders',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        InProgressOrderCard(
          companyName: 'Arham Traders',
          time: '03:45 PM',
          date: '08-Oct-2025',
          driverName: 'Ahmed Khan',
          specialInstructions:
              'Please deliver after 2 PM. Handle cylinders carefully.',
          requestedItems: ['45.4 KG (3)', '15 KG (5)'],
          totalWeight: '225 KG',
          onCancelPressed: () {
            // TODO: Handle cancel order
            // Cancel order functionality
          },
          onCompletePressed: () {
            // TODO: Handle complete order
            // Complete order functionality
          },
        ),
        InProgressOrderCard(
          companyName: 'ABC Logistics',
          time: '02:00 PM',
          date: '08-Oct-2025',
          driverName: 'Sara Ali',
          specialInstructions: 'Urgent delivery required.',
          requestedItems: ['45.4 KG (2)', '15 KG (10)'],
          totalWeight: '230 KG',
          onCancelPressed: () {
            // TODO: Handle cancel order
            // Cancel order functionality
          },
          onCompletePressed: () {
            // TODO: Handle complete order
            // Complete order functionality
          },
        ),
        InProgressOrderCard(
          companyName: 'XYZ Corp',
          time: '10:00 AM',
          date: '08-Oct-2025',
          driverName: 'Hassan Ahmed',
          specialInstructions: 'Deliver to warehouse gate 3.',
          requestedItems: ['45.4 KG (5)'],
          totalWeight: '227 KG',
          onCancelPressed: () {
            // TODO: Handle cancel order
            // Cancel order functionality
          },
          onCompletePressed: () {
            // TODO: Handle complete order
            // Complete order functionality
          },
        ),
      ],
    );
  }
}
