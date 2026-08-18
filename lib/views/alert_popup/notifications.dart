import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Top-level background message handler (App close/background hone par kaam karta hai)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.messageId}");
}

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');
      await _firebaseMessaging.subscribeToTopic('emergency_alerts');
      print("Subscribed to 'emergency_alerts' topic successfully!");
    } else {
      print('User declined or accepted provisional permission');
    }

    const AndroidInitializationSettings androidInitSettings =
    AndroidInitializationSettings('@drawable/launch_background');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(
        title: message.notification?.title ?? "Emergency SOS Alert!",
        body: message.notification?.body ?? "Someone near you needs immediate help!",
      );
    });
  }

  static Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'sos_channel_id',
      'SOS Emergency Alerts',
      channelDescription: 'High priority notifications for SOS emergency alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
    );
  }
}