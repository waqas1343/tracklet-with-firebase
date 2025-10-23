import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../services/firebase_service.dart';
import '../../../core/providers/login_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import 'admin_dashboard_screen.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, _) {
        // Pre-fill with fixed credentials on first build
        if (loginProvider.emailController.text.isEmpty) {
          loginProvider.emailController.text =
              'agha@tracklet.com'; // Changed from agha@gmail.com to match Firebase
          loginProvider.passwordController.text = '123123';
        }

        return _buildLoginScreen(context, loginProvider);
      },
    );
  }

  Widget _buildLoginScreen(BuildContext context, LoginProvider loginProvider) {
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
              const Icon(
                Icons.admin_panel_settings,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              const Text(
                'Super Admin Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tracklet Management System',
                style: TextStyle(fontSize: 16, color: Colors.grey),
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
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Login Button
                    CustomButton(
                      text: 'Login',
                      onPressed: loginProvider.isLoading ? null : () => _login(context, loginProvider),
                      width: double.infinity,
                      isLoading: loginProvider.isLoading,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Create Account Button
              CustomButton(
                text: 'Create New Account',
                onPressed: loginProvider.isLoading ? null : () => _showCreateAccountDialog(context, loginProvider),
                type: ButtonType.outlined,
                width: double.infinity,
              ),

              const SizedBox(height: 16),

              // Forgot Password
              TextButton(
                onPressed: () {
                  // TODO: Implement forgot password functionality
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 14),
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
      loginProvider.setLoading(true);
      loginProvider.setErrorMessage(null);

      try {
        final firebaseService = Provider.of<FirebaseService>(
          context,
          listen: false,
        );

        // Sign in with email and password
        final userCredential = await firebaseService.auth
            .signInWithEmailAndPassword(
              email: loginProvider.emailController.text.trim(),
              password: loginProvider.passwordController.text,
            );

        // Check if the user is an admin (in a real app, you would check this against
        // your database or use custom claims)
        // For now, we'll assume any successful login is an admin
        if (userCredential.user != null) {
          // Navigate to admin dashboard
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminDashboardScreen(),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'user-disabled':
            errorMessage = 'This user account has been disabled.';
            break;
          case 'user-not-found':
            errorMessage = 'No user found with this email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          case 'invalid-api-key':
            errorMessage =
                'Firebase API key is not valid. Please check your Firebase configuration.';
            break;
          case 'network-request-failed':
            errorMessage =
                'Network error. Please check your internet connection.';
            break;
          default:
            errorMessage = 'Login failed: ${e.message}';
        }
        loginProvider.setErrorMessage(errorMessage);
        loginProvider.setLoading(false);
      } on Exception catch (e) {
        loginProvider.setErrorMessage('Login failed: ${e.toString()}');
        loginProvider.setLoading(false);
      }
    }
  }

  Future<void> _showCreateAccountDialog(BuildContext context, LoginProvider loginProvider) async {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    String? errorMessage;
    bool isLoading = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create New Account'),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter password (at least 6 characters)',
                      ),
                      obscureText: true,
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });

                          try {
                            // Validate input first
                            final email = emailController.text.trim();
                            final password = passwordController.text;

                            if (email.isEmpty) {
                              setState(() {
                                errorMessage = 'Please enter an email address.';
                                isLoading = false;
                              });
                              return;
                            }

                            if (password.isEmpty) {
                              setState(() {
                                errorMessage = 'Please enter a password.';
                                isLoading = false;
                              });
                              return;
                            }

                            if (password.length < 6) {
                              setState(() {
                                errorMessage =
                                    'Password must be at least 6 characters.';
                                isLoading = false;
                              });
                              return;
                            }

                            // Check if Firebase is initialized
                            if (Firebase.apps.isEmpty) {
                              setState(() {
                                errorMessage =
                                    'Firebase is not initialized. Please restart the app.';
                                isLoading = false;
                              });
                              return;
                            }

                            // Use loginProvider to create account
                            await loginProvider.createAccount(email, password);

                            if (context.mounted) {
                              Navigator.of(context).pop();
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Account created successfully! You can now login with these credentials.',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            String errorMsg;
                            switch (e.code) {
                              case 'email-already-in-use':
                                errorMsg = 'This email is already registered.';
                                break;
                              case 'invalid-email':
                                errorMsg = 'The email address is not valid.';
                                break;
                              case 'operation-not-allowed':
                                errorMsg =
                                    'Email/password accounts are not enabled.';
                                break;
                              case 'weak-password':
                                errorMsg =
                                    'The password is too weak. Please use at least 6 characters.';
                                break;
                              default:
                                errorMsg =
                                    'Failed to create account: ${e.message}';
                            }
                            setState(() {
                              errorMessage = errorMsg;
                              isLoading = false;
                            });
                          } catch (e) {
                            setState(() {
                              errorMessage =
                                  'Failed to create account: ${e.toString()}';
                              isLoading = false;
                            });
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    emailController.dispose();
    passwordController.dispose();
  }
}
