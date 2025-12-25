import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:no_poverty/main.dart';
import 'package:no_poverty/screens/home/customer/detailJob.dart';

class NotificationService {

  static Future<void>  initialize() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: "basic_channel", 
        channelName: "Basic Notification", 
        defaultColor: Colors.lightBlueAccent,
        channelShowBadge: true,
        channelDescription: "Notification with Action", 
        importance: NotificationImportance.High),
    ]);
  }

  static Future<void> requestPermission() async{
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed){
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static void setListeners(){
    AwesomeNotifications().setListeners(onActionReceivedMethod: onActionReceived,);
  }

  static Future<void> showDetailJobApplied({
    required String jobId,
  }) async {
    await AwesomeNotifications().createNotification(content: 
    NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      channelKey: "basic_channel", 
      title: "Job berhasil dilamar",
      body: "Klik detail untuk melihat informasi job",
      payload: {"jobId": jobId},

    ),
    actionButtons: [
      NotificationActionButton(
        key: "Detail" , 
        label: "Detail", color: Colors.indigo)
    ]
  );
  }

  static Future<void> onActionReceived( ReceivedAction action)async {
    final jobId = action.payload?["jobId"];

    if (action.buttonKeyPressed == "Detail" && jobId != null) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => DetailJob(JobId: jobId)));
    }
  }


}