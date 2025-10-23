// Super Admin Login Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';
import '../providers/theme_provider.dart';
import '../shared/widgets/custom_button.dart';
import '../shared/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              // Logo/Title
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.admin_panel_settings,
                  size: 60,
                  color: theme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Super Admin Login',
                style: theme.heading1.copyWith(
                  color: theme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tracklet Management System',
                style: theme.bodyLarge.copyWith(color: theme.textMuted),
              ),
              const SizedBox(height: 48),

              Form(
                key: loginProvider.formKey,
                child: Column(
                  children: [
                    // Email Field
                    CustomTextField(
                      label: 'Email',
                      controller: loginProvider.emailController,
                      prefixIcon: Icons.email,
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
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginProvider.obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          loginProvider.errorMessage!,
                          style: theme.bodyMedium.copyWith(color: theme.error),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Login Button
                    CustomButton(
                      text: 'Login',
                      onPressed: loginProvider.isLoading
                          ? null
                          : () => _login(context, loginProvider),
                      width: double.infinity,
                      isLoading: loginProvider.isLoading,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Default Credentials Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.divider),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: theme.primary, size: 24),
                    const SizedBox(height: 8),
                    Text(
                      'Default Credentials',
                      style: theme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Email: agha@tracklet.com\nPassword: 123123',
                      style: theme.bodySmall.copyWith(color: theme.textMuted),
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
