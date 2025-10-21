import 'package:flutter/widgets.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/firebase_service.dart';
import '../services/fcm_service.dart';

/// AppInitializer: Handles all application initialization logic
///
/// This class is responsible for:
/// - Initializing Flutter bindings
/// - Setting up services (Storage, API, Auth, Firebase)
/// - Ensuring services are ready before the app starts
///
/// This keeps main.dart clean and follows Single Responsibility Principle
class AppInitializer {
  StorageService? _storageService;
  ApiService? _apiService;
  AuthService? _authService;
  FirebaseService? _firebaseService;
  FCMService? _fcmService;

  StorageService get storageService => _storageService!;
  ApiService get apiService => _apiService!;
  AuthService get authService => _authService!;
  FirebaseService get firebaseService => _firebaseService!;
  FCMService get fcmService => _fcmService!;

  /// Initialize all services required by the application
  ///
  /// Call this method before running the app to ensure all services
  /// are properly initialized and ready to use
  Future<void> initialize() async {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase Service first
    _firebaseService = FirebaseService.instance;
    await _firebaseService!.initialize();

    // Now initialize FCM Service after Firebase is ready
    _fcmService = FCMService.instance;
    await _fcmService!.initialize();

    // Initialize Storage Service
    _storageService = StorageService();
    await _storageService!.init();

    // Initialize API Service
    _apiService = ApiService();

    // Initialize Auth Service with dependencies
    _authService = AuthService(
      apiService: _apiService!,
      storageService: _storageService!,
    );
  }

  /// Check if services have been initialized
  bool get isInitialized =>
      _storageService != null && 
      _apiService != null && 
      _authService != null &&
      _firebaseService != null &&
      _fcmService != null;
}