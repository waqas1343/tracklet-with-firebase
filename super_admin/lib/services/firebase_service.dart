// Firebase Service - User management with Firebase Auth and Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Static instance getter
  static FirebaseService get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Public getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;

  // Initialize method
  Future<void> initialize() async {
    // Firebase is already initialized when we access _auth and _firestore
    // This method is here for compatibility with app_initializer
    return Future.value();
  }

  // Create user with fixed password 123123
  Future<Map<String, dynamic>> createUser({
    required String name,
    required String email,
    required String role,
    required String phone,
    String department = '',
    String defaultPassword =
        '123123', // Fixed password for all super admin created users
  }) async {
    try {
      // Create user in Firebase Auth
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: defaultPassword,
          );

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user');
      }

      // Update user profile
      await user.updateDisplayName(name);

      // Map role to Tracklet format
      String trackletRole;
      if (role.toLowerCase() == 'gas plant' ||
          role.toLowerCase() == 'gasplant') {
        trackletRole = 'gasPlant';
      } else if (role.toLowerCase() == 'distributor') {
        trackletRole = 'distributor';
      } else {
        trackletRole = 'distributor'; // Default to distributor
      }

      // Create user document in Firestore
      final userData = {
        'id': user.uid,
        'name': name,
        'email': email,
        'role': trackletRole, // Use Tracklet format
        'phone': phone,
        'department': department,
        'isActive': true,
        'createdAt': DateTime.now()
            .toIso8601String(), // Use string format for Tracklet compatibility
        'lastLogin': null,
        'avatarUrl': '',
        'defaultPassword': true, // Flag to indicate default password
        'createdBy': 'super_admin',
      };

      await _firestore.collection('users').doc(user.uid).set(userData);

      // Sign out the created user (we don't want to stay logged in as them)
      await _auth.signOut();

      return {
        'success': true,
        'userId': user.uid,
        'message':
            'User created successfully with default password: $defaultPassword',
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Failed to create user';
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Password is too weak';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email is already in use';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        default:
          errorMessage = e.message ?? 'Authentication error';
      }
      return {'success': false, 'error': errorMessage};
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: ${e.toString()}'};
    }
  }

  // Get all users from Firestore
  Future<List<UserModel>> getAllUsers() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: ${e.toString()}');
    }
  }

  // Update user status
  Future<bool> updateUserStatus(String userId, bool isActive) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(String userId) async {
    try {
      // Delete from Firestore
      await _firestore.collection('users').doc(userId).delete();

      // Note: In production, you might want to delete from Auth as well
      // This requires admin privileges
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromFirestore(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Search users
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromFirestore(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
