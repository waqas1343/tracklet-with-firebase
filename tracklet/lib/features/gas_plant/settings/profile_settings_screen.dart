import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/utils/app_text_theme.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/constants.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.currentUser;
    final isLoading = profileProvider.isLoading;
    final error = profileProvider.error;

    // Initialize controllers with current data
    final fullNameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final contactController = TextEditingController(text: user?.phone ?? '');
    final formKey = GlobalKey<FormState>();

    // Initialize profile if not already loaded
    if (user == null && !isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        profileProvider.initializeProfile();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        userName: 'Gas Plant Admin',
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
                // Edit Profile Title
                Text('Edit Profile', style: AppTextTheme.displaySmall),
                const SizedBox(height: 24),

                // Error Message
                if (error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            error,
                            style: AppTextTheme.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Profile Picture Section
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user?.name.isNotEmpty == true
                                ? user!.name.substring(0, 1).toUpperCase()
                                : 'U',
                            style: AppTextTheme.displayMedium.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // User Name Display
                Center(
                  child: Text(
                    user?.name ?? 'Loading...',
                    style: AppTextTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 32),

                // Form Fields
                CustomTextField(
                  label: AppConstants.nameLabel,
                  controller: fullNameController,
                  hint: 'Enter Full Name',
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: AppConstants.emailLabel,
                  controller: emailController,
                  hint: 'Enter Email Address',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: AppConstants.phoneLabel,
                  controller: contactController,
                  hint: 'Enter Contact Number',
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 32),

                // Save Changes Button
                CustomButton(
                  text: isLoading ? 'Saving...' : AppConstants.saveButton,
                  onPressed: isLoading
                      ? null
                      : () => _saveProfile(
                          context,
                          formKey,
                          fullNameController,
                          emailController,
                          contactController,
                        ),
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

  /// Save profile changes
  Future<void> _saveProfile(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController fullNameController,
    TextEditingController emailController,
    TextEditingController contactController,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    // Ensure profile is initialized before updating
    if (profileProvider.currentUser == null) {
      await profileProvider.initializeProfile();
    }

    final success = await profileProvider.updateProfile(
      name: fullNameController.text.trim(),
      email: emailController.text.trim(),
      phone: contactController.text.trim(),
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppConstants.updateSuccess,
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
            profileProvider.error ?? 'Failed to update profile',
            style: AppTextTheme.bodyMedium.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.error,
          duration: AppConstants.snackbarDuration,
        ),
      );
    }
  }
}
