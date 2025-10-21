import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/company_provider.dart';
import '../../../../core/models/company_model.dart';
import '../../../../core/utils/app_text_theme.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/constants.dart';

class ManagePlantScreen extends StatefulWidget {
  const ManagePlantScreen({super.key});

  @override
  State<ManagePlantScreen> createState() => _ManagePlantScreenState();
}

class _ManagePlantScreenState extends State<ManagePlantScreen> {
  late TextEditingController plantNameController;
  late TextEditingController contactController;
  late TextEditingController addressController;
  late TextEditingController operatingHoursController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    plantNameController = TextEditingController();
    contactController = TextEditingController();
    addressController = TextEditingController();
    operatingHoursController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    plantNameController.dispose();
    contactController.dispose();
    addressController.dispose();
    operatingHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.currentUser;
    final isLoading = profileProvider.isLoading;

    // Update controllers with current data
    if (user != null) {
      plantNameController.text = user.companyName ?? '';
      contactController.text = user.phone;
      addressController.text = user.address ?? '';
      operatingHoursController.text =
          user.operatingHours ?? '8:00 AM - 6:00 PM';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        userName: 'Manage Plant',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plant Information Title
                Text('Plant Information', style: AppTextTheme.displaySmall),
                const SizedBox(height: 24),

                // Plant Image Upload Section
                _buildImageUploadSection(),

                const SizedBox(height: 24),

                // Form Fields
                CustomTextField(
                  label: 'Plant Name',
                  controller: plantNameController,
                  hint: 'Enter Plant Name',
                  validator: (value) =>
                      Validators.validateRequired(value, 'Plant Name'),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Contact Number',
                  controller: contactController,
                  hint: 'Enter Contact Number',
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Address',
                  controller: addressController,
                  hint: 'Enter Address',
                  maxLines: 3,
                  validator: (value) =>
                      Validators.validateRequired(value, 'Address'),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Operating Hours',
                  controller: operatingHoursController,
                  hint: 'Enter Operating Hours',
                  validator: (value) =>
                      Validators.validateRequired(value, 'Operating Hours'),
                ),
                const SizedBox(height: 32),

                // Save Changes Button
                CustomButton(
                  text: isLoading ? 'Saving...' : 'Save Changes',
                  onPressed: isLoading ? null : _savePlantInfo,
                  width: double.infinity,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                  height: 50,
                  borderRadius: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Plant Image:', style: AppTextTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.landscape, size: 64, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Upload Plant Image',
                style: AppTextTheme.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add a logo or image to help identify your plant easily.',
                style: AppTextTheme.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Save plant information
  Future<void> _savePlantInfo() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    final companyProvider = Provider.of<CompanyProvider>(
      context,
      listen: false,
    );

    // Ensure profile is initialized before updating
    if (profileProvider.currentUser == null) {
      await profileProvider.initializeProfile();
    }

    // Update user profile
    final success = await profileProvider.updateProfile(
      name: profileProvider.currentUser?.name, // Keep existing name
      email: profileProvider.currentUser?.email, // Keep existing email
      phone: contactController.text.trim(),
      companyName: plantNameController.text.trim(),
      address: addressController.text.trim(),
      operatingHours: operatingHoursController.text.trim(),
    );

    if (success) {
      // Also save to company collection for distributor app
      final currentUser = profileProvider.currentUser;
      if (currentUser != null) {
        final company = CompanyModel(
          id: currentUser.id, // Use user ID as company ID
          companyName: plantNameController.text.trim(),
          contactNumber: contactController.text.trim(),
          address: addressController.text.trim(),
          operatingHours: operatingHoursController.text.trim(),
          ownerId: currentUser.id,
          createdAt: currentUser.createdAt,
          updatedAt: DateTime.now(),
        );

        await companyProvider.saveCompany(company);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Plant information updated successfully!',
            style: AppTextTheme.bodyMedium.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.success,
          duration: AppConstants.snackbarDuration,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            profileProvider.error ?? 'Failed to update plant information',
            style: AppTextTheme.bodyMedium.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.error,
          duration: AppConstants.snackbarDuration,
        ),
      );
    }
  }
}
