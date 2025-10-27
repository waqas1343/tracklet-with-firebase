// Modern Super Admin Login Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';
import '../providers/theme_provider.dart';
import '../shared/widgets/custom_button.dart';
import '../shared/widgets/custom_text_field.dart';

class ModernLoginScreen extends StatelessWidget {
  const ModernLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: theme.modernBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(theme.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              // Modern Logo/Title
              Container(
                padding: EdgeInsets.all(theme.spacingLg),
                decoration: BoxDecoration(
                  gradient: theme.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: theme.shadowLevel3,
                ),
                child: Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Super Admin Portal',
                style: theme.displaySmall.copyWith(
                  color: theme.modernTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tracklet Management System',
                style: theme.bodyLarge.copyWith(
                  color: theme.modernTextSecondary,
                ),
              ),
              const SizedBox(height: 48),

              Form(
                key: loginProvider.formKey,
                child: Column(
                  children: [
                    // Email Field
                    CustomTextField(
                      label: 'Email Address',
                      controller: loginProvider.emailController,
                      prefixIcon: Icons.email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    CustomTextField(
                      label: 'Password',
                      controller: loginProvider.passwordController,
                      obscureText: loginProvider.obscurePassword,
                      prefixIcon: Icons.lock_rounded,
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginProvider.obscurePassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                        onPressed: () {
                          loginProvider.togglePasswordVisibility();
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Error message
                    if (loginProvider.errorMessage != null)
                      Container(
                        padding: EdgeInsets.all(theme.spacingMd),
                        decoration: BoxDecoration(
                          color: theme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(theme.radiusMd),
                          border: Border.all(
                            color: theme.error.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          loginProvider.errorMessage!,
                          style: theme.bodyMedium.copyWith(color: theme.error),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Modern Login Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: theme.primaryGradient,
                        borderRadius: BorderRadius.circular(theme.radiusMd),
                        boxShadow: theme.shadowLevel2,
                      ),
                      child: CustomButton(
                        text: 'Sign In',
                        onPressed: loginProvider.isLoading
                            ? null
                            : () => _login(context, loginProvider),
                        width: double.infinity,
                        isLoading: loginProvider.isLoading,
                        backgroundColor: Colors.transparent,
                        textColor: Colors.white,
                        borderRadius: theme.radiusMd,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Default Credentials Info
              Container(
                padding: EdgeInsets.all(theme.spacingLg),
                decoration: BoxDecoration(
                  color: theme.modernSurface,
                  borderRadius: BorderRadius.circular(theme.radiusLg),
                  boxShadow: theme.shadowLevel1,
                  border: Border.all(color: theme.modernBorder),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.modernPrimaryStart.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(theme.radiusFull),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: theme.modernPrimaryStart,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Default Credentials',
                      style: theme.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.modernTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: agha@tracklet.com\nPassword: 123123',
                      style: theme.bodySmall.copyWith(
                        color: theme.modernTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context, LoginProvider loginProvider) async {
    if (loginProvider.formKey.currentState!.validate()) {
      await loginProvider.login();
    }
  }
}
