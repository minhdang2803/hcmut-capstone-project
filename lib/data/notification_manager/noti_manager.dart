import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initAndroid =
        const AndroidInitializationSettings('@drawable/yoga');
    DarwinInitializationSettings initIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    InitializationSettings initializationSettings = InitializationSettings(
      android: initAndroid,
      iOS: initIos,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        priority: Priority.high,
        importance: Importance.high,
        channelShowBadge: true,
        playSound: false,
        icon: "yoga",
        largeIcon: DrawableResourceAndroidBitmap('run'),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
      ),
    );
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

  Future<void> scheduleNotification(String? title, String? body) async {
    AndroidNotificationDetails details = const AndroidNotificationDetails(
        "channelId", "channelName",
        importance: Importance.max, priority: Priority.high);

    NotificationDetails notificationDetails =
        NotificationDetails(android: details);

    await notificationsPlugin.periodicallyShow(
      0,
      title,
      body,
      RepeatInterval.daily,
      notificationDetails,
    );
  }

  Future<void> stopNotification() async => notificationsPlugin.cancelAll();
}
