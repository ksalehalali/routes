import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:routes/view/widgets/progressDialog.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../Assistants/assistantMethods.dart';
import '../Assistants/globals.dart';
import '../Data/current_data.dart';
import '../controller/location_controller.dart';
import '../controller/payment_controller.dart';
import '../controller/route_map_controller.dart';
import 'screens/destination_selection_screen.dart';

class Map2 extends StatefulWidget {
  @override
  _Map2State createState() => _Map2State();
}

class _Map2State extends State<Map2> {
  final routeMapController = Get.put(RouteMapController());
  final LocationController locationController = Get.find();
  final PaymentController paymentController = Get.find();

  ///DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now());
  ///
  String? addressText;
  bool getingAddress = true;
  bool showMap = false;
  var assistantMethods = AssistantMethods();
  Position? positionFromPin;
  double? sizeOfSheet = 0.0;
  double rotation = 0.0;
  late final MapController mapController;
  Completer<google_maps.GoogleMapController> _controllerMaps = Completer();
  google_maps.GoogleMapController? newGoogleMapController;
  double bottomPaddingOfMap = 0;

  PanelController panelController = PanelController();
  late final StreamSubscription<MapEvent> mapEventSubscription;
  int _eventKey = 0;
  google_maps.CameraPosition _inialLoc = google_maps.CameraPosition(
    target: google_maps.LatLng(29.370314422169248, 47.98216642044717),
    zoom: 14.4746,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
    mapEventSubscription = mapController.mapEventStream.listen(onMapEvent);
    routeMapController.startPointLatLng.value =
        LatLng(trip.startPoint.latitude, trip.startPoint.longitude);

    Timer(Duration(milliseconds: 1), () {
      setState(() {
        showMap = true;
      });
    });

    //
    if (locationController.tripCreatedDone.value == true) {
      Timer(Duration(milliseconds: 40), () {
        panelController.open();
      });
    }

    initLocationService();
    //
    Timer(100.milliseconds, () {
      if (paymentController.paymentDone.value == true) {
        showDialog(
            context: context,
            builder: (BuildContext context) => SizedBox(
              width: 300,
              child: ProgressDialogShowPayment(
                    message: "Please wait ...",
                  ),
            ));
      }
    });
  }

  void onMapEvent(MapEvent mapEvent) {
    if (mapEvent is MapEventMove && mapEvent.id == _eventKey.toString()) {}
  }

  void _moveToCurrent() async {
    _eventKey++;
    try {
      var moved = mapController.move(
        LatLng(routeMapController.centerOfDirRoute.value.latitude,
            routeMapController.centerOfDirRoute.value.longitude),
        13,
        id: _eventKey.toString(),
      );

      if (moved) {
        //setIcon(Icons.gps_fixed);
      } else {
        //setIcon(Icons.gps_not_fixed);
      }
    } catch (e) {
      //setIcon(Icons.gps_off);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapEventSubscription.cancel();
  }

  //live location
  loc.LocationData? _currentLocation;

  bool _liveUpdate = false;
  bool _permission = false;

  String? _serviceError = '';

  var interActiveFlags = InteractiveFlag.all;

  final loc.Location _locationService = loc.Location();

  void initLocationService() async {
    await _locationService.changeSettings(
      accuracy: loc.LocationAccuracy.high,
      interval: 1000,
    );

    loc.LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;
    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        var permission = await _locationService.requestPermission();
        _permission = permission == loc.PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _currentLocation = location;
          _locationService.onLocationChanged
              .listen((loc.LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;
                locationController.updateLiveLoc(LatLng(
                    _currentLocation!.latitude!, _currentLocation!.longitude!));
                // If Live Update is enabled, move map center
                if (_liveUpdate) {
                  mapController.move(
                      LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      14.5);
                }
              });
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }

  //
  void locatePosition() async {
    print("on crate map");
    Position position = Position(longitude: initialPoint.longitude, latitude: initialPoint.latitude , timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1) ;
    google_maps.LatLng latLngPosition =
        google_maps.LatLng(initialPoint.latitude, initialPoint.longitude);

    google_maps.CameraPosition cameraPosition =
        new google_maps.CameraPosition(target: latLngPosition, zoom: 15);
    print("init point $initialPoint");
    newGoogleMapController!.animateCamera(
        google_maps.CameraUpdate.newCameraPosition(cameraPosition));
    var assistantMethods = AssistantMethods();
    String address = await assistantMethods.searchCoordinateAddress(
        position, context, false);
    print(address);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Get.size;
    final String timeC = DateTime.now().hour > 11 ?'PM':'AM';
    return Obx(
      () => Scaffold(
        body: SlidingUpPanel(
          controller: panelController,
          maxHeight: screenSize.height * 0.4+66 ,
          minHeight: screenSize.height * 0.2 - 20.0,
          panelBuilder: (scrollContainer) => routeMapController
                      .isMultiMode.value ==
                  true
              ? AnimatedSize(
                  //vsync: this,
                  curve: Curves.bounceIn,
                  duration: Duration(milliseconds: 180),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18.0),
                            topRight: Radius.circular(18.0)),
                        boxShadow: [
                          BoxShadow(
                            color: routes_color2,
                            blurRadius: 16.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.5, 0.5),
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 2.0,
                          ),
                          Container(
                            width: 42.0,
                            height: 4.0,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Column(
                            children: [
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    //assistantMethods.obtainDirectionDetails();
                                    panelController.open();
                                  },
                                  child: Text(
                                    locationController.tripCreatedDone.value ==
                                            false
                                        ? "Set your pickUp-dropOff spot "
                                        : "Start Your Trip.",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Obx(
                                () => Center(
                                  child: locationController
                                              .tripCreatedDone.value ==
                                          false
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Obx(
                                              () => Text(
                                                locationController
                                                            .startAddingPickUp
                                                            .value ==
                                                        true
                                                    ? locationController
                                                        .pickUpAddress.value
                                                    : locationController
                                                        .dropOffAddress.value,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),


                            ],
                          ),
                          Obx(
                            () => Container(
                              child: locationController.tripCreatedDone.value ==
                                      true
                                  ? Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.walking,
                                                size: 21,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(
                                                width: 11.0,
                                              ),
                                              Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                size: 16,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(
                                                width: 12.0,
                                              ),
                                              Icon(
                                                FontAwesomeIcons.busAlt,
                                                size: 21,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(
                                                width: 11.0,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.red[900],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Obx(() => Text(
                                                          locationController
                                                                      .tripCreatedDone
                                                                      .value ==
                                                                  true
                                                              ? routeMapController
                                                                  .multiRouteTripData[
                                                                      "rout1"]
                                                                      [0]
                                                                      ['route']
                                                                  .toString()
                                                              : '',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Obx(() => SizedBox(
                                                          width: 68,
                                                          child: Text(
                                                            locationController
                                                                        .tripCreatedDone
                                                                        .value ==
                                                                    true
                                                                ? "${routeMapController.fullDurationTrip.value.toStringAsFixed(0)} min"
                                                                : '',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Container(
                                            height: 2,
                                            width: screenSize.width - 30,
                                            color: Colors.grey,
                                          ),

                                          SizedBox(
                                            height: 6.0,
                                          ),
                                          //
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: 180,
                                                      child: Text(
                                                        "Start : ${trip.startPointAddress}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      )),
                                                  SizedBox(
                                                    height: 14.0,
                                                  ),
                                                  Text(
                                                    'Walk to bus stop',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Colors.grey[400]),
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  Text(
                                                    'Board at Route ${routeMapController.multiRouteTripData["rout1"][0]['route'].toString()}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    width: 220,
                                                    child: Text(
                                                      'station name: ${routeMapController.multiRouteTripData["startStation"]['title'].toString()}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 14.0,
                                                  ),
                                                  Text(
                                                    'Get off at ',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    width: 220,
                                                    child: Text(
                                                      '${routeMapController.multiRouteTripData["endStation"]['title'].toString()}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  SizedBox(
                                                      width: 180,
                                                      child: Text(
                                                        'End : ${trip.endPointAddress}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                      )),
                                                ],
                                              ),
                                              //
                                              Column(
                                                children: [],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : AnimatedSize(
                  //vsync: this,
                  curve: Curves.bounceIn,
                  duration: Duration(milliseconds: 180),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18.0),
                            topRight: Radius.circular(18.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 16.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 2.0,
                          ),
                          Container(
                            width: 42.0,
                            height: 4.0,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Column(
                            children: [
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    //assistantMethods.obtainDirectionDetails();
                                    panelController.open();
                                  },
                                  child: Text(
                                    locationController.tripCreatedDone.value ==
                                            false
                                        ? "Set your pickUp-dropOff spot "
                                        : "Start Your Trip.",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Obx(
                                () => Center(
                                  child: locationController
                                              .tripCreatedDone.value ==
                                          false
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Obx(
                                              () => Text(
                                                locationController
                                                            .startAddingPickUp
                                                            .value ==
                                                        true
                                                    ? locationController
                                                        .pickUpAddress.value
                                                    : locationController
                                                        .dropOffAddress.value,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Obx(
                                () => Center(
                                  child: locationController
                                              .tripCreatedDone.value ==
                                          false
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            panelController.close();
                                            var newPos = LatLng(
                                                positionFromPin!.latitude,
                                                positionFromPin!.longitude);
                                            if (locationController
                                                    .startAddingPickUp.value ==
                                                true) {
                                              locationController
                                                  .addPickUp.value = true;
                                              trip.startPoint.latitude =
                                                  positionFromPin!.latitude;
                                              trip.startPoint.longitude =
                                                  positionFromPin!.longitude;
                                              routeMapController
                                                  .startPointLatLng
                                                  .value = newPos;
                                            } else {
                                              trip.endPoint.latitude =
                                                  positionFromPin!.latitude;
                                              trip.endPoint.longitude =
                                                  positionFromPin!.longitude;
                                              locationController
                                                  .addDropOff.value = true;
                                              routeMapController.endPointLatLng
                                                  .value = newPos;
                                            }
                                            routeMapController
                                                .clickedPoint.value = newPos;

                                            if (locationController
                                                        .addPickUp.value ==
                                                    true &&
                                                locationController
                                                        .addDropOff.value ==
                                                    true) {
                                              print("start lng ::  ${routeMapController.startPointLatLng.value.longitude}");
                                              print(trip.startPoint.longitude);
                                              if (routeMapController
                                                      .startPointLatLng
                                                      .value
                                                      .longitude >
                                                  0.0) {
                                                await routeMapController
                                                    .findStationLocations();
                                                if (locationController
                                                        .tripCreatedDone
                                                        .value ==
                                                    true) {
                                                  panelController.open();
                                                }
                                              } else {
                                                print(locationController
                                                    .addPickUp.value);
                                              }
                                              if (locationController
                                                      .tripCreatedDone.value ==
                                                  true) {
                                                panelController.open();
                                              }
                                              return;
                                            } else {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SearchScreen()));
                                            }
                                          },
                                          child: Obx(
                                            () => Text(
                                              locationController
                                                  .buttonString.value
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                    style: ElevatedButton.styleFrom(
                                        maximumSize: Size(Get.size.width -90,Get.size.width -90),
                                        minimumSize: Size(Get.size.width -90, 40),primary: routes_color,
                                        onPrimary: Colors.white,
                                        alignment: Alignment.center
                                    ),
                                        )
                                      : Container(),
                                ),
                              ),
                            ],
                          ),
                          Obx(
                            () => Container(
                              child: locationController.tripCreatedDone.value ==
                                      true
                                  ? Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.walking,
                                                size: 21,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(
                                                width: 11.0,
                                              ),
                                              Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                size: 16,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(
                                                width: 12.0,
                                              ),
                                              Icon(
                                                FontAwesomeIcons.busAlt,
                                                size: 21,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(
                                                width: 11.0,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.red[900],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3)),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Obx(() => Text(
                                                          locationController
                                                                      .tripCreatedDone
                                                                      .value ==
                                                                  true
                                                              ? routeMapController
                                                                  .tripRouteData[
                                                                      "description"]
                                                                      ["res"][0]
                                                                      ['route']
                                                                  .toString()
                                                              : '',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Obx(() => SizedBox(
                                                          width: 142,
                                                          child: Text(
                                                            locationController
                                                                        .tripCreatedDone
                                                                        .value ==
                                                                    true
                                                                ? "${routeMapController.fullDurationTrip.value.toStringAsFixed(0)} min | ${routeMapController.fullDistanceTrip.value.toStringAsFixed(3)} km"
                                                                : '',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Container(
                                            height: 2,
                                            width: screenSize.width - 30,
                                            color: Colors.grey,
                                          ),

                                          SizedBox(
                                            height: 6.0,
                                          ),
                                          //
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        width: screenSize.width * 0.7-20,
                                                        child: Text(
                                                          "Start : ${trip.startPointAddress}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        )),
                                                    SizedBox(
                                                      height:  screenSize.height*0.1-62,
                                                    ),
                                                    Text(
                                                      'Walk to bus stop',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.grey[400]),
                                                    ),
                                                    SizedBox(
                                                      height:  screenSize.height*0.1-62,
                                                    ),
                                                    Text(
                                                      'Board at Route ${routeMapController.tripRouteData["description"]["res"][0]['route'].toString()}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      width: screenSize.width *0.7-20,
                                                      child: Text(
                                                        'station name: ${routeMapController.tripRouteData["description"]["startStation"]['title'].toString()}',
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: screenSize.height*0.1-62,
                                                    ),
                                                    const Text(
                                                      'Get off at ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      width: screenSize.width *0.7-20,
                                                      child: Text(
                                                        '${routeMapController.tripRouteData["description"]["endStation"]['title'].toString()}',
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: screenSize.height*0.1-62,
                                                    ),
                                                    SizedBox(
                                                        width: screenSize.width *0.7-20,
                                                        child: Text(
                                                          'End : ${trip.endPointAddress}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                  ],
                                                ),
                                                Spacer(),
                                                //
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    Column(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.green,
                                                              borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          width: 13,
                                                          height: 13,
                                                        ),
                                                        SizedBox(height: screenSize.height*0.1-76,),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey[400],
                                                              borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          width: 7,
                                                          height: 7,
                                                        ),
                                                        SizedBox(height: 4.0,),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey[400],
                                                              borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          width: 7,
                                                          height: 7
                                                        ),
                                                        SizedBox(height: 9.0,),
                                                        Icon(FontAwesomeIcons.walking,color: Colors.grey[700],size: 22,),
                                                        SizedBox(height: 9.0,),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey[400],
                                                              borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          width: 7,
                                                          height: 7,
                                                        ),
                                                        SizedBox(height: 4.0,),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey[400],
                                                              borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          width: 7,
                                                          height: 7,
                                                        ),
                                                        SizedBox(height: screenSize.height*0.1-76),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[700],
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          height: screenSize.height*0.1+20,
                                                          width: 14,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              SizedBox(height: screenSize.height*0.1-76),

                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(50)
                                                                ),
                                                                width: 9,
                                                                height: 9,
                                                              ),
                                                              Spacer(),
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(50)
                                                                ),
                                                                width: 9,
                                                                height: 9,
                                                              ),
                                                              SizedBox(height:screenSize.height*0.1-76),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height:screenSize.height*0.1-73),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey[400],
                                                              borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          width: 7,
                                                          height: 7,
                                                        ),
                                                        SizedBox(height: screenSize.height*0.1-78),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey[400],
                                                              borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          width: 7,
                                                          height: 7,
                                                        ),
                                                        SizedBox(height: screenSize.height*0.1-76),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.red[900],
                                                              borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          width: 13,
                                                          height: 13,
                                                        ),
                                                      ],
                                                    ),

                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                          child: Text('${DateFormat('HH:mm').format(DateTime.now()).toString()} $timeC'),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
          body: Stack(children: [
            google_maps.GoogleMap(
              initialCameraPosition: _inialLoc,
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              padding: EdgeInsets.only(bottom: 136, top: 30),
              markers: {
                // google_maps.Marker(markerId: google_maps.MarkerId('a'),position: locationController.currentLocationG.value,onTap: (){
                //   print('object');
                // }),
                locationController.tripCreatedDone.value == false
                    ? google_maps.Marker(
                        markerId: google_maps.MarkerId('center'),
                        position: locationController.currentLocationG.value,
                        onTap: () {
                          print('object');
                        },
                        icon: google_maps.BitmapDescriptor.defaultMarker,)
                    : google_maps.Marker(
                        markerId: google_maps.MarkerId("center")),

                locationController.tripCreatedDone.value == true
                    ? google_maps.Marker(
                        icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
                            google_maps.BitmapDescriptor.hueYellow),
                        infoWindow: google_maps.InfoWindow(
                            title: 'pickUp', snippet: routeMapController.startStation['station'].toString()),
                        position: google_maps.LatLng(
                            routeMapController.startStation['latitude'],
                            routeMapController.startStation['longitude']),
                        markerId: google_maps.MarkerId("pickUpId"))
                    : google_maps.Marker(
                        markerId: google_maps.MarkerId("pickUpId")),

                locationController.tripCreatedDone.value == true &&routeMapController.isMultiMode.value ==true
                    ? google_maps.Marker(
                    icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
                        google_maps.BitmapDescriptor.hueOrange),
                    infoWindow: google_maps.InfoWindow(
                        title: 'shared', snippet: routeMapController.sharedStation['station']),
                    position: google_maps.LatLng(
                        routeMapController.sharedStation['latitude'],
                        routeMapController.sharedStation['longitude']),
                    markerId: google_maps.MarkerId("sharedId"))
                    : google_maps.Marker(
                    markerId: google_maps.MarkerId("sharedId")),

                locationController.tripCreatedDone.value == true &&routeMapController.isMultiMode.value ==true
                    ? google_maps.Marker(
                    icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
                        google_maps.BitmapDescriptor.hueOrange,),
                    infoWindow: google_maps.InfoWindow(
                        title: 'shared', snippet: routeMapController.sharedStation2['station']),
                    position: google_maps.LatLng(
                        routeMapController.sharedStation2['latitude'],
                        routeMapController.sharedStation2['longitude']),
                    markerId: google_maps.MarkerId("shared2Id"))
                    : google_maps.Marker(
                    markerId: google_maps.MarkerId("shared2Id")),

                //
                locationController.tripCreatedDone.value == true
                    ? google_maps.Marker(
                        icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
                            google_maps.BitmapDescriptor.hueBlue),
                        infoWindow: google_maps.InfoWindow(
                            title: 'dropOff', snippet: routeMapController.endStation['station']),
                        position: google_maps.LatLng(
                            routeMapController.endStation['latitude'],
                            routeMapController.endStation['longitude']),
                        markerId: google_maps.MarkerId("dropOffId"))
                    : google_maps.Marker(
                        markerId: google_maps.MarkerId("dropOffId")),
              },
              polylines: {
            google_maps.Polyline(
            color: Colors.blue.withOpacity(0.7),
            polylineId: google_maps.PolylineId("PolylineID"),
            jointType: google_maps.JointType.round,
            width: 5,
            startCap: google_maps.Cap.roundCap,
            points: routeMapController.tripStationWayPointsG,
            endCap: google_maps.Cap.roundCap,
            geodesic: true,
            ),

                google_maps.Polyline(
                  color: Colors.red.withOpacity(0.6),
                  polylineId: google_maps.PolylineId("FirstWalkPolylineID"),
                  jointType: google_maps.JointType.round,
                  width: 5,
                  startCap: google_maps.Cap.roundCap,
                  points: routeMapController.tripFirstWalkWayPointsG,
                  endCap: google_maps.Cap.roundCap,
                  geodesic: true,
                ),

                google_maps.Polyline(
                  color: Colors.green.withOpacity(0.7),
                  polylineId: google_maps.PolylineId("SecondWalkPolylineID"),
                  jointType: google_maps.JointType.round,
                  width: 5,
                  startCap: google_maps.Cap.roundCap,
                  points: routeMapController.tripSecondWalkWayPointsG,
                  endCap: google_maps.Cap.roundCap,
                  geodesic: true,
                ),

                google_maps.Polyline(
                  color: Colors.blue.withOpacity(0.7),
                  polylineId: google_maps.PolylineId("StationWayPolyline2ID"),
                  jointType: google_maps.JointType.mitered,
                  width: 5,
                  startCap: google_maps.Cap.roundCap,
                  points: routeMapController.tripStationWayPoints2G,
                  endCap: google_maps.Cap.roundCap,
                  geodesic: true,
                ),
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
                            positionFromPin!, context, false);
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
                newGoogleMapController = controller;
                setState(() {
                  bottomPaddingOfMap = 320.0;
                });
                locatePosition();
              },
            ),

            //HamburgerButton for drawer
            Positioned(
              top: 45.0,
              left: 22.0,
              child: InkWell(
                onTap: () {
                  locationController.addDropOff.value = false;
                  //locationController.addPickUp.value = false;
                  locationController.tripCreatedStatus(false);
                  routeMapController.resetAll();
                  paymentController.paymentDone.value = false;
                  locationController.startAddingDropOffStatus(true);
                  locationController.startAddingPickUpStatus(false);
                  routeMapController.isMultiMode.value = false;
                  //locationController.changePickUpAddress('set pick up');
                  //trip = Trip('', '', LocationModel(0.0,0.0), LocationModel(0.0,0.0), '', '', '', '', '');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                child: Container(
                  //height: 300.0,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(22.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        ),
                      ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(.9),
                    child: Obx(
                      () => Icon(
                        (locationController.tripCreatedDone.value == false)
                            ? Icons.close
                            : Icons.close,
                        color: Colors.black,
                      ),
                    ),
                    radius: 20.0,
                  ),
                ),
              ),
            ),
          ]),
        ),
        floatingActionButton: locationController.tripCreatedDone.value == true
            ? buildActionButton()
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  int index = 0;

  Widget buildActionButton() {
    switch (index) {
      case 0:
        return buildStartTheTripButton();
      case 1:
        return buildPayButton();
      default:
        return buildStartTheTripButton();
    }
  }

  Widget buildStartTheTripButton() => FloatingActionButton.extended(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        foregroundColor: Colors.white,
        backgroundColor: routes_color,
        extendedPadding: EdgeInsets.symmetric(horizontal: 9),
        icon: Icon(Icons.not_started_outlined),
        label: Text(
          'Start the trip',
          style: TextStyle(fontSize: 12,color: Colors.white,fontWeight:FontWeight.bold),
        ),
        onPressed: () {

          routeMapController.callSaveTrip();
          setState(() {
            index = 1;
          });
        },
      );

  Widget buildPayButton() => FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        foregroundColor: Colors.white,
        backgroundColor: routes_color,
        icon: Icon(Icons.payment_rounded),
        label: Text(
          'Pay',
          style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => QRViewExample(
                        context: context,
                      )));
        },
      );
}

// QR Code Scanner
class QRViewExample extends StatefulWidget {
  BuildContext? context;

  QRViewExample({Key? key, this.context}) : super(key: key);

  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final PaymentController paymentController = Get.find();

  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      print(scanData.code);
      controller.stopCamera();
      var json = jsonDecode(result!.code!);
      tripToSave.busId = json['busId'];
      paymentSaved.busId = json['busId'];
      paymentSaved.routeId = json['routeId'];
      paymentSaved.value = json['value'];

      var pay = await paymentController.pay(false);
      if (pay == true) {
        print(pay);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Map2()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Map2()));
        print(pay);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
