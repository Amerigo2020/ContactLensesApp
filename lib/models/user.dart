import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String? diopterLeft;
  final String? diopterRight;
  final String? preferredLensBrand;
  final String? preferredLensModel;
  final String? fcmToken;
  final double? lastNotifiedPrice;
  final Timestamp? createdAt;

  User({
    required this.uid,
    required this.email,
    this.diopterLeft,
    this.diopterRight,
    this.preferredLensBrand,
    this.preferredLensModel,
    this.fcmToken,
    this.lastNotifiedPrice,
    this.createdAt,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      email: data['email'] ?? '',
      diopterLeft: data['diopter_left'],
      diopterRight: data['diopter_right'],
      preferredLensBrand: data['preferred_lens_brand'],
      preferredLensModel: data['preferred_lens_model'],
      fcmToken: data['fcm_token'],
      lastNotifiedPrice: data['last_notified_price']?.toDouble(),
      createdAt: data['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'diopter_left': diopterLeft,
      'diopter_right': diopterRight,
      'preferred_lens_brand': preferredLensBrand,
      'preferred_lens_model': preferredLensModel,
      'fcm_token': fcmToken,
      'last_notified_price': lastNotifiedPrice,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  User copyWith({
    String? diopterLeft,
    String? diopterRight,
    String? preferredLensBrand,
    String? preferredLensModel,
    String? fcmToken,
    double? lastNotifiedPrice,
  }) {
    return User(
      uid: uid,
      email: email,
      diopterLeft: diopterLeft ?? this.diopterLeft,
      diopterRight: diopterRight ?? this.diopterRight,
      preferredLensBrand: preferredLensBrand ?? this.preferredLensBrand,
      preferredLensModel: preferredLensModel ?? this.preferredLensModel,
      fcmToken: fcmToken ?? this.fcmToken,
      lastNotifiedPrice: lastNotifiedPrice ?? this.lastNotifiedPrice,
      createdAt: createdAt,
    );
  }
}
