import 'package:flutter/widgets.dart';
import '../../services/firebase_service.dart';
import '../services/admin_service.dart';

class AppInitializer {
  FirebaseService? _firebaseService;
  AdminService? _adminService;

  FirebaseService get firebaseService => _firebaseService!;
  AdminService get adminService => _adminService!;

  /// Initialize all services required by the application
  Future<void> initialize() async {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase Service
    _firebaseService = FirebaseService.instance;
    await _firebaseService!.initialize();

    // Initialize Admin Service
    _adminService = AdminService();
  }

  /// Check if services have been initialized
  bool get isInitialized => _firebaseService != null && _adminService != null;
}