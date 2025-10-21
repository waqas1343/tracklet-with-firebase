import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUser {
  final String uid;
  final String email;
  final String name;

  FirebaseUser({
    required this.uid,
    required this.email,
    required this.name,
  });
}

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser? _currentUser;
  bool _isLoading = false;

  FirebaseUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final User? user = result.user;
      if (user != null) {
        _currentUser = FirebaseUser(
          uid: user.uid,
          email: user.email!,
          name: user.displayName ?? '',
        );
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register with email and password
  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final User? user = result.user;
      if (user != null) {
        // Update user profile with name
        await user.updateDisplayName(name);
        
        _currentUser = FirebaseUser(
          uid: user.uid,
          email: user.email!,
          name: name,
        );
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Check if user is already signed in
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final User? user = _auth.currentUser;
    if (user != null) {
      _currentUser = FirebaseUser(
        uid: user.uid,
        email: user.email!,
        name: user.displayName ?? '',
      );
    } else {
      _currentUser = null;
    }
    
    _isLoading = false;
    notifyListeners();
  }
}