import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Services
import '../../services/firebase_service.dart';
import '../services/admin_service.dart';

// Providers
import 'admin_provider.dart';

class AppProvider extends StatelessWidget {
  final Widget child;

  const AppProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService.instance;
    
    return MultiProvider(
      providers: [
        // Services
        Provider<FirebaseService>.value(value: firebaseService),
        Provider<AdminService>.value(value: AdminService()),
        
        // ViewModels (Providers)
        ChangeNotifierProvider<AdminProvider>(
          create: (_) => AdminProvider(adminService: AdminService()),
        ),
      ],
      child: child,
    );
  }
}