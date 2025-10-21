import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

/// ProfileRepository - Handles all profile-related data operations
/// Acts as a bridge between the Provider and Firestore
class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _usersCollection = 'users';

  /// Get current user's UID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Create a new user profile
  Future<bool> createProfile(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toJson());
      return true;
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  /// Get user profile by UID
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  /// Update user profile
  Future<bool> updateProfile(String uid, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).update(updates);
      return true;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Update specific profile fields
  Future<bool> updateProfileFields({
    required String uid,
    String? name,
    String? email,
    String? phone,
    String? companyName,
    String? address,
    String? operatingHours,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (name != null) updates['name'] = name;
      if (email != null) updates['email'] = email;
      if (phone != null) updates['phone'] = phone;
      if (companyName != null) updates['companyName'] = companyName;
      if (address != null) updates['address'] = address;
      if (operatingHours != null) updates['operatingHours'] = operatingHours;

      updates['lastLogin'] = DateTime.now().toIso8601String();

      await _firestore.collection(_usersCollection).doc(uid).update(updates);
      return true;
    } catch (e) {
      throw Exception('Failed to update profile fields: $e');
    }
  }

  /// Delete user profile
  Future<bool> deleteProfile(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  /// Check if profile exists
  Future<bool> profileExists(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check profile existence: $e');
    }
  }

  /// Get real-time profile stream
  Stream<UserModel?> getProfileStream(String uid) {
    return _firestore.collection(_usersCollection).doc(uid).snapshots().map((
      doc,
    ) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    });
  }

  /// Update last login timestamp
  Future<bool> updateLastLogin(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).update({
        'lastLogin': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      throw Exception('Failed to update last login: $e');
    }
  }

  /// Batch update multiple users
  Future<bool> batchUpdateProfiles(List<UserModel> users) async {
    try {
      final batch = _firestore.batch();

      for (final user in users) {
        final docRef = _firestore.collection(_usersCollection).doc(user.id);
        batch.set(docRef, user.toJson());
      }

      await batch.commit();
      return true;
    } catch (e) {
      throw Exception('Failed to batch update profiles: $e');
    }
  }
}
