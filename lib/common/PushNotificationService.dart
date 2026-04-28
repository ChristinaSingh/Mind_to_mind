import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class PushNotificationService {
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<String?> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (Platform.isAndroid) {
      String? token = await messaging.getToken();
      print('My Token: $token');
      return token;
    } else if (Platform.isIOS) {
      await messaging.requestPermission();
      String? apnsToken;
      int attempts = 0;
      const maxAttempts = 5;

      while (apnsToken == null && attempts < maxAttempts) {
        attempts++;
        apnsToken = await messaging.getAPNSToken();
        print("Attempt $attempts: APNS Token: $apnsToken");

        if (apnsToken == null && attempts < maxAttempts) {
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      if (apnsToken == null) {
        print("Failed to get APNS Token after $maxAttempts attempts.");
        return null; // Or handle this case as per your requirements
      }

      String? token = await messaging.getToken();
      print("Firebase Token: $token");
      return token ?? 'Fallback Token'; // Handle token or return a fallback value
    }

    return null;
  }

}
