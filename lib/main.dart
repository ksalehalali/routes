
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:myfatoorah_flutter/utils/MFCountry.dart';
import 'package:myfatoorah_flutter/utils/MFEnvironment.dart';
import 'package:routes/Assistants/globals.dart';
import 'Assistants/assistantMethods.dart';
import 'Data/current_data.dart';
import 'controller/lang_controller.dart';
import 'controller/location_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart' as loc ;

import 'controller/payment_controller.dart';
import 'controller/start_up_controller.dart';
import 'controller/transactions_controller.dart';
import 'controller/trip_controller.dart';
import 'localization/localization.dart';
import 'model/location.dart';


Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller =Get.putAsync(() async => LocationController(),permanent: true);
  final paymentController =Get.putAsync(() async => PaymentController(),permanent: true);
  final tripsController =Get.putAsync(() async => TripController(),permanent: true);
  final transactionsController =Get.putAsync(() async => TransactionsController(),permanent: true);
  final langController =Get.putAsync(() async => LangController(),permanent: true);
  MFSDK.init( 'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL',MFCountry.KUWAIT,MFEnvironment.TEST);
  await GetStorage.init();

  runApp( GetMaterialApp(
    locale: Locale('en'),
    fallbackLocale: Locale('en'),
    translations: Localization(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(),
    home:  MYApp()
  ),);
}
class MYApp extends StatefulWidget {
  const MYApp({Key? key}) : super(key: key);

  @override
  _MYAppState createState() => _MYAppState();
}

class _MYAppState extends State<MYApp> with TickerProviderStateMixin {
  final startUpController = Get.put(StartUpController());
  late final AnimationController _controller;
  static const locationChannel = MethodChannel('location');
  final arguments = {'name':'khaled'};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startUpController.fetchUserLoginPreference();
    getLocation();
    Timer(Duration(milliseconds: 100),() {
      getCurrentLocationFromChannel();
    });
  }
  var assistantMethods = AssistantMethods();

  Future getCurrentLocationFromChannel()async{
    var value;
    try{
      value = await locationChannel.invokeMethod("getCurrentLocation",arguments);
      var lat = value['lat'];
      var lng = value['lng'];
      if(lng >0.0){
        print("value of url , main :: ${value.toString()}");
        locationController.changePickUpAddress('Current Location');
        currentPosition = geo.Position(latitude:lat ,longitude:lng ,accuracy:0.0 ,altitude:lat ,speedAccuracy:0.0 ,heading:0.0 ,timestamp:DateTime.now(),speed:0.0 ,);
        String address =
        await assistantMethods.searchCoordinateAddress(currentPosition!,true);
        trip.startPointAddress = address;
        trip.startPoint = LocationModel(lat, lng);
        locationController.gotMyLocation(true);
        locationController.changePickUpAddress(address);
        locationController.addPickUp.value = true;
      }else{
        print('Wrong coordinates ###');
      }

    }catch(err){
      print(err);
    }

  }
  var location = loc.Location();
  geo.Position? currentPosition;
  double bottomPaddingOfMap = 0;
  late loc.PermissionStatus _permissionGranted;
  final LocationController locationController = Get.find();

  Future getLocation()async{
    loc.Location location = loc.Location.instance;

    geo.Position? currentPos;
    loc.PermissionStatus permissionStatus = await location.hasPermission();
    _permissionGranted = permissionStatus;
    if (_permissionGranted != loc.PermissionStatus.granted) {
      final loc.PermissionStatus permissionStatusReqResult =
      await location.requestPermission();

      _permissionGranted = permissionStatusReqResult;
    }
    loc.LocationData loca = await location.getLocation();
    print('loca ...............  $loca');

    if(loca.latitude !=null){
      locationController.changePickUpAddress('Current Location');
      currentPosition = geo.Position(latitude:loca.latitude! ,longitude:loca.longitude! ,accuracy:loca.accuracy! ,altitude:loca.altitude! ,speedAccuracy:loca.speedAccuracy! ,heading:loca.heading! ,timestamp:DateTime.now(),speed:loca.speed! ,);
      String address =
      await assistantMethods.searchCoordinateAddress(currentPosition!,true);
      trip.startPointAddress = address;
      trip.startPoint = LocationModel(loca.latitude!, loca.longitude!);
      locationController.gotMyLocation(true);
      locationController.changePickUpAddress(address);
      locationController.addPickUp.value = true;
    }

    geo.Position position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    locationController.gotMyLocation(true);
    locationController.addPickUp.value = true;
    locationController.changePickUpAddress('Current Location');

    print("--------------------========== position controller $position");
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    String address =
    await assistantMethods.searchCoordinateAddress(position,true);
    trip.startPointAddress = address;
    trip.startPoint = LocationModel(latLngPosition.latitude, latLngPosition.longitude);
    locationController.gotMyLocation(true);
    locationController.changePickUpAddress(address);
    locationController.addPickUp.value = true;

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [

            routes_color2,
            routes_color,
          ]
          )
          ,
          color: Colors.white
      ),
      child: SafeArea(
        left: false,
        right: false,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [

                routes_color6,
                routes_color,
              ]
              )
              ,
              color: Colors.white
          ),
          child: Image.asset('assets/animation/ROUTES-Animated Logo.gif',fit: BoxFit.fill,),
          // child: Lottie.asset(
          //   'assets/animation/17314-bus.json',
          //   height: 122,
          //   width: 122,
          //   controller: _controller,
          //   onLoaded: (composition) {
          //     // Configure the AnimationController with the duration of the
          //     // Lottie file and start the animation.
          //     _controller..duration = composition.duration
          //       ..forward();
          //   },
          // ),
        ),
      ),
    );
  }
}

