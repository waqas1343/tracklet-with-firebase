import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_text_theme.dart';

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
  final VoidCallback? onCancelPressed;
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
    this.onCancelPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardPadding = screenWidth * 0.04;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: screenWidth * 0.04),
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDark, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header Row
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
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.01),
                      Text(
                        description,
                        style: AppTextTheme.cardSubtitle.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                if (customerImage != null)
                  CircleAvatar(
                    radius: screenWidth * 0.06,
                    backgroundColor: AppColors.background,
                    child: Icon(
                      Icons.person,
                      color: AppColors.black,
                    ),
                  ),

              ],
            ),
            SizedBox(height: screenWidth * 0.02),

            // 🔹 Time & Date Row
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: AppColors.secondary),
                SizedBox(width: screenWidth * 0.01),
                Text(time, style: AppTextTheme.cardTime.copyWith(color: AppColors.black)),
                SizedBox(width: screenWidth * 0.04),
                Icon(Icons.calendar_today, size: 14, color: AppColors.secondary),
                SizedBox(width: screenWidth * 0.01),
                Text(date, style: AppTextTheme.cardTime.copyWith(color: AppColors.black)),
              ],
            ),
            SizedBox(height: screenWidth * 0.03),

            // 🔹 Special Instructions
            Text('Special Instructions:', style: AppTextTheme.cardLabel.copyWith(color: AppColors.black)),
            SizedBox(height: screenWidth * 0.01),
            Text(specialInstructions, style: AppTextTheme.cardSubtitle.copyWith(color: AppColors.black)),
            SizedBox(height: screenWidth * 0.03),

            // 🔹 Requested Items (Wrap widget added)
            Text('Requested Items', style: AppTextTheme.cardLabel.copyWith(color: AppColors.black)),
            SizedBox(height: screenWidth * 0.02),
            Wrap(
              spacing: screenWidth * 0.02,
              runSpacing: screenWidth * 0.02,
              children: requestedItems.map((item) => _buildItemTag(item, screenWidth)).toList(),
            ),
            SizedBox(height: screenWidth * 0.03),

            // 🔹 Total weight
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Kg:', style: AppTextTheme.cardValue.copyWith(color: AppColors.black)),
                Text(totalWeight, style: AppTextTheme.cardValue.copyWith(color: AppColors.black)),
              ],
            ),
            SizedBox(height: screenWidth * 0.04),

            // 🔹 Container Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button
                Expanded(
                  child: GestureDetector(
                    onTap: onCancelPressed,
                    child: Container(
                      height: 44,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Approve Button
                Expanded(
                  child: GestureDetector(
                    onTap: onApprovePressed,
                    child: Container(
                      height: 44,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: AppColors.buttonPrimary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          'Approve',
                          style: TextStyle(
                            color: AppColors.buttonText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Tag Widget with circular icon background
  Widget _buildItemTag(String item, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenWidth * 0.02,
      ),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item,
            style: AppTextTheme.tagText.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: screenWidth * 0.015),
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.inventory_2,
                size: 14,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
