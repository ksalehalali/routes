import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Assistants/assistantMethods.dart';
import '../../../Assistants/globals.dart';
import '../../../Data/current_data.dart';
import '../../../controller/all_routes_controller.dart';
import '../../../controller/location_controller.dart';
import '../../../controller/payment_controller.dart';
import '../../../controller/route_map_controller.dart';
import '../destination_selection_screen.dart';
import '../main_screen.dart';
import 'filter_local_list_page.dart';

class AllRoutesMap extends StatefulWidget {
  const AllRoutesMap({Key? key}) : super(key: key);

  @override
  _AllRoutesMapState createState() => _AllRoutesMapState();
}
google_maps.GoogleMapController? homeMapController;

class _AllRoutesMapState extends State<AllRoutesMap> {
  Completer<google_maps.GoogleMapController> _controllerMaps = Completer();
  double bottomPaddingOfMap = 0;
  final RouteMapController routeMapController = Get.find();
  final LocationController locationController = Get.find();
  final allRouteController = Get.put(AllRoutes());
  late final MapController mapController;

  PanelController panelController = PanelController();
  late final StreamSubscription<MapEvent> mapEventSubscription;
  int _eventKey = 0;
  google_maps.CameraPosition _inialLoc = google_maps.CameraPosition(
    target: google_maps.LatLng(29.370314422169248, 47.98216642044717),
    zoom: 14.4746,
  );

  String? addressText;
  bool getingAddress = true;
  bool showMap = false;
  var assistantMethods = AssistantMethods();
  Position? positionFromPin;

  void locatePosition() async {
    print("on crate map");
    Position position = Position(longitude:
    initialPoint.longitude, latitude: initialPoint.latitude , timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1) ;
    google_maps.LatLng latLngPosition =
    google_maps.LatLng(initialPoint.latitude, initialPoint.longitude);

    google_maps.CameraPosition cameraPosition =
    new google_maps.CameraPosition(target: latLngPosition, zoom: 15);
    print("init point $initialPoint");
    homeMapController!.animateCamera(
        google_maps.CameraUpdate.newCameraPosition(cameraPosition));
    var assistantMethods = AssistantMethods();
    String address = await assistantMethods.searchCoordinateAddress(
        position, false);
    print(address);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = Get.size;
    return Obx(()=> Scaffold(
        body:  Stack(children: [
          google_maps.GoogleMap(
              initialCameraPosition: _inialLoc,
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              padding: EdgeInsets.only(bottom: 186.h, top: 30.h),
              markers: {...allRouteController.markersStations},
              // {
              //
              //       google_maps.Marker(
              //       markerId: google_maps.MarkerId('center'),
              //       position: locationController.currentLocationG.value,
              //       onTap: () {
              //         print('object');
              //       },
              //       icon: google_maps.BitmapDescriptor.defaultMarker)
              //
              // },
              polylines: {
                ...allRouteController.routePolyLine

              },
              onCameraMoveStarted: () {},
              onCameraMove: (camera)async {

                locationController.updatePinPos(
                    camera.target.latitude, camera.target.longitude);
                positionFromPin = Position(
                  longitude: camera.target.longitude,
                  latitude: camera.target.latitude,
                  speedAccuracy: 1.0,
                  altitude: camera.target.latitude,
                  speed: 1.0,
                  heading: 1.0,
                  timestamp: DateTime.now(),
                  accuracy: 1.0,
                );

                addressText =
                await assistantMethods.searchCoordinateAddress(
                    positionFromPin!,false);
                getingAddress = true;
                if (locationController.addDropOff.value == true &&
                    locationController.addPickUp.value == true) {
                } else {
                  if (locationController.startAddingPickUp.value == true) {
                    trip.startPointAddress = addressText!;
                  } else {
                    trip.endPointAddress = addressText!;

                  }
                }
              },
              onMapCreated: (google_maps.GoogleMapController controller) {
                _controllerMaps.complete(controller);
                homeMapController = controller;
                setState(() {
                  bottomPaddingOfMap = 320.0;
                });
                locatePosition();
              },
            ),




          Obx(()=> AnimatedPositioned(
                top:allRouteController.isSearching.value ==true ? screenSize.height -410.h:screenSize.height -330.h,
                width: screenSize.width,
                duration: 400.milliseconds,
                child: Container(child: SizedBox(
                    width: screenSize.width.w,
                    height: screenSize.height.h,
                    child: FilterListRoutes()))),
          )
        ]),
      ),
    );
  }
}
