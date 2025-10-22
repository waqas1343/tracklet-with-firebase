import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/firebase_service.dart';
import '../../../core/providers/splash_provider.dart';
import 'admin_dashboard_screen.dart';
import 'admin_login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, _) {
        // Check auth status when the widget is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkAuthStatus(context, splashProvider);
        });
        
        return _buildSplashScreen();
      },
    );
  }

  Future<void> _checkAuthStatus(BuildContext context, SplashProvider splashProvider) async {
    final isAuthenticated = await splashProvider.checkAuthStatus();
    
    if (!context.mounted) return;
    
    if (isAuthenticated) {
      // User is already signed in, navigate to admin dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminDashboardScreen(),
        ),
      );
    } else {
      // No user is signed in, navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminLoginScreen(),
        ),
      );
    }
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.admin_panel_settings,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Super Admin',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tracklet Management System',
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