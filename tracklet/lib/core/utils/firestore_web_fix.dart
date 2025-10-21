import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Web-specific Firestore configuration to avoid persistence errors
///
/// This utility ensures Firestore is properly configured for web platforms
/// before any database operations are performed.
class FirestoreWebFix {
  static bool _configured = false;

  /// Configure Firestore for web platform
  ///
  /// This should be called ONCE at app startup, before any Firestore operations
  static Future<void> configure() async {
    if (_configured) {
      if (kDebugMode) {
        print('⚠️ Firestore already configured, skipping...');
      }
      return;
    }

    if (kIsWeb) {
      if (kDebugMode) {
        print('🌐 Configuring Firestore for Web...');
      }

      try {
        // Attempt 1: Clear persistence and apply settings
        try {
          await FirebaseFirestore.instance.clearPersistence();
          if (kDebugMode) {
            print('✅ Cleared Firestore persistence');
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Could not clear persistence (may not exist): $e');
          }
        }

        // Attempt 2: Apply settings
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: false,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );

        if (kDebugMode) {
          print('✅ Firestore settings applied (persistence disabled)');
        }

        _configured = true;
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error configuring Firestore: $e');
          print('⚠️ App will continue but may experience issues');
        }

        // Mark as configured anyway to prevent repeated attempts
        _configured = true;
      }
    } else {
      if (kDebugMode) {
        print('📱 Mobile platform - No special Firestore configuration needed');
      }
      _configured = true;
    }
  }

  /// Check if Firestore has been configured
  static bool get isConfigured => _configured;

  /// Force reconfiguration (for testing purposes)
  static void reset() {
    _configured = false;
  }
}
