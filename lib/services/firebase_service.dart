import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/lens_price_entry.dart';
import '../models/user.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  fb_auth.FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  GoogleSignIn get googleSignIn => _googleSignIn;

  fb_auth.User? get currentUser => _auth.currentUser;

  // Authentication Methods
  Future<fb_auth.UserCredential> signUpWithEmail(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<fb_auth.UserCredential> signInWithEmail(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<fb_auth.UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in aborted');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = fb_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // Firestore Methods
  Future<void> createUserDocument(User user, String fcmToken) async {
    final userMap = user.copyWith(fcmToken: fcmToken).toMap();
    await _firestore.collection('users').doc(user.uid).set(userMap);
  }

  Future<User?> getUserDocument(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return User.fromDocument(doc);
    }
    return null;
  }

  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  // Price Catalog Methods
  Stream<QuerySnapshot> getPriceCatalog() {
    return _firestore.collection('price_catalog').snapshots();
  }

  Future<LensPriceCatalog?> getLensPriceCatalog(
      String brand, String model) async {
    final docId =
        '${brand.toLowerCase()}_${model.toLowerCase().replaceAll(' ', '')}';
    final doc = await _firestore.collection('price_catalog').doc(docId).get();
    if (doc.exists) {
      return LensPriceCatalog.fromDocument(doc);
    }
    return null;
  }

  /// Complete account deletion workflow
  /// Deletes both Firestore data and Firebase Auth account
  /// Required for GDPR "right to be forgotten" compliance
  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in');
    }

    final uid = user.uid;

    try {
      // Step 1: Delete Firestore data
      await _firestore.collection('users').doc(uid).delete();
      print('User data deleted from Firestore: $uid');

      // Step 2: Delete Firebase Auth account
      await user.delete();
      print('Firebase Auth account deleted: $uid');

      // Step 3: Sign out from Google (if applicable)
      await _googleSignIn.signOut();

      print('Account deletion completed successfully');
    } catch (e) {
      print('Error during account deletion: $e');

      // If user needs to re-authenticate (common error)
      if (e.toString().contains('requires-recent-login')) {
        throw Exception(
            'For security reasons, please sign out and sign back in before deleting your account.');
      }

      rethrow;
    }
  }
}
