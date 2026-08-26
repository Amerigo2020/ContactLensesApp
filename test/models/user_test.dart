import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lensguard/models/user.dart';

void main() {
  group('User', () {
    group('toMap()', () {
      test('returns map with all fields when every field is set', () {
        final timestamp = Timestamp.fromDate(DateTime(2024, 1, 15));
        final user = User(
          uid: 'test-uid-123',
          email: 'test@example.com',
          diopterLeft: '-2.50',
          diopterRight: '-3.00',
          preferredLensBrand: 'Acuvue',
          preferredLensModel: 'Oasys',
          fcmToken: 'fcm-token-abc',
          lastNotifiedPrice: 29.99,
          createdAt: timestamp,
        );

        final map = user.toMap();

        expect(map['uid'], 'test-uid-123');
        expect(map['email'], 'test@example.com');
        expect(map['diopter_left'], '-2.50');
        expect(map['diopter_right'], '-3.00');
        expect(map['preferred_lens_brand'], 'Acuvue');
        expect(map['preferred_lens_model'], 'Oasys');
        expect(map['fcm_token'], 'fcm-token-abc');
        expect(map['last_notified_price'], 29.99);
        expect(map['created_at'], timestamp);
      });

      test('returns map with null optional fields when not set', () {
        final user = User(
          uid: 'uid-456',
          email: 'minimal@example.com',
        );

        final map = user.toMap();

        expect(map['uid'], 'uid-456');
        expect(map['email'], 'minimal@example.com');
        expect(map['diopter_left'], isNull);
        expect(map['diopter_right'], isNull);
        expect(map['preferred_lens_brand'], isNull);
        expect(map['preferred_lens_model'], isNull);
        expect(map['fcm_token'], isNull);
        expect(map['last_notified_price'], isNull);
      });

      test('uses FieldValue.serverTimestamp() when createdAt is null', () {
        final user = User(
          uid: 'uid-789',
          email: 'no-timestamp@example.com',
        );

        final map = user.toMap();

        // When createdAt is null, toMap() falls back to FieldValue.serverTimestamp().
        // FieldValue.serverTimestamp() is a sentinel object, not a Timestamp,
        // so it should NOT be a Timestamp instance.
        expect(map['created_at'], isNotNull);
        expect(map['created_at'], isNot(isA<Timestamp>()));
      });

      test('uses provided Timestamp when createdAt is set', () {
        final timestamp = Timestamp.fromDate(DateTime(2025, 6, 1));
        final user = User(
          uid: 'uid-ts',
          email: 'with-ts@example.com',
          createdAt: timestamp,
        );

        final map = user.toMap();

        expect(map['created_at'], isA<Timestamp>());
        expect(map['created_at'], timestamp);
      });

      test('contains all expected keys', () {
        final user = User(uid: 'uid-keys', email: 'keys@example.com');
        final map = user.toMap();

        expect(map.containsKey('uid'), isTrue);
        expect(map.containsKey('email'), isTrue);
        expect(map.containsKey('diopter_left'), isTrue);
        expect(map.containsKey('diopter_right'), isTrue);
        expect(map.containsKey('preferred_lens_brand'), isTrue);
        expect(map.containsKey('preferred_lens_model'), isTrue);
        expect(map.containsKey('fcm_token'), isTrue);
        expect(map.containsKey('last_notified_price'), isTrue);
        expect(map.containsKey('created_at'), isTrue);
      });
    });

    group('copyWith()', () {
      late User baseUser;

      setUp(() {
        baseUser = User(
          uid: 'base-uid',
          email: 'base@example.com',
          diopterLeft: '-1.00',
          diopterRight: '-1.50',
          preferredLensBrand: 'Dailies',
          preferredLensModel: 'Total1',
          fcmToken: 'original-token',
          lastNotifiedPrice: 19.99,
          createdAt: Timestamp.fromDate(DateTime(2024, 3, 10)),
        );
      });

      test('overrides a single field and preserves all others', () {
        final updated = baseUser.copyWith(diopterLeft: '-2.00');

        expect(updated.diopterLeft, '-2.00');
        // All other fields remain unchanged.
        expect(updated.uid, baseUser.uid);
        expect(updated.email, baseUser.email);
        expect(updated.diopterRight, baseUser.diopterRight);
        expect(updated.preferredLensBrand, baseUser.preferredLensBrand);
        expect(updated.preferredLensModel, baseUser.preferredLensModel);
        expect(updated.fcmToken, baseUser.fcmToken);
        expect(updated.lastNotifiedPrice, baseUser.lastNotifiedPrice);
        expect(updated.createdAt, baseUser.createdAt);
      });

      test('overrides multiple fields simultaneously', () {
        final updated = baseUser.copyWith(
          diopterLeft: '-3.00',
          diopterRight: '-3.50',
          preferredLensBrand: 'Biofinity',
          lastNotifiedPrice: 25.50,
        );

        expect(updated.diopterLeft, '-3.00');
        expect(updated.diopterRight, '-3.50');
        expect(updated.preferredLensBrand, 'Biofinity');
        expect(updated.lastNotifiedPrice, 25.50);
        // Unchanged fields.
        expect(updated.uid, baseUser.uid);
        expect(updated.email, baseUser.email);
        expect(updated.preferredLensModel, baseUser.preferredLensModel);
        expect(updated.fcmToken, baseUser.fcmToken);
        expect(updated.createdAt, baseUser.createdAt);
      });

      test('preserves uid and email (not overridable via copyWith)', () {
        final updated = baseUser.copyWith(
          fcmToken: 'new-token',
        );

        expect(updated.uid, 'base-uid');
        expect(updated.email, 'base@example.com');
      });

      test('preserves createdAt (not overridable via copyWith)', () {
        final originalTimestamp = baseUser.createdAt;
        final updated = baseUser.copyWith(diopterLeft: '-5.00');

        expect(updated.createdAt, originalTimestamp);
      });

      test('returns a new instance, not the same object', () {
        final updated = baseUser.copyWith(diopterLeft: '-2.00');

        expect(identical(updated, baseUser), isFalse);
      });

      test('with no arguments returns a copy with identical values', () {
        final copy = baseUser.copyWith();

        expect(copy.uid, baseUser.uid);
        expect(copy.email, baseUser.email);
        expect(copy.diopterLeft, baseUser.diopterLeft);
        expect(copy.diopterRight, baseUser.diopterRight);
        expect(copy.preferredLensBrand, baseUser.preferredLensBrand);
        expect(copy.preferredLensModel, baseUser.preferredLensModel);
        expect(copy.fcmToken, baseUser.fcmToken);
        expect(copy.lastNotifiedPrice, baseUser.lastNotifiedPrice);
        expect(copy.createdAt, baseUser.createdAt);
      });

      test('overrides fcmToken field', () {
        final updated = baseUser.copyWith(fcmToken: 'refreshed-token');

        expect(updated.fcmToken, 'refreshed-token');
      });

      test('overrides preferredLensModel field', () {
        final updated = baseUser.copyWith(preferredLensModel: 'AquaComfort');

        expect(updated.preferredLensModel, 'AquaComfort');
        expect(updated.preferredLensBrand, baseUser.preferredLensBrand);
      });
    });

    group('constructor', () {
      test('creates user with only required fields', () {
        final user = User(uid: 'req-uid', email: 'req@example.com');

        expect(user.uid, 'req-uid');
        expect(user.email, 'req@example.com');
        expect(user.diopterLeft, isNull);
        expect(user.diopterRight, isNull);
        expect(user.preferredLensBrand, isNull);
        expect(user.preferredLensModel, isNull);
        expect(user.fcmToken, isNull);
        expect(user.lastNotifiedPrice, isNull);
        expect(user.createdAt, isNull);
      });

      test('creates user with all fields populated', () {
        final ts = Timestamp.fromDate(DateTime(2024, 12, 25));
        final user = User(
          uid: 'full-uid',
          email: 'full@example.com',
          diopterLeft: '-4.00',
          diopterRight: '-4.25',
          preferredLensBrand: 'CooperVision',
          preferredLensModel: 'MyDay',
          fcmToken: 'some-token',
          lastNotifiedPrice: 34.50,
          createdAt: ts,
        );

        expect(user.uid, 'full-uid');
        expect(user.email, 'full@example.com');
        expect(user.diopterLeft, '-4.00');
        expect(user.diopterRight, '-4.25');
        expect(user.preferredLensBrand, 'CooperVision');
        expect(user.preferredLensModel, 'MyDay');
        expect(user.fcmToken, 'some-token');
        expect(user.lastNotifiedPrice, 34.50);
        expect(user.createdAt, ts);
      });
    });
  });
}
