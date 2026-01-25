import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/user.dart';

/// Provider for user profile data and lens tracking
class UserProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCompletedOnboarding =>
      _currentUser?.diopterLeft != null &&
      _currentUser?.diopterRight != null &&
      _currentUser?.preferredLensBrand != null;

  /// Load user data from Firestore
  Future<void> loadUser(String uid) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _firestoreService.getUser(uid);
    } catch (e) {
      _setError(e.toString());
      debugPrint('Error loading user: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Stream user data (real-time updates)
  void streamUser(String uid) {
    _firestoreService.streamUser(uid).listen(
      (user) {
        _currentUser = user;
        notifyListeners();
      },
      onError: (error) {
        _setError(error.toString());
        debugPrint('Error streaming user: $error');
      },
    );
  }

  /// Update user prescription
  Future<void> updatePrescription({
    required String uid,
    required String diopterLeft,
    required String diopterRight,
    required String lensBrand,
    required String lensModel,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _firestoreService.updateUserProfile(
        uid,
        diopterLeft: diopterLeft,
        diopterRight: diopterRight,
        preferredLensBrand: lensBrand,
        preferredLensModel: lensModel,
      );

      // Update local state
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          diopterLeft: diopterLeft,
          diopterRight: diopterRight,
          preferredLensBrand: lensBrand,
          preferredLensModel: lensModel,
        );
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Start a new lens pair
  Future<void> startNewLensPair(String uid) async {
    _setLoading(true);
    _clearError();

    try {
      await _firestoreService.startNewLensPair(uid);
      // Reload user to get updated start date
      await loadUser(uid);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Get current lens wear duration
  Future<Duration> getCurrentWearDuration(String uid) async {
    try {
      return await _firestoreService.getCurrentLensWearDuration(uid);
    } catch (e) {
      debugPrint('Error getting wear duration: $e');
      return Duration.zero;
    }
  }

  /// Calculate days worn
  int getDaysWorn() {
    if (_currentUser == null) return 0;

    // This will be populated from Firestore query
    final startDate = _getStartDate();
    if (startDate == null) return 0;

    final now = DateTime.now();
    return now.difference(startDate).inDays;
  }

  /// Get expected lens duration in days based on model
  int getExpectedDuration() {
    if (_currentUser?.preferredLensModel == null) return 30;

    final model = _currentUser!.preferredLensModel!.toLowerCase();

    if (model.contains('daily') || model.contains('1-day')) {
      return 1;
    } else if (model.contains('14') || model.contains('2-week')) {
      return 14;
    } else if (model.contains('30') || model.contains('monthly')) {
      return 30;
    } else if (model.contains('weekly')) {
      return 7;
    }

    return 30; // Default to monthly
  }

  /// Get lens pair start date
  DateTime? _getStartDate() {
    // In a real implementation, this would come from Firestore
    // For now, we'll add this field to the User model
    // Placeholder: return null if not set
    return null;
  }

  /// Clear user data (on sign out)
  void clearUser() {
    _currentUser = null;
    notifyListeners();
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
