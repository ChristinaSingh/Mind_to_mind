import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/routes/app_pages.dart';
import 'package:mindtomind/common/local_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/PushNotificationService.dart';
import '../../../../main.dart';
import '../../../data/apis/api_constants/api_key_constants.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Platform.isAndroid) {
      notificationSetup();
    } else {
      if (Platform.isIOS) {
        setupInteractedMessage();
      }
    }
    manageSession();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void manageSession() async {
    Timer(
      const Duration(seconds: 3),
      () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print("USER_ID:::::::::::${prefs.getString(ApiKeyConstants.userId)}");
        if (prefs.getString(ApiKeyConstants.userId) != null) {
          LocalData.userType =
              prefs.getString(ApiKeyConstants.type) ?? 'Mentee';
          LocalData.userId = prefs.getString(ApiKeyConstants.userId) ?? '';
          if (prefs.getString(ApiKeyConstants.type) == 'Mentor') {
            Get.offAllNamed(Routes.PROVIDER_NAV_BAR);
          } else {
            if (LocalData.showUserScreen) {
              Get.offAllNamed(Routes.NAV_BAR);
            } else {
              Get.offAllNamed(Routes.PROVIDER_NAV_BAR);
            }
          }
        } else {
          Get.offAllNamed(Routes.LET_GET_START);
        }
      },
    );
  }

  void notificationSetup() {
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print('Push Notification for android in foreground.......');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //   channel.description,
                color: Colors.white,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
      if (message != null) {
        print('Notification aaaaaaaaaaaaaaaaaaa ::::::::::::::::::::::');
        print(
            'Notification aaaaaaaaaaaaaaaaaaa :::::::::::::::::::::: ${notification!.title}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('Notification pressed:-');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print('Notification pressed:-');
        print('Notification pressed:-${notification.body!}');
        // await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
        // Get.toNamed(Routes.NOTIFICATIONS);
      }
    });
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    PushNotificationService.getToken();
  }

  Future<void> setupInteractedMessage() async {
    // Get device token...
    PushNotificationService.getToken();
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {});

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    print('Notification pressed ios:-');
    print('Notification title:-${notification!.title}');
    print('Notification body:-${notification.body}');
    // await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
    // Get.toNamed(Routes.NOTIFICATIONS);
  }
}
