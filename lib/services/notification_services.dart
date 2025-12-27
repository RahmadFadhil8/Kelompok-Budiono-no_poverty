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
}
