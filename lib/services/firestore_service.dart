import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/lens_price_entry.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User-specific methods
  Future<User> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return User.fromDocument(doc);
    }
    throw Exception('User not found');
  }

  Stream<User> streamUser(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => User.fromDocument(doc));
  }

  Future<void> updateUserProfile(
    String uid, {
    String? diopterLeft,
    String? diopterRight,
    String? preferredLensBrand,
    String? preferredLensModel,
  }) async {
    final updates = <String, dynamic>{};

    if (diopterLeft != null) updates['diopter_left'] = diopterLeft;
    if (diopterRight != null) updates['diopter_right'] = diopterRight;
    if (preferredLensBrand != null) {
      updates['preferred_lens_brand'] = preferredLensBrand;
    }
    if (preferredLensModel != null) {
      updates['preferred_lens_model'] = preferredLensModel;
    }

    await _firestore.collection('users').doc(uid).update(updates);
  }

  Future<void> updateUserFCMToken(String uid, String token) async {
    await _firestore.collection('users').doc(uid).update({'fcm_token': token});
  }

  Future<void> updateUserLastNotifiedPrice(
    String uid,
    double price,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'last_notified_price': price});
  }

  // Lens wear tracking
  Future<void> startNewLensPair(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'current_pair_start_date': FieldValue.serverTimestamp(),
    });
  }

  Stream<DocumentSnapshot> streamLensWearData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<Duration> getCurrentLensWearDuration(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data();

    if (data == null || data['current_pair_start_date'] == null) {
      return Duration.zero;
    }

    final startDate = (data['current_pair_start_date'] as Timestamp).toDate();
    final now = DateTime.now();
    return now.difference(startDate);
  }

  // Price catalog methods
  Stream<QuerySnapshot> streamPriceCatalog() {
    return _firestore.collection('price_catalog').snapshots();
  }

  Future<LensPriceCatalog?> getLensPriceCatalog(
    String brand,
    String model,
  ) async {
    final docId =
        '${brand.toLowerCase()}_${model.toLowerCase().replaceAll(' ', '')}';
    final doc = await _firestore.collection('price_catalog').doc(docId).get();
    if (doc.exists) {
      return LensPriceCatalog.fromDocument(doc);
    }
    return null;
  }

  Future<double?> getBestPriceForUser(
    String brand,
    String model,
    String diopter,
  ) async {
    final catalog = await getLensPriceCatalog(brand, model);
    if (catalog == null) return null;

    final price = catalog.getPriceForDiopter(diopter);
    return price;
  }

  // Batch operations
  Future<void> updateAllUsersPriceTargets() async {
    final users = await _firestore.collection('users').get();
    final batch = _firestore.batch();

    for (final doc in users.docs) {
      batch.update(doc.reference, {
        'last_price_check': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  /// Delete all user data from Firestore
  /// This is required for GDPR compliance ("right to be forgotten")
  Future<void> deleteUserAccount(String uid) async {
    try {
      // Delete user document
      await _firestore.collection('users').doc(uid).delete();

      // Delete any user-specific subcollections if they exist
      // (e.g., reminders, price_alerts, etc.)
      // Add additional cleanup as needed when more collections are added

      // Note: This only deletes Firestore data
      // Firebase Auth account deletion is handled separately
      print('User data deleted successfully from Firestore: $uid');
    } catch (e) {
      print('Error deleting user data: $e');
      rethrow;
    }
  }
}
