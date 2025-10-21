import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/firebase_auth_provider.dart';
import '../../../core/providers/profile_provider.dart'; // Add this import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final firebaseAuth = Provider.of<FirebaseAuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false); // Add this
    await firebaseAuth.checkAuthStatus();
    
    if (!mounted) return;
    
    // Check if user is already authenticated
    if (firebaseAuth.isAuthenticated) {
      // Initialize profile provider with current user data
      await profileProvider.loadUserProfile(firebaseAuth.currentUser!.uid);
      print('✅ Splash - Profile provider initialized for existing user');
      
      // Navigate to main screen
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2B4C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            Icon(
              Icons.local_shipping,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tracklet',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Gas Delivery Management System',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}