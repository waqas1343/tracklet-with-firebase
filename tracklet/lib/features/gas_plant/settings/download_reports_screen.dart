import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_appbar.dart';

class DownloadReportsScreen extends StatelessWidget {
  const DownloadReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Reports', showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Download Reports Title
              const Text(
                'Download Reports',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 24),

              // Report Options
              _buildReportCard('Orders Report'),
              _buildReportCard('Attendance Report'),
              _buildReportCard('Monthly Expense Report'),
              _buildReportCard('Generator Expense Report'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(String reportName) {
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
        title: Text(
          reportName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF666666),
          size: 20,
        ),
        onTap: () {
          // TODO: Handle report download
        },
      ),
    );
  }
}
