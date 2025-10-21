import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Firebase configuration for mobile deployment
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Web configuration - only needed if you plan to deploy to web
      return const FirebaseOptions(
        apiKey: "AIzaSyBUsQJqwqMNunBYxfFJmxjEfLLZodjC-gM",
        authDomain: "tracklet-4db05.firebaseapp.com",
        projectId: "tracklet-4db05",
        storageBucket: "tracklet-4db05.firebasestorage.app",
        messagingSenderId: "862271235339",
        appId: "1:862271235339:web:39b595df493f0aa003ae0e",
        measurementId: "G-YOUR_MEASUREMENT_ID", // Get this from Firebase Console for web
      );
    } else {
      // Mobile configuration - uses google-services.json for Android
      return const FirebaseOptions(
        apiKey: "AIzaSyBUsQJqwqMNunBYxfFJmxjEfLLZodjC-gM",
        authDomain: "tracklet-4db05.firebaseapp.com",
        projectId: "tracklet-4db05",
        storageBucket: "tracklet-4db05.firebasestorage.app",
        messagingSenderId: "862271235339",
        appId: "1:862271235339:android:5c8c581756453d8e03ae0e",
      );
    }
  }
}