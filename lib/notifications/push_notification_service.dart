import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //request permitions
  requestPermssion() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  ///on backGround
  /// To verify things are working, check out the native platform logs.
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // description
      importance: Importance.high,
      playSound: true);

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('message :: $message');
    print('Handling a background message ${message.messageId}');
    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;

    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification!.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  /// initial message from terminate
  Future<void> initialMessage(BuildContext context) async {
    await requestPermssion();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message!.notification != null) {
        print(
            'from init msg ,terminated state---= ${message.notification!.title}');
        print(message.notification!.body);
      }
    });

    ///in forground
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        print('msg on forground ');
        print(event.notification!.title);
        print(event.notification!.body);

        onDidReceiveLocalNotification(id:0,title: event.notification!.title,body: event.notification!.body,payload: 'p',context: context);
      }
    });



    ///
    //in onMessageOpenedApp
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null) {
        print("data from message on open : ${message.data['payment_id']}");
        if (message.data['payment_id'] == "s") {
        } else if (message.data['payment_id'] == "f") {}
      }
      if (notification != null && androidNotification != null && Platform.isAndroid) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("from terminate ${notification.body!}"),
                    ],
                  ),
                ),
              );
            });
      }
    });
  }
//
  void onDidReceiveLocalNotification(
      {int? id, String? title, String? body, String? payload,BuildContext? context}) async {
    ///
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon',);
    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', 'High Importance Notifications',
        description: 'this channel desc', importance: Importance.max);
    flutterLocalNotificationsPlugin.show(0, title, body, NotificationDetails(
        android: AndroidNotificationDetails(channel.id,channel.name,channelDescription: channel.description),
        iOS:const IOSNotificationDetails()
    ));
    //display a dialog with the notification details, tap ok to go to another page
    Platform.isAndroid ?showDialog(
      context: context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();

              print('notification ------------');
            },
          )
        ],
      ),
    ):Container();
  }

}