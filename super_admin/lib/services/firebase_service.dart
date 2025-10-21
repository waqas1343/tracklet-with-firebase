import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/config/firebase_options.dart';

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
      try {
        // Check if Firebase is already initialized
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        } else {
          // Firebase is already initialized, use the existing app
          Firebase.app();
        }
        _initialized = true;
      } catch (e) {
        // Handle duplicate app error
        if (e is FirebaseException && e.code == 'duplicate-app') {
          // App already exists, this is fine
          _initialized = true;
        } else {
          // Re-throw other errors
          rethrow;
        }
      }
    }
  }

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}