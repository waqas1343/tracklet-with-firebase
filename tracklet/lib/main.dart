import 'package:flutter/material.dart';

// Core
import 'app.dart';
import 'core/app/app_initializer.dart';
import 'core/providers/app_provider.dart';

/// Main entry point of the Tracklet application
///
/// This file is kept intentionally clean and minimal.
/// It only handles:
/// 1. Service initialization via AppInitializer
/// 2. Running the app with AppProvider wrapping MyApp
///
/// Architecture:
/// - AppInitializer: Handles all service setup
/// - AppProvider: Manages all providers and dependency injection
/// - MyApp: Root widget with MaterialApp configuration
void main() async {
  // Initialize all services
  final initializer = AppInitializer();
  await initializer.initialize();

  // Run the app with provider setup
  runApp(
    AppProvider(
      storageService: initializer.storageService,
      apiService: initializer.apiService,
      authService: initializer.authService,
      firebaseService: initializer.firebaseService,
      child: const MyApp(),
    ),
  );
}
