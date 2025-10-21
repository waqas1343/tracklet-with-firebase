import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../config/firebase_options.dart';
import '../utils/firestore_web_fix.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static bool _initialized = false;

  FirebaseService._();

  static FirebaseService get instance {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  Future<void> initialize() async {
    if (!_initialized) {
      if (kDebugMode) {
        print('🔧 Initializing Firebase...');
      }

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      if (kDebugMode) {
        print('✅ Firebase initialized');
      }

      // CRITICAL: Configure Firestore IMMEDIATELY after initialization
      // This MUST happen before any Firestore calls
      await FirestoreWebFix.configure();

      _initialized = true;

      if (kDebugMode) {
        print('✅ Firebase Service ready');
      }
    }
  }

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}
