import 'package:flutter/material.dart';
import 'core/app/app_initializer.dart';
import 'core/providers/app_provider.dart';
import 'features/admin/views/splash_screen.dart';

void main() async {
  // Initialize all services
  final initializer = AppInitializer();
  await initializer.initialize();
  
  runApp(
    AppProvider(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}