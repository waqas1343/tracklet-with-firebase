import 'package:flutter/material.dart';

import 'app.dart';
import 'core/app/app_initializer.dart';
import 'core/providers/app_provider.dart';

void main() async {
  final initializer = AppInitializer();
  await initializer.initialize();

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
