import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging  = FirebaseMessaging.instance;

  Future initialize(context)async{
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage =message.data['payment_id'];
      if(routeFromMessage !=null){
        print('routeFromMessage ${routeFromMessage}');
      }
      print('  ====== route $routeFromMessage');
      print('from initialize onMessage');

    });

  }

  Future<String?> getToken()async{
    String? token = await firebaseMessaging.getToken();
    var newToken =  firebaseMessaging.onTokenRefresh;
    if(newToken != null){
      print('new token $newToken');
    }
    //driverRef.child(currentFirebaseUser.uid).child("token").set(token);
    print("this is token : ${token}");
    //user.fcmToken = token;
    firebaseMessaging.subscribeToTopic("allusers");
  }
  //
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize2() {
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    // _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? route) async{
    //   if(route != null){
    //     //Navigator.of(context).pushNamed(route);
    //   }
    // });
  }

  static void display(RemoteMessage message) async {

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "routes.khaled",
            "routes channel",
            importance: Importance.max,
            priority: Priority.high,
          ),iOS: DarwinNotificationDetails()
      );


      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }


}