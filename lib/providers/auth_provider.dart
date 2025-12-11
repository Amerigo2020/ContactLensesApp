import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../services/firebase_service.dart';
import '../services/firestore_service.dart';
import '../models/user.dart' as model;

/// Provider for authentication state and operations
class AuthProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final FirestoreService _firestoreService = FirestoreService();

  auth.User? _firebaseUser;
  model.User? _userProfile;
  bool _isLoading = false;
  String? _error;

  // Getters
  auth.User? get firebaseUser => _firebaseUser;
  model.User? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _firebaseUser != null;

  AuthProvider() {
    _initAuthListener();
  }

  /// Listen to Firebase Auth state changes
  void _initAuthListener() {
    _firebaseService.auth.authStateChanges().listen((auth.User? user) async {
      _firebaseUser = user;
      
      if (user != null) {
        // Load user profile from Firestore
        try {
          _userProfile = await _firebaseService.getUserDocument(user.uid);
        } catch (e) {
          debugPrint('Error loading user profile: $e');
        }
      } else {
        _userProfile = null;
      }
      
      notifyListeners();
    });
  }

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _firebaseService.signInWithEmail(email, password);
      // User profile will be loaded by auth state listener
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final credential = await _firebaseService.signUpWithEmail(email, password);
      
      // Create user document in Firestore
      final newUser = model.User(
        uid: credential.user!.uid,
        email: email,
      );
      
      await _firebaseService.createUserDocument(newUser, ''); // FCM token to be set later
      _userProfile = newUser;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      final credential = await _firebaseService.signInWithGoogle();
      
      // Check if user document exists
      final existingUser = await _firebaseService.getUserDocument(credential.user!.uid);
      
      if (existingUser == null) {
        // Create new user document
        final newUser = model.User(
          uid: credential.user!.uid,
          email: credential.user!.email!,
        );
        await _firebaseService.createUserDocument(newUser, '');
        _userProfile = newUser;
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _firebaseService.signOut();
      _userProfile = null;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    _setLoading(true);
    _clearError();

    try {
      await _firebaseService.deleteAccount();
      _userProfile = null;
      _firebaseUser = null;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
