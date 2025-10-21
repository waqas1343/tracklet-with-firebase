import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_appbar.dart';

class ManagePlantScreen extends StatelessWidget {
  const ManagePlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        userName: 'Manage Plant',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plant Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Manage your gas plant settings and configurations here.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 24),
            // Add your plant management options here
            _buildManagementOption(
              context,
              title: 'Plant Information',
              subtitle: 'Update plant details and contact information',
              icon: Icons.info,
            ),
            _buildManagementOption(
              context,
              title: 'Staff Management',
              subtitle: 'Add, remove, or update staff members',
              icon: Icons.people,
            ),
            _buildManagementOption(
              context,
              title: 'Equipment',
              subtitle: 'Manage plant equipment and maintenance',
              icon: Icons.build,
            ),
            _buildManagementOption(
              context,
              title: 'Production Settings',
              subtitle: 'Configure production parameters',
              icon: Icons.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF1A2B4C),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF333333),
        ),
        onTap: () {
          // TODO: Handle specific management option
        },
      ),
    );
  }
}