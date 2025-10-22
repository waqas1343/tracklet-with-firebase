import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../services/firebase_service.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseService _firebaseService;
  
  LoginProvider(this._firebaseService);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      setLoading(true);
      setErrorMessage(null);

      try {
        // Sign in with email and password
        final userCredential = await _firebaseService.auth
            .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text,
            );

        // Check if the user is an admin (in a real app, you would check this against
        // your database or use custom claims)
        // For now, we'll assume any successful login is an admin
        if (userCredential.user != null) {
          // Login successful - navigation will be handled by the UI
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
        setErrorMessage(errorMessage);
        setLoading(false);
      } on Exception catch (e) {
        setErrorMessage('Login failed: ${e.toString()}');
        setLoading(false);
      }
    }
  }

  Future<void> createAccount(String email, String password) async {
    try {
      // Validate input first
      if (email.isEmpty) {
        setErrorMessage('Please enter an email address.');
        return;
      }

      if (password.isEmpty) {
        setErrorMessage('Please enter a password.');
        return;
      }

      if (password.length < 6) {
        setErrorMessage('Password must be at least 6 characters.');
        return;
      }

      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        setErrorMessage('Firebase is not initialized. Please restart the app.');
        return;
      }

      // Use FirebaseAuth directly instead of through FirebaseService
      // This avoids potential context issues in dialogs
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

      if (userCredential.user != null) {
        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'id': userCredential.user!.uid,
              'email': email,
              'role': 'distributor', // default role, can be changed later
              'createdAt': DateTime.now().toIso8601String(),
            });
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
          errorMsg = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMsg = 'The password is too weak. Please use at least 6 characters.';
          break;
        default:
          errorMsg = 'Failed to create account: ${e.message}';
      }
      setErrorMessage(errorMsg);
    } catch (e) {
      setErrorMessage('Failed to create account: ${e.toString()}');
    }
  }
}