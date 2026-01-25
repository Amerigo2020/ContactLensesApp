import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin get localNotificationsPlugin =>
      _localNotificationsPlugin;

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'lensguard_channel',
    'LensGuard Notifications',
    channelDescription: 'Notifications for lens reminders and price alerts',
    importance: Importance.max,
    priority: Priority.high,
  );

  static const DarwinNotificationDetails _iOSNotificationDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iOSNotificationDetails,
  );

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  static void onDidReceiveNotificationResponse(
    NotificationResponse response,
  ) {
    // Handle notification tap
    print('Notification tap: ${response.payload}');
  }

  static Future<bool> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    final bool? androidGranted =
        await androidImplementation?.requestNotificationsPermission();

    final bool? iosGranted = await iosImplementation?.requestPermissions(
        alert: true, badge: true, sound: true);

    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  static Future<void> scheduleDailyReminder(
    int id,
    String title,
    String body,
    TimeOfDay time,
  ) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      _notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'reminder_$id',
    );
  }

  static Future<void> scheduleLensReplacementReminder(
    int id,
    String title,
    String body,
  ) async {
    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: 'lens_replacement_$id',
    );
  }

  static Future<void> schedulePriceAlert(
    int id,
    String title,
    String body,
  ) async {
    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails,
      payload: 'price_alert_$id',
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _localNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }

  static Future<void> showImmediateNotification(
    int id,
    String title,
    String body,
  ) async {
    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails,
      payload: 'immediate_$id',
    );
  }
}
