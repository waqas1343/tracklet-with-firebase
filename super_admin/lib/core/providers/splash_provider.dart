import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';

class SplashProvider extends ChangeNotifier {
  final FirebaseService _firebaseService;
  
  SplashProvider(this._firebaseService);

  Future<bool> checkAuthStatus() async {
    // Simulate delay for splash screen
    await Future.delayed(const Duration(seconds: 2));
    
    final user = _firebaseService.auth.currentUser;
    return user != null;
  }
}