import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:no_poverty/main.dart';
import 'package:no_poverty/screens/home/customer/account_verification.dart';
import 'package:no_poverty/screens/profile/profile.dart';

class NotificationServices {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null, 
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel',
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
          defaultColor: Color(0xFF2196F3)
        )
      ],
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      }
    );

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod
    );
  }

  static Future<void> showNotification({
      required final String title,
      required final String body,
      final String? summary,
      final Map<String, String>? payload,
      final ActionType actionType = ActionType.Default,
      final NotificationLayout notificationLayout = NotificationLayout.Default,
      final NotificationCategory? category,
      final String? bigPicture,
      final List<NotificationActionButton>? actionButtons,
      final bool schedule = false,
      final Duration? interval,
    }) async {
      assert(!schedule || (schedule && interval !=null));

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000, 
          channelKey: "basic_channel",
          title: title,
          body: body,
          actionType: actionType,
          notificationLayout: notificationLayout,
          summary: summary,
          category: category,
          payload: payload,
          bigPicture: bigPicture,
        ),
        actionButtons: actionButtons,
        schedule: schedule? NotificationInterval(interval: interval, timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(), preciseAlarm: true,) : null,
      );
    }
    
  static Future<void> onNotificationCreatedMethod(
        ReceivedNotification receivedNotification) async {
      debugPrint('onNotificationCreatedMethod');
    }

    static Future<void> onNotificationDisplayedMethod(
        ReceivedNotification receivedNotification) async {
      debugPrint('onNotificationDisplayedMethod');
    }

    static Future<void> onDismissActionReceivedMethod(
        ReceivedAction receivedAction) async {
      debugPrint('onDismissActionReceivedMethod');
    }

    static Future<void> onActionReceivedMethod(
        ReceivedAction receivedAction) async {
      debugPrint('onActionReceivedMethod');
      final payload = receivedAction.payload ?? {};
      if (payload["navigate"] == "true") {
        MyApp.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ProfileScreen(), 
          )
        );
      }
    }


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
    final token = await messaging.getToken();
    debugPrint("FCM TOKEN: $token");

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint("FCM TOKEN UPDATED: $newToken");
    });

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("FCM FOREGROUND: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("FCM CLICKED");
    });
  }
}