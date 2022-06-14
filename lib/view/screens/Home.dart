import 'dart:async';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routes/view/screens/routes/all_routes_map.dart';
import '../../Assistants/assistantMethods.dart';
import '../../Assistants/globals.dart';
import '../../main.dart';
import '../../notifications/push_notification_service.dart';
import '../widgets/destination_selection.dart';
import '../widgets/headerDesgin.dart';
import 'destination_selection_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver{
  int navIndex = 3;
  double bottomPaddingOfMap = 0;
  CameraPosition cameraPosition =CameraPosition(target: LatLng(29.370314422169248, 47.98216642044717),zoom: 14.0);
  Completer<GoogleMapController> _controllerMaps = Completer();
  bool showDisSelection = false;

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
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  /// initial message from terminate
  Future<void> initialMessage() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message!.notification !=null){
        print('from init msg ,terminated state---= ${message.notification!.title}');
        print(message.notification!.body);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethods.getCurrentOnLineUserInfo();
    initialMessage();
    requestPermssion();


    ///in forground
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        print('msg on forground ');
        print(event.notification!.title);
        print(event.notification!.body);
      }
    });

    //in onMessageOpenedApp
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null) {
        print("data from message on open : ${message.data['payment_id']}");
        if (message.data['payment_id'] == "s") {
        } else if (message.data['payment_id'] == "f") {}
      }
      if (notification != null && androidNotification != null) {
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
  void locatePosition() async {
    print("on crate map");
    LatLng latLngPosition =
    LatLng(initialPointToFirstMap.latitude, initialPointToFirstMap.longitude);

    CameraPosition cameraPosition =
    new CameraPosition(target: latLngPosition, zoom: 15);
    print("init point $initialPoint");
    homeMapController!.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));
    // var assistantMethods = AssistantMethods();
    // String address = await assistantMethods.searchCoordinateAddress(
    //     position, context, false);
    // print(address);
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = Get.size;
    print(screenSize.height ,);
    print(screenSize.width ,);
    return Container(

      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [

            routes_color6,
            routes_color,
          ]
          )
              ,
        color: Colors.white
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(initialCameraPosition: cameraPosition,
                mapToolbarEnabled: true,

                padding: EdgeInsets.only(top: 100.h,bottom: 160.h),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,

                onMapCreated: (GoogleMapController controller) {
                  _controllerMaps.complete(controller);
                  homeMapController = controller;
                  setState(() {
                    bottomPaddingOfMap = 320.0;
                  });
                  locatePosition();
                },
              ),
            Positioned(
                top: screenSize.height.h *0.7-28.h,
width: screenSize.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(18),topRight: Radius.circular(18)),
                      boxShadow: [
                        BoxShadow(
                          color: routes_color7,
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        )
                      ]
                  ),
                  height: screenSize.height.h *0.2+80.h,
                  width: screenSize.width.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding:  EdgeInsets.only(top: 8.0.h),
                          child: Container(
                            width: 38.0.w,
                            height: 5.0.h,
                            decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Text('where_to_txt'.tr,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[900],fontSize: 22.sp),),
                      ),


                      Center(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 1.h,right: 22.w,left: 22.w),
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: routes_color7.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 8.0.w,),
                                SvgPicture.asset("assets/icons/search.svg", width: 28.w, color: Colors.grey[900],),
                                SizedBox(width: 8.0.w,),
                                Text('enter_your_destination_txt'.tr,style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey[500]),)
                              ],
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 0.0,
                  width: screenSize.width,

                  child: SizedBox(
                      height: screenSize.height*0.1.h,
                      width: screenSize.width.w,
                      child: Header(screenSize))),
            ],
          ),


        ),
      ),
    );
  }

}