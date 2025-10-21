import 'package:flutter/material.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_button.dart';

class DriversScreen extends StatelessWidget {
  const DriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar( showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            _buildSummaryCards(),
            const SizedBox(height: 24),

            // Active Drivers
            _buildActiveDriversSection(),
            const SizedBox(height: 24),

            // Add Driver Button
            CustomButton(
              text: 'Add New Driver',
              onPressed: () {
                // TODO: Handle add driver
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
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Drivers',
            '15',
            Icons.person,
            const Color(0xFF1A2B4C),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Active Today',
            '12',
            Icons.person_pin,
            const Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
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
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveDriversSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Drivers',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        _buildDriverCard(
          'Ahmed Ali',
          'In Transit',
          '2 deliveries',
          Icons.local_shipping,
        ),
        _buildDriverCard(
          'Saeed Khan',
          'Available',
          '0 deliveries',
          Icons.check_circle,
        ),
        _buildDriverCard(
          'Romail Ahmed',
          'On Break',
          '1 delivery',
          Icons.pause_circle,
        ),
        _buildDriverCard(
          'Ali Hassan',
          'Available',
          '0 deliveries',
          Icons.check_circle,
        ),
      ],
    );
  }

  Widget _buildDriverCard(
    String name,
    String status,
    String deliveries,
    IconData statusIcon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFF1A2B4C),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.split(' ').map((n) => n[0]).join(''),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(statusIcon, size: 16, color: _getStatusColor(status)),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 14,
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  deliveries,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Handle driver details
            },
            icon: const Icon(Icons.more_vert, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in transit':
        return Colors.orange;
      case 'available':
        return Colors.green;
      case 'on break':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
