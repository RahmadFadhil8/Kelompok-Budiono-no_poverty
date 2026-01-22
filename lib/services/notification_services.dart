import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:no_poverty/screens/profile/profile.dart';

class NotificationServices {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static GlobalKey<NavigatorState>? _navigatorKey;

  static Future<void> initialize(
      GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings =
        InitializationSettings(android: androidInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.actionId == 'action_complete_profile') {
          _navigatorKey?.currentState?.push(
            MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            ),
          );
        }
      },
    );

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> showProfileReminderNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'profile_channel',
      'Profile Reminder',
      channelDescription: 'Reminder untuk melengkapi profile',
      importance: Importance.high,
      priority: Priority.high,
      actions: [
        AndroidNotificationAction(
          'action_complete_profile',
          'Lengkapi',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'action_ignore',
          'Abaikan',
          cancelNotification: true,
        ),
      ],
    );

    const notificationDetails =
        NotificationDetails(android: androidDetails);

    await _plugin.show(
      1,
      'Lengkapi Profil Kamu',
      'Profil lengkap membantu pengalaman pengguna lebih baik',
      notificationDetails,
    );
  }

   static Future<void> initializeFcm(GlobalKey<NavigatorState> navKey) async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    // TOKEN
    final token = await messaging.getToken();
    debugPrint("FCM TOKEN: $token");

    // LISTEN TOKEN ROTATION
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint("FCM TOKEN UPDATED: $newToken");
      // TODO: kirim ke backend
    });

    // FOREGROUND
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("FCM FOREGROUND: ${message.notification?.title}");
    });

    // BACKGROUND CLICK
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("FCM CLICKED");
      // navKey.currentState?.push(...)
    });
  }
}
