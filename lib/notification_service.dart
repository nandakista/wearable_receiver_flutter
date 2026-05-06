import 'package:explore_wearable_flutter_receiver/wearable_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await android?.requestNotificationsPermission();
  }

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(
      android: androidInit,
    );
    await _plugin.initialize(initSettings);
  }

  static Future<void> triggerNotification() async {
    await triggerNotificationForAndroid();
    triggerNotificationToWatch();
  }

  static Future<void> triggerNotificationForAndroid() async {
    const androidDetails = AndroidNotificationDetails(
      'stepper_channel',
      'Stepper Notifications',
      channelDescription: 'Notification for stepper next action',
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.event,
      groupKey: 'stp.app.explorewearable.STEP_GROUP',
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      'Stepper',
      'Next step triggered',
      details,
    );
  }

  static void triggerNotificationToWatch() async {
    WearableService.sendToWatch("Hello dari Flutter 🚀");
  }
}