import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_text_theme.dart';
import '../../../shared/widgets/custom_button.dart';

/// NewOrderCard: Reusable card for new orders with dark theme
///
/// Displays new order information with exact design from image
class NewOrderCard extends StatelessWidget {
  final String companyName;
  final String description;
  final String time;
  final String date;
  final String specialInstructions;
  final List<String> requestedItems;
  final String totalWeight;
  final String? customerImage;
  final VoidCallback? onApprovePressed;
  final VoidCallback? onTap;

  const NewOrderCard({
    super.key,
    required this.companyName,
    required this.description,
    required this.time,
    required this.date,
    required this.specialInstructions,
    required this.requestedItems,
    required this.totalWeight,
    this.customerImage,
    this.onApprovePressed,
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
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDark, width: 1),
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
            // Header with company name and customer image
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName,
                        style: AppTextTheme.cardTitle.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.01),
                      Text(
                        description,
                        style: AppTextTheme.cardSubtitle.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                    ],
                  ),
                ),
                if (customerImage != null)
                  CircleAvatar(
                    radius: screenWidth * 0.06,
                    // Fallback to a colored circle if image fails to load
                    backgroundImage: AssetImage(customerImage!),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: screenWidth * 0.06,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: screenWidth * 0.02),

            // Time and date row
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: AppColors.secondary),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  time,
                  style: AppTextTheme.cardTime.copyWith(
                    color: AppColors.background,
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppColors.secondary,
                ),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  date,
                  style: AppTextTheme.cardTime.copyWith(
                    color: AppColors.background,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.03),

            // Special instructions
            Text(
              'Special Instructions:',
              style: AppTextTheme.cardLabel.copyWith(
                color: AppColors.background,
              ),
            ),
            SizedBox(height: screenWidth * 0.01),
            Text(
              specialInstructions,
              style: AppTextTheme.cardSubtitle.copyWith(
                color: AppColors.background,
              ),
            ),
            SizedBox(height: screenWidth * 0.03),

            // Requested items
            Text(
              'Requested Items',
              style: AppTextTheme.cardLabel.copyWith(
                color: AppColors.background,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Row(
              children: requestedItems
                  .map((item) => _buildItemTag(item, screenWidth))
                  .toList(),
            ),
            SizedBox(height: screenWidth * 0.03),

            // Total weight and approve button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Kg: $totalWeight',
                  style: AppTextTheme.cardValue.copyWith(
                    color: AppColors.background,
                  ),
                ),
                CustomButton(
                  text: 'Approve',
                  onPressed: onApprovePressed,
                  backgroundColor: AppColors.buttonPrimary,
                  textColor: AppColors.buttonText,
                  height: 36,
                  borderRadius: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTag(String item, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.02),
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