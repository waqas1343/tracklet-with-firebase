import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/company_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/utils/app_text_theme.dart';
import '../../../core/utils/app_colors.dart';

class DistributorDashboardScreen extends StatelessWidget {
  const DistributorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context);
    final companyProvider = Provider.of<CompanyProvider>(context);

    // Load companies when screen builds
    if (!companyProvider.isLoading && companyProvider.companies.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        companyProvider.loadAllCompanies();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        showBackButton: false,
        showNotificationIcon: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              _buildSearchBar(),
              const SizedBox(height: 24),

              // Top Plants Section
              _buildTopPlantsSection(context),
              const SizedBox(height: 24),

              // Previous Orders Section
              _buildPreviousOrdersSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Builder(
        builder: (context) {
          final companyProvider = Provider.of<CompanyProvider>(
            context,
            listen: false,
          );
          return TextField(
            onChanged: (value) {
              companyProvider.searchCompanies(value);
            },
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopPlantsSection(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    final topPlants = companyProvider.topPlants;
    final isLoading = companyProvider.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Top Plants', style: AppTextTheme.displaySmall),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to see all plants
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'See all',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : topPlants.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.business_outlined,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No plants available',
                        style: AppTextTheme.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topPlants.length,
                  itemBuilder: (context, index) {
                    return _buildPlantCard(context, topPlants[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPlantCard(BuildContext context, company) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plant Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: Colors.grey.shade200,
            ),
            child: company.imageUrl != null && company.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      company.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.landscape,
                          size: 48,
                          color: AppColors.primary,
                        );
                      },
                    ),
                  )
                : Icon(Icons.landscape, size: 48, color: AppColors.primary),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.companyName,
                  style: AppTextTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  company.address,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  company.operatingHours,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Request Cylinder',
                  onPressed: () =>
                      _requestCylinder(context, company.companyName),
                  width: double.infinity,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                  height: 36,
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousOrdersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Previous Orders', style: AppTextTheme.displaySmall),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to see all orders
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'See all',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildOrderCard(
          context,
          plantName: 'Tracklet.CO Gas Plant',
          status: 'In Progress',
          statusColor: Colors.orange,
          driverName: 'Romail Ahmed',
          specialInstructions:
              'Please deliver after 2 PM. Handle cylinders carefully.',
          requestedItems: ['45.4 KG (3)', '15 KG (5)'],
          totalWeight: '225 KG',
        ),
        const SizedBox(height: 12),
        _buildOrderCard(
          context,
          plantName: 'Arham Traders',
          status: 'Completed',
          statusColor: Colors.green,
          driverName: 'Romail Ahmed',
          requestedItems: ['45.4 KG (3)', '15 KG (5)'],
        ),
        const SizedBox(height: 12),
        _buildOrderCard(
          context,
          plantName: 'Arham Traders',
          status: 'Cancel',
          statusColor: Colors.red,
          driverName: 'Romail Ahmed',
        ),
      ],
    );
  }

  Widget _buildOrderCard(
    BuildContext context, {
    required String plantName,
    required String status,
    required Color statusColor,
    required String driverName,
    String? specialInstructions,
    List<String>? requestedItems,
    String? totalWeight,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(plantName, style: AppTextTheme.titleMedium)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Driver Name: $driverName',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (specialInstructions != null) ...[
            const SizedBox(height: 4),
            Text(
              'Special Instructions: $specialInstructions',
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (requestedItems != null) ...[
            const SizedBox(height: 8),
            Text(
              'Requested Items',
              style: AppTextTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: requestedItems.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item,
                    style: AppTextTheme.bodySmall.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (totalWeight != null) ...[
            const SizedBox(height: 8),
            Text(
              'Total Kg: $totalWeight',
              style: AppTextTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _requestCylinder(BuildContext context, String plantName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request Cylinder'),
          content: Text('Request cylinder from $plantName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cylinder request sent to $plantName'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: Text('Request'),
            ),
          ],
        );
      },
    );
  }
}
