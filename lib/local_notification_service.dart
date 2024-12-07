import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static onTap(NotificationResponse notificationResponse) {}

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: onTap,
        onDidReceiveBackgroundNotificationResponse: onTap);
  }

  static Future<void> checkNotificationStatus() async {
    bool isNotificationEnabled = await checkIfNotificationIsEnabled();
    if (!isNotificationEnabled) {
      requestNotificationPermission();
    } else {
      debugPrint("Notifications are enabled.");
    }
  }

  static Future<bool> checkIfNotificationIsEnabled() async {
    PermissionStatus permissionStatus = await Permission.notification.status;

    if (permissionStatus.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  // Request to enable notifications
  static Future<void> requestNotificationPermission() async {
    PermissionStatus permissionStatus = await Permission.notification.request();

    if (permissionStatus.isGranted) {
      debugPrint("Notification permission granted.");
    } else if (permissionStatus.isDenied) {
      debugPrint("Notification permission denied.");
    } else if (permissionStatus.isPermanentlyDenied) {
      debugPrint("Notification permission permanently denied.");
    }
  }

  // Instant Notifications
  static void showInstantNotification(
      {required int id, required String title, required String body}) async {
    await checkNotificationStatus();
    AndroidNotificationDetails android = const AndroidNotificationDetails(
      'id 1',
      'instant notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = NotificationDetails(
      android: android,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: "Payload Data",
    );
  }

  // Scheduled Notifications
  static void showScheduledNotification(
      {required int id,
        required String title,
        required String body,
        required DateTime dateTime}) async {
    await checkNotificationStatus();
    tz.initializeTimeZones();

    AndroidNotificationDetails android = const AndroidNotificationDetails(
      'id 2',
      'scheduled notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = NotificationDetails(
      android: android,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      details,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Clear All Notifications
  static Future<void> clearAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // Pending Notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Active Notifications
  static Future<List<ActiveNotification>> getActiveNotifications() async {
    return await flutterLocalNotificationsPlugin.getActiveNotifications();
  }

  // Clear Individual Notification
  static Future<void> clearNotificationById(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
