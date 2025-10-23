// Login Provider - Handle super admin authentication
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;

  // Initialize with default credentials
  LoginProvider() {
    emailController.text = 'agha@tracklet.com';
    passwordController.text = '123123';
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Login method
  Future<void> login() async {
    setLoading(true);
    setErrorMessage(null);

    try {
      // For demo purposes, check credentials directly
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email == 'agha@tracklet.com' && password == '123123') {
        _isLoggedIn = true;
        setLoading(false);
        notifyListeners();
      } else {
        setErrorMessage(
          'Invalid credentials. Please use the default credentials.',
        );
        setLoading(false);
      }
    } catch (e) {
      setErrorMessage('Login failed: ${e.toString()}');
      setLoading(false);
    }
  }

  // Logout method
  void logout() {
    _isLoggedIn = false;
    emailController.clear();
    passwordController.clear();
    setErrorMessage(null);
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
