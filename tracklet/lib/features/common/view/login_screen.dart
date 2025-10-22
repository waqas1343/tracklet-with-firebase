import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Add this import
import '../../../core/providers/user_role_provider.dart' as user_role;
import '../../../core/models/user_model.dart' as user_model;
import '../../../core/services/firebase_service.dart';
import '../../../core/providers/profile_provider.dart'; // Add this import
import '../../../core/services/fcm_service.dart'; // Add this import
import '../../../shared/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleLogin(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    ValueNotifier<String?> errorMessage,
    ValueNotifier<bool> isLoading,
  ) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage.value = 'Please enter both email and password';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final firebaseService = Provider.of<FirebaseService>(
        context,
        listen: false,
      );
      final userRoleProvider = Provider.of<user_role.UserRoleProvider>(
        context,
        listen: false,
      );
      final profileProvider = Provider.of<ProfileProvider>( // Add this
        context,
        listen: false,
      );

      // Sign in with Firebase Authentication
      final userCredential = await firebaseService.auth
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      if (userCredential.user != null) {
        // Fetch user data from Firestore
        final userDoc = await firebaseService.firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final user = user_model.UserModel.fromJson(userData);

          // Set the user role based on Firestore data
          // Note: user.role from UserModel is already a UserRole enum
          user_role.UserRole role;

          // Debug: Print role from Firestore
          print('🔍 Login - User role from Firestore: ${userData['role']}');
          print('🔍 Login - Parsed UserRole enum: ${user.role}');

          if (user.role == user_model.UserRole.gasPlant) {
            role = user_role.UserRole.gasPlant;
            print('✅ Login - Setting role to GAS PLANT');
          } else if (user.role == user_model.UserRole.distributor) {
            role = user_role.UserRole.distributor;
            print('✅ Login - Setting role to DISTRIBUTOR');
          } else {
            // Default to distributor if role is not recognized
            role = user_role.UserRole.distributor;
            print('⚠️ Login - Role not recognized, defaulting to DISTRIBUTOR');
          }

          await userRoleProvider.setUserRole(role);
          print('✅ Login - Role set successfully: $role');

          // Initialize profile provider with current user data
          await profileProvider.loadUserProfile(userCredential.user!.uid);
          print('✅ Login - Profile provider initialized');

          // Save FCM token to Firestore for push notifications
          try {
            final fcmService = Provider.of<FCMService>(
              context,
              listen: false,
            );
            await fcmService.saveFCMToken(userCredential.user!.uid);
            print('✅ Login - FCM token saved to Firestore');
          } catch (e) {
            print('⚠️ Login - Failed to save FCM token: $e');
          }

          // Update last login time
          await firebaseService.firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .update({'lastLogin': DateTime.now().toIso8601String()});

          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/main');
          }
        } else {
          errorMessage.value = 'User data not found';
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage.value = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        errorMessage.value = 'Incorrect password';
      } else {
        errorMessage.value = 'Login failed: ${e.message}';
      }
    } catch (e) {
      errorMessage.value = 'Login failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controllers and notifiers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final obscurePassword = ValueNotifier<bool>(true);
    final rememberMe = ValueNotifier<bool>(true);
    final isLoading = ValueNotifier<bool>(false);
    final errorMessage = ValueNotifier<String?>(null);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              // Title
              const Text(
                'Login to Your Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                'Enter your credentials provided by your admin.',
                style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Email Field
              const Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A2B4C),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF1A2B4C)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Password Field
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: obscurePassword,
                builder: (context, isObscure, child) {
                  return TextFormField(
                    controller: passwordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF1A2B4C)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFFAAAAAA),
                        ),
                        onPressed: () =>
                            obscurePassword.value = !obscurePassword.value,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Remember Me Checkbox
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: rememberMe,
                    builder: (context, isChecked, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => rememberMe.value = !rememberMe.value,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isChecked
                                    ? const Color(0xFF1A2B4C)
                                    : Colors.white,
                                border: Border.all(
                                  color: isChecked
                                      ? const Color(0xFF1A2B4C)
                                      : const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: isChecked
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Error message
              ValueListenableBuilder<String?>(
                valueListenable: errorMessage,
                builder: (context, error, child) {
                  if (error == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Login Button
              ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, loading, child) {
                  return CustomButton(
                    text: loading ? 'Logging in...' : 'Login',
                    onPressed: loading
                        ? null
                        : () => _handleLogin(
                            context,
                            emailController,
                            passwordController,
                            errorMessage,
                            isLoading,
                          ),
                    width: double.infinity,
                    backgroundColor: const Color(0xFF1A2B4C),
                    textColor: Colors.white,
                    height: 50,
                    borderRadius: 12,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}