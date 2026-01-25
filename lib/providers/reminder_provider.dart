import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../utils/app_config.dart';

/// Provider for reminder settings and notification management
class ReminderProvider with ChangeNotifier {
  static const String _morningEnabledKey = 'morning_reminder_enabled';
  static const String _eveningEnabledKey = 'evening_reminder_enabled';
  static const String _morningHourKey = 'morning_reminder_hour';
  static const String _morningMinuteKey = 'morning_reminder_minute';
  static const String _eveningHourKey = 'evening_reminder_hour';
  static const String _eveningMinuteKey = 'evening_reminder_minute';

  bool _morningReminderEnabled = true;
  bool _eveningReminderEnabled = true;
  TimeOfDay _morningTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 22, minute: 0);
  bool _isLoading = false;
  bool _hasPermission = false;

  // Getters
  bool get morningReminderEnabled => _morningReminderEnabled;
  bool get eveningReminderEnabled => _eveningReminderEnabled;
  TimeOfDay get morningTime => _morningTime;
  TimeOfDay get eveningTime => _eveningTime;
  bool get isLoading => _isLoading;
  bool get hasPermission => _hasPermission;

  /// Initialize reminder settings from SharedPreferences
  Future<void> init() async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();

      _morningReminderEnabled = prefs.getBool(_morningEnabledKey) ?? true;
      _eveningReminderEnabled = prefs.getBool(_eveningEnabledKey) ?? true;

      final morningHour = prefs.getInt(_morningHourKey) ?? 8;
      final morningMinute = prefs.getInt(_morningMinuteKey) ?? 0;
      final eveningHour = prefs.getInt(_eveningHourKey) ?? 22;
      final eveningMinute = prefs.getInt(_eveningMinuteKey) ?? 0;

      _morningTime = TimeOfDay(hour: morningHour, minute: morningMinute);
      _eveningTime = TimeOfDay(hour: eveningHour, minute: eveningMinute);

      // Check notification permission
      _hasPermission = await _checkPermission();
    } catch (e) {
      debugPrint('Error initializing reminder settings: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Check if notification permission is granted
  Future<bool> _checkPermission() async {
    // This is a simplified check - actual implementation would query notification settings
    return true; // Assume granted for now
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      final granted = await NotificationService.requestPermissions();
      _hasPermission = granted;
      notifyListeners();
      return granted;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  /// Set morning reminder time
  Future<void> setMorningTime(TimeOfDay time) async {
    _morningTime = time;
    await _saveSettings();

    if (_morningReminderEnabled) {
      await _scheduleMorningReminder();
    }

    notifyListeners();
  }

  /// Set evening reminder time
  Future<void> setEveningTime(TimeOfDay time) async {
    _eveningTime = time;
    await _saveSettings();

    if (_eveningReminderEnabled) {
      await _scheduleEveningReminder();
    }

    notifyListeners();
  }

  /// Toggle morning reminder on/off
  Future<void> toggleMorningReminder(bool enabled) async {
    _morningReminderEnabled = enabled;
    await _saveSettings();

    if (enabled) {
      await _scheduleMorningReminder();
    } else {
      await NotificationService.cancelNotification(AppConfig.morningReminderId);
    }

    notifyListeners();
  }

  /// Toggle evening reminder on/off
  Future<void> toggleEveningReminder(bool enabled) async {
    _eveningReminderEnabled = enabled;
    await _saveSettings();

    if (enabled) {
      await _scheduleEveningReminder();
    } else {
      await NotificationService.cancelNotification(AppConfig.eveningReminderId);
    }

    notifyListeners();
  }

  /// Schedule morning reminder
  Future<void> _scheduleMorningReminder() async {
    try {
      await NotificationService.scheduleDailyReminder(
        AppConfig.morningReminderId,
        'Time to insert your lenses',
        'Don\'t forget to put in your contact lenses!',
        _morningTime,
      );
    } catch (e) {
      debugPrint('Error scheduling morning reminder: $e');
    }
  }

  /// Schedule evening reminder
  Future<void> _scheduleEveningReminder() async {
    try {
      await NotificationService.scheduleDailyReminder(
        AppConfig.eveningReminderId,
        'Time to remove your lenses',
        'Remember to take out your contact lenses before bed!',
        _eveningTime,
      );
    } catch (e) {
      debugPrint('Error scheduling evening reminder: $e');
    }
  }

  /// Schedule all enabled reminders
  Future<void> scheduleAllReminders() async {
    if (_morningReminderEnabled) {
      await _scheduleMorningReminder();
    }
    if (_eveningReminderEnabled) {
      await _scheduleEveningReminder();
    }
  }

  /// Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(_morningEnabledKey, _morningReminderEnabled);
      await prefs.setBool(_eveningEnabledKey, _eveningReminderEnabled);
      await prefs.setInt(_morningHourKey, _morningTime.hour);
      await prefs.setInt(_morningMinuteKey, _morningTime.minute);
      await prefs.setInt(_eveningHourKey, _eveningTime.hour);
      await prefs.setInt(_eveningMinuteKey, _eveningTime.minute);
    } catch (e) {
      debugPrint('Error saving reminder settings: $e');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
