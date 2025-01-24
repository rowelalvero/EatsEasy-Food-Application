import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HelperNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static Future<void> initialize(
      ) async {
    var androidInitialize = const AndroidInitializationSettings(
        'ic_launcher');
    var iOSInitialize = DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
        initializationsSettings, onDidReceiveNotificationResponse: (data) {}
      );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );


  }
  static Future<void> showNotification(String title, String body) async {

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'dbfood', 'dbfood', playSound: false,
      importance: Importance.max, priority: Priority.max,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: "emoty");
  }
}