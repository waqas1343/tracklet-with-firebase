import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_text_theme.dart';

/// CompletedOrderCard: Reusable card for completed orders
///
/// Displays completed order information with exact design from image
class CompletedOrderCard extends StatelessWidget {
  final String companyName;
  final String time;
  final String date;
  final String driverName;
  final String specialInstructions;
  final List<String> requestedItems;
  final String totalWeight;
  final VoidCallback? onTap;

  const CompletedOrderCard({
    super.key,
    required this.companyName,
    required this.time,
    required this.date,
    required this.driverName,
    required this.specialInstructions,
    required this.requestedItems,
    required this.totalWeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardPadding = screenWidth * 0.04; // 4% of screen width

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: screenWidth * 0.04),
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with company name and completed status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(companyName, style: AppTextTheme.cardTitle),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.completed,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Completed',
                    style: AppTextTheme.statusText,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.02),

            // Time and date row
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
                SizedBox(width: screenWidth * 0.01),
                Text(time, style: AppTextTheme.cardTime),
                SizedBox(width: screenWidth * 0.04),
                Container(width: 1, height: 14, color: AppColors.border),
                SizedBox(width: screenWidth * 0.04),
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
                SizedBox(width: screenWidth * 0.01),
                Text(date, style: AppTextTheme.cardTime),
              ],
            ),
            SizedBox(height: screenWidth * 0.02),

            // Driver name
            Text('Driver Name: $driverName', style: AppTextTheme.bodyMedium),
            SizedBox(height: screenWidth * 0.02),

            // Special instructions
            Text('Special Instructions:', style: AppTextTheme.cardLabel),
            SizedBox(height: screenWidth * 0.01),
            Text(specialInstructions, style: AppTextTheme.cardSubtitle),
            SizedBox(height: screenWidth * 0.03),

            // Requested items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Requested Items', style: AppTextTheme.cardLabel),
                SizedBox(height: screenWidth * 0.01),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: requestedItems
                      .map((item) => _buildItemTag(item, screenWidth))
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.02),

            // Total weight
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Kg:', style: AppTextTheme.cardLabel),
                Text(totalWeight, style: AppTextTheme.cardValue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTag(String item, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(left: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenWidth * 0.015,
      ),
      decoration: BoxDecoration(
        color: AppColors.tagBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2, size: 12, color: AppColors.tagText),
          SizedBox(width: screenWidth * 0.01),
          Text(item, style: AppTextTheme.tagText),
        ],
      ),
    );
  }
}
