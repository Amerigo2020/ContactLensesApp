import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lensguard/providers/user_provider.dart';
import 'package:lensguard/models/user.dart';

/// Helper to build a [User] with only the fields relevant to provider tests.
///
/// Defaults [uid] to `'test-uid'` and [email] to `'test@example.com'`.
User _makeUser({
  String uid = 'test-uid',
  String email = 'test@example.com',
  String? diopterLeft,
  String? diopterRight,
  String? preferredLensBrand,
  String? preferredLensModel,
}) {
  return User(
    uid: uid,
    email: email,
    diopterLeft: diopterLeft,
    diopterRight: diopterRight,
    preferredLensBrand: preferredLensBrand,
    preferredLensModel: preferredLensModel,
  );
}

void main() {
  // Initialize the binding and set up Firebase mocks before any tests run.
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  late UserProvider provider;

  setUp(() async {
    await Firebase.initializeApp();
    provider = UserProvider();
  });

  // ---------------------------------------------------------------------------
  // Initial state
  // ---------------------------------------------------------------------------
  group('initial state', () {
    test('currentUser is null', () {
      expect(provider.currentUser, isNull);
    });

    test('isLoading is false', () {
      expect(provider.isLoading, isFalse);
    });

    test('error is null', () {
      expect(provider.error, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // hasCompletedOnboarding
  // ---------------------------------------------------------------------------
  group('hasCompletedOnboarding', () {
    test('returns false when currentUser is null', () {
      expect(provider.hasCompletedOnboarding, isFalse);
    });

    test('returns true when all three onboarding fields are set', () {
      provider.currentUserForTest = _makeUser(
        diopterLeft: '-2.00',
        diopterRight: '-1.75',
        preferredLensBrand: 'Acuvue',
      );

      expect(provider.hasCompletedOnboarding, isTrue);
    });

    test('returns false when diopterLeft is missing', () {
      provider.currentUserForTest = _makeUser(
        diopterRight: '-1.75',
        preferredLensBrand: 'Acuvue',
      );

      expect(provider.hasCompletedOnboarding, isFalse);
    });

    test('returns false when diopterRight is missing', () {
      provider.currentUserForTest = _makeUser(
        diopterLeft: '-2.00',
        preferredLensBrand: 'Acuvue',
      );

      expect(provider.hasCompletedOnboarding, isFalse);
    });

    test('returns false when preferredLensBrand is missing', () {
      provider.currentUserForTest = _makeUser(
        diopterLeft: '-2.00',
        diopterRight: '-1.75',
      );

      expect(provider.hasCompletedOnboarding, isFalse);
    });

    test('returns false when all three fields are missing', () {
      provider.currentUserForTest = _makeUser();

      expect(provider.hasCompletedOnboarding, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // getExpectedDuration
  // ---------------------------------------------------------------------------
  group('getExpectedDuration', () {
    test('returns 30 (default) when currentUser is null', () {
      expect(provider.getExpectedDuration(), 30);
    });

    test('returns 30 (default) when preferredLensModel is null', () {
      provider.currentUserForTest = _makeUser();
      expect(provider.getExpectedDuration(), 30);
    });

    // Daily lenses
    test('returns 1 for model containing "daily" (case-insensitive)', () {
      provider.currentUserForTest = _makeUser(
        preferredLensModel: 'Acuvue Oasys Daily',
      );
      expect(provider.getExpectedDuration(), 1);
    });

    test('returns 1 for model containing "Daily" (mixed case)', () {
      provider.currentUserForTest = _makeUser(
        preferredLensModel: 'Daily Disposable',
      );
      expect(provider.getExpectedDuration(), 1);
    });

    test('returns 1 for model containing "1-day"', () {
      provider.currentUserForTest = _makeUser(
        preferredLensModel: 'Acuvue 1-Day Moist',
      );
      expect(provider.getExpectedDuration(), 1);
    });

    test('returns 1 for model containing "1-Day" (mixed case)', () {
      provider.currentUserForTest = _makeUser(
        preferredLensModel: '1-Day TruEye',
      );
      expect(provider.getExpectedDuration(), 1);
    });

    // Bi-weekly lenses
    test('returns 14 for model containing "14"', () {
      provider.currentUserForTest = _makeUser(
        preferredLensModel: 'Acuvue Oasys 14-Day',
      );
      expect(provider.getExpectedDuration(), 14);
    });

    test('returns 14 for model containing "2-week"', () {
      provider.currentUserForTest = _makeUser(
        preferredLensModel: 'Biofinity 2-Week',
      );
      expect(provider.getExpectedDuration(), 14);
    });

    // Monthly lenses
    test('returns 30 for model containing "30"', () {
      provider.currentUserForTest = _makeUser(
        preferredLensModel: 'Air Optix 30-Day',
      );
      expect(provider.getExpectedDuration(), 30);
    });

    test('returns 30 for model containing "monthly"', () {
      provider.currentUserForTest = _makeUser(
        preferredLensModel: 'Air Optix Monthly',
      );
      expect(provider.getExpectedDuration(), 30);
    });

    // Weekly lenses
    test('returns 7 for model containing "weekly"', () {
      provider.currentUserForTest = _makeUser(
        preferredLensModel: 'Some Weekly Lens',
      );
      expect(provider.getExpectedDuration(), 7);
    });

    // Unknown model falls back to default
    test('returns 30 (default) for unrecognized model string', () {
      provider.currentUserForTest = _makeUser(
        preferredLensModel: 'Unknown Model XYZ',
      );
      expect(provider.getExpectedDuration(), 30);
    });
  });

  // ---------------------------------------------------------------------------
  // getDaysWorn
  //
  // Known limitation: _getStartDate() is a stub that always returns null, so
  // getDaysWorn() always returns 0 regardless of whether a user is set.  These
  // tests document that current behaviour.  Once _getStartDate() is backed by
  // real data, these tests should be updated to cover the date-difference logic.
  // ---------------------------------------------------------------------------
  group('getDaysWorn', () {
    test('returns 0 when currentUser is null', () {
      expect(provider.getDaysWorn(), 0);
    });

    test('returns 0 when currentUser is set (start date stub returns null)',
        () {
      provider.currentUserForTest = _makeUser(
        diopterLeft: '-2.00',
        diopterRight: '-1.75',
        preferredLensBrand: 'Acuvue',
        preferredLensModel: 'Daily',
      );

      // _getStartDate() always returns null in the current implementation,
      // so getDaysWorn() short-circuits to 0.
      expect(provider.getDaysWorn(), 0);
    });
  });

  // ---------------------------------------------------------------------------
  // clearUser
  // ---------------------------------------------------------------------------
  group('clearUser', () {
    test('sets currentUser to null', () {
      provider.currentUserForTest = _makeUser();
      expect(provider.currentUser, isNotNull);

      provider.clearUser();

      expect(provider.currentUser, isNull);
    });

    test('notifies listeners', () {
      provider.currentUserForTest = _makeUser();

      var notified = false;
      provider.addListener(() => notified = true);

      provider.clearUser();

      expect(notified, isTrue);
    });

    test('sets hasCompletedOnboarding to false after clearing', () {
      provider.currentUserForTest = _makeUser(
        diopterLeft: '-2.00',
        diopterRight: '-1.75',
        preferredLensBrand: 'Acuvue',
      );
      expect(provider.hasCompletedOnboarding, isTrue);

      provider.clearUser();

      expect(provider.hasCompletedOnboarding, isFalse);
    });
  });
}
