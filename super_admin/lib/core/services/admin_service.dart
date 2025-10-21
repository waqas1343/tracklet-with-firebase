import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AdminService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new user with default password
  Future<bool> createUser({
    required String email,
    required String role,
    String? companyName,
    String? address,
    String? name,
  }) async {
    try {
      // Create user in Firebase Authentication with default password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: '123123', // Default password
      );

      // Save additional user data to Firestore
      final userData = {
        'id': userCredential.user!.uid,
        'email': email,
        'role': role,
        'companyName': companyName,
        'address': address,
        'name': name,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);
      
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  // Get all users from Firestore
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Update user role
  Future<bool> updateUserRole(String userId, String newRole) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole,
      });
      return true;
    } catch (e) {
      print('Error updating user role: $e');
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(String userId) async {
    try {
      // Delete from Firestore
      await _firestore.collection('users').doc(userId).delete();
      
      // Delete from Firebase Authentication
      final user = _auth.currentUser;
      if (user != null && user.uid != userId) {
        // Only delete if it's not the current admin user
        final userToDelete = _auth.currentUser;
        // We can't directly delete another user, this would need to be done
        // through Firebase Admin SDK on a server
      }
      
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }
}