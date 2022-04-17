import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:routes/view/screens/profile_screen.dart';
import 'package:routes/view/screens/routes/all_routes_map.dart';
import 'package:routes/view/screens/wallet/wallet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as loc ;

import '../../Assistants/assistantMethods.dart';
import '../../Assistants/globals.dart';
import '../../Data/current_data.dart';
import '../../controller/location_controller.dart';
import '../../controller/payment_controller.dart';
import '../../controller/route_map_controller.dart';
import '../../model/location.dart';
import 'Home.dart';
import 'direct_payment.dart';
import 'help_screen.dart';

class  MainScreen extends StatefulWidget {
   int indexOfScreen = 0;
    MainScreen({Key? key,required this.indexOfScreen}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final List<Widget> screens = [
    Home(),
    DirectPayment(),
    WalletScreen(),
    AllRoutesMap(),
    ProfileScreen(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Home();

  int? currentTp = 0;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    locatePosition();
  }
  var location = loc.Location();
  final routeMapController = Get.put(RouteMapController());
  geo.Position? currentPosition;
  double bottomPaddingOfMap = 0;
  final LocationController locationController = Get.find();
  late loc.PermissionStatus _permissionGranted;

  void locatePosition() async {
    loc.Location location = loc.Location.instance;
    geo.Position? currentPos;
    loc.PermissionStatus permissionStatus = await location.hasPermission();
    _permissionGranted = permissionStatus;
    if (_permissionGranted != loc.PermissionStatus.granted) {
      final loc.PermissionStatus permissionStatusReqResult =
      await location.requestPermission();

      _permissionGranted = permissionStatusReqResult;
    }

    setState(() {
      currentScreen = screens[widget.indexOfScreen];
      currentTp = widget.indexOfScreen;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.accessToken = prefs.get('token').toString() ;

    geo.Position position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    print("--------------------position $position");


    trip.startPoint.latitude = position.latitude;
    trip.startPoint.longitude = position.longitude;
    routeMapController.startPointLatLng.value.latitude = position.latitude;
    routeMapController.startPointLatLng.value.longitude = position.longitude;
    initialPoint.latitude = position.latitude;
    initialPoint.longitude = position.longitude;
    initialPointToFirstMap.latitude = position.latitude;
    initialPointToFirstMap.longitude = position.longitude;
    homeMapController!.animateCamera(
        google_maps.CameraUpdate.newCameraPosition(google_maps.CameraPosition(target: google_maps.LatLng(position.latitude,position.longitude,),zoom: 14)));
    currentPosition = geo.Position(longitude: position.longitude, latitude: position.latitude, timestamp: position.timestamp, accuracy: position.accuracy, altitude: position.altitude, heading: position.heading, speed: position.speed, speedAccuracy: position.speedAccuracy);
    locationController.currentLocation.value = LatLng(position.latitude,position.longitude);
    locationController.currentLocationG.value = google_maps.LatLng(position.latitude,position.longitude);
    routeMapController.startPointLatLng.value = LatLng(position.latitude,position.longitude);
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    if(locationController.startAddingPickUp.value ==false){
      var assistantMethods = AssistantMethods();
      String address =
      await assistantMethods.searchCoordinateAddress(currentPosition!,true);
      trip.startPointAddress = address;
      trip.startPoint = LocationModel(latLngPosition.latitude, latLngPosition.longitude);
      locationController.gotMyLocation(true);
      locationController.changePickUpAddress(address);
      locationController.addPickUp.value = true;

    }

  }
  @override
  Widget build(BuildContext context) {
    setState(() {

    });
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [

            routes_color6,
            routes_color,
          ]
          )
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: PageStorage(bucket: bucket, child: currentScreen,

          ),
            bottomNavigationBar: NavigationBar(
                height: 62.0,
                backgroundColor: Colors.white,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                selectedIndex: currentTp!,
                onDestinationSelected: (index) {
                  setState(() {
                    currentScreen = screens[index];
                    currentTp = index;
                  });
                },
                animationDuration: Duration(milliseconds: 1),
                destinations: [


                  NavigationBarTheme(
                      data: NavigationBarThemeData(
                          indicatorColor: Colors.grey.shade200,
                          labelTextStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 12))),
                      child: NavigationDestination(
//                    icon: Icon(Icons.home_outlined,color: Colors.blue[900]),
                        label: 'Home',
                        icon: SvgPicture.asset("${assetsDir}home_svg.svg", width: 20, color: Colors.grey[600],),
                        selectedIcon: SvgPicture.asset("${assetsDir}home_svg.svg", width: 25, color: Colors.blue[900],),
                      )),
                  NavigationBarTheme(
                      data: NavigationBarThemeData(
                          indicatorColor: Colors.grey.shade200,
                          labelTextStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 12))),
                      child: NavigationDestination(
                        icon: SvgPicture.asset("${assetsDir}pay.svg", width: 20, color: Colors.grey[600],),
                        label: 'Pay',
                        selectedIcon: SvgPicture.asset("${assetsDir}pay.svg", width: 25, color: Colors.blue[900],),
                      )),
                  NavigationBarTheme(
                      data: NavigationBarThemeData(
                          indicatorColor: Colors.grey.shade200,
                          labelTextStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 12))),
                      child: NavigationDestination(
                        icon: SvgPicture.asset("${assetsDir}wallet.svg", width: 20, color: Colors.grey[600],),
                        label: 'Wallet',
                        selectedIcon: SvgPicture.asset("${assetsDir}wallet.svg", width: 25, color: Colors.blue[900],),
                      )),
                  NavigationBarTheme(
                      data: NavigationBarThemeData(
                          indicatorColor: Colors.grey.shade200,
                          labelTextStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 12))),
                      child: NavigationDestination(
                        icon: SvgPicture.asset("${assetsDir}routes.svg", width: 20, color: Colors.grey[600],),
                        label: 'Routes',
                        selectedIcon: SvgPicture.asset("${assetsDir}routes.svg", width: 25, color: Colors.blue[900],),
                      )),

                  NavigationBarTheme(
                      data: NavigationBarThemeData(
                          indicatorColor: Colors.grey.shade200,
                          labelTextStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 12))),
                      child: NavigationDestination(
                        icon: SvgPicture.asset("${assetsDir}profile.svg", width: 20, color: Colors.grey[600],),
                        label: 'Profile',
                        selectedIcon: SvgPicture.asset("${assetsDir}profile.svg", width: 25, color: Colors.blue[900],),
                      )),
                ])
        ),
      ),
    );
  }
}
