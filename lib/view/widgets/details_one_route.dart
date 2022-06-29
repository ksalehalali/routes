import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../Assistants/globals.dart';
import '../../Data/current_data.dart';
import '../../controller/location_controller.dart';
import '../../controller/payment_controller.dart';
import '../../controller/route_map_controller.dart';
import '../map.dart';
import '../screens/destination_selection_screen.dart';



class DetailsOneRoute extends StatefulWidget {
  const DetailsOneRoute({Key? key}) : super(key: key);

  @override
  State<DetailsOneRoute> createState() => _DetailsOneRouteState();
}

class _DetailsOneRouteState extends State<DetailsOneRoute> {
  final String timeC = DateTime.now().hour > 11 ? 'PM' : 'AM';
  final routeMapController = Get.put(RouteMapController());
  final LocationController locationController = Get.find();
  final PaymentController paymentController = Get.find();
  DateTime? timeDrew = DateTime.now();
  double bottomPaddingOfMap = 0;
  final screenSize = Get.size;
  double heightLineStops = 100.0;
  GlobalKey _formKey = GlobalKey(debugLabel: 'a');
  GlobalKey _formKey2 = GlobalKey(debugLabel: 'b');
  var stops = [];
  var stopsLineEx = [];
  String? addressText;
  bool getingAddress = true;
  bool showMap = false;
  bool showStops = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0)),
          boxShadow: [
            BoxShadow(
              color: routes_color7,
              blurRadius: 6.0,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            )
          ]),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                if (panelController.isPanelOpen) {
                  panelController.close();
                } else {
                  panelController.open();
                }
              },
              onVerticalDragStart: (pos){
                if (panelController.isPanelOpen) {
                  panelController.close();
                } else {
                  panelController.open();
                }
              },
              child: Obx(()=>Column(
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
                    Center(
                      child: InkWell(
                        onTap: () {
                          if (panelController.isPanelOpen) {
                            panelController.close();
                          } else {
                            panelController.open();
                          }
                        },
                        child: Text(
                          locationController.tripCreatedDone.value == false
                              ? "Set_your_pickup-Drop_Off_spot_txt".tr
                              : "Start_Your_Trip._txt".tr,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    //
                    //
                    locationController.tripCreatedDone.value == true
                        ? InkWell(
                      onTap: () {
                        if (panelController.isPanelOpen) {
                          panelController.close();
                        } else {
                          panelController.open();
                        }
                      },
                      child: Row(
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
                            Icons.arrow_forward_ios_outlined,
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
                                borderRadius: BorderRadius.circular(3)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Obx(() => Text(
                                  locationController.tripCreatedDone
                                      .value ==
                                      true
                                      ? routeMapController
                                      .tripRouteData[
                                  "description"]["res"][0]
                                  ['route']
                                      .toString()
                                      : '',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Obx(() => SizedBox(
                                  width: 142,
                                  child: Text(
                                    locationController.tripCreatedDone
                                        .value ==
                                        true
                                        ? "${routeMapController.fullDurationTrip.value.toStringAsFixed(0)} min | ${routeMapController.fullDistanceTrip.value.toStringAsFixed(3)} km"
                                        : '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(),

                  ],
                ),
              ),
            ),
            Column(
              children: [

                Obx(
                      () => InkWell(
                    onTap: (){
                      if (panelController.isPanelOpen) {
                        panelController.close();
                      } else {
                        panelController.open();
                      }
                    },
                    child: Center(
                      child: locationController.tripCreatedDone.value == false
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(
                                () => Text(
                              locationController
                                  .startAddingPickUp.value ==
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
                          : Container(
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Obx(
                      () => Center(
                    child: locationController.tripCreatedDone.value == false
                        ? ElevatedButton(
                      onPressed: () async {
                        panelController.close();
                        var newPos = LatLng(locationController.positionFromPin.value.latitude,
                            locationController.positionFromPin.value.longitude);
                        if (locationController
                            .startAddingPickUp.value ==
                            true) {
                          locationController.addPickUp.value = true;
                          trip.startPoint.latitude =
                              locationController.positionFromPin.value.latitude;
                          trip.startPoint.longitude =
                              locationController.positionFromPin.value.longitude;
                          routeMapController.startPointLatLng.value =
                              newPos;
                        } else {
                          trip.endPoint.latitude =
                              locationController.positionFromPin.value.latitude;
                          trip.endPoint.longitude =
                              locationController.positionFromPin.value.longitude;
                          locationController.addDropOff.value = true;
                          routeMapController.endPointLatLng.value =
                              newPos;
                        }
                        routeMapController.clickedPoint.value =
                            newPos;

                        if (locationController.addPickUp.value ==
                            true &&
                            locationController.addDropOff.value ==
                                true) {
                          timeDrew = DateTime.now();

                          print(
                              "start lng ::  ${routeMapController.startPointLatLng.value.longitude}");
                          print(trip.startPoint.longitude);
                          if (routeMapController
                              .startPointLatLng.value.longitude >
                              0.0) {
                            await routeMapController
                                .findStationLocations();
                            if (locationController
                                .tripCreatedDone.value ==
                                true) {
                              panelController.open();
                            }
                          } else {
                            print(locationController.addPickUp.value);
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
                          locationController.buttonString.value
                              .toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          maximumSize: Size(Get.size.width - 90,
                              Get.size.width - 90),
                          minimumSize: Size(Get.size.width - 90, 40),
                          primary: routes_color,
                          onPrimary: Colors.white,
                          alignment: Alignment.center),
                    )
                        : Container(),
                  ),
                ),
              ],
            ),
            Obx(
                  () => Container(
                child: locationController.tripCreatedDone.value == true
                    ? Expanded(
                  key:_formKey2 ,
                  child: ListView(
                    key: _formKey,
                    padding: EdgeInsets.zero,
                    children: [
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: screenSize.width * 0.7 - 20,
                                child: Row(
                                  children: [
                                    Text(
                                      "Start:_txt".tr ,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(
                                      width: screenSize.width * 0.5,
                                      child: Text(
                                        trip.startPointAddress,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),),
                              SizedBox(
                                height: screenSize.height * 0.1 - 62,
                              ),
                              Text(
                                'Walk_to_bus_stop_txt'.tr,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[400]),
                              ),
                              SizedBox(
                                height: screenSize.height * 0.1 - 62,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Board_at_Route_txt'.tr,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    routeMapController.tripRouteData["description"]["res"][0]['route'].toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: screenSize.width * 0.7 - 20,
                                child: Text(
                                  Get.locale =="ar"?'المحطة: ${routeMapController.tripRouteData["description"]["startStation"]['title'].toString()}'  :'station name: ${routeMapController.tripRouteData["description"]["startStation"]['title'].toString()}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: screenSize.height * 0.1 - 62,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: screenSize.height * 0.1 - 72,
                                  bottom:
                                  screenSize.height * 0.1 - 72,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    print(stops);
                                    if (stops.length == 0) {
                                      _buildStopsOfTrip();
                                      showStops = true;
                                    } else {
                                      showStops = false;
                                      setState(() {
                                        stops = [];
                                        heightLineStops = 100;
                                        stopsLineEx = [];
                                      });
                                    }
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        Get.locale =="ar"?'المحطات (${routeMapController.jsonResponse.length})'  :'Stops (${routeMapController.jsonResponse.length})',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w500,
                                            color: Colors.grey[500]),
                                      ),
                                      Icon(
                                        showStops == false
                                            ? Icons
                                            .keyboard_arrow_down_sharp
                                            : Icons.keyboard_arrow_up,
                                        size: 17,
                                        color: Colors.grey[500],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenSize.height * 0.1 - 80,
                              ),
                              ...stops,
                              Text(
                                'Get_off_at_txt'.tr,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: screenSize.width * 0.7 - 20,
                                child: Text(
                                  '${routeMapController.tripRouteData["description"]["endStation"]['title'].toString()}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: screenSize.height * 0.1 - 62,
                              ),
                              SizedBox(
                                  width: screenSize.width * 0.7 - 20,
                                  child: Text(
                                    'End : ${trip.endPointAddress}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black),
                                  )),
                            ],
                          ),
                          Spacer(),
                          //
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                        BorderRadius.circular(1)),
                                    width: 13,
                                    height: 13,
                                  ),
                                  SizedBox(
                                    height:
                                    screenSize.height * 0.1 - 76,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius:
                                        BorderRadius.circular(1)),
                                    width: 7,
                                    height: 7,
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius:
                                          BorderRadius.circular(
                                              1)),
                                      width: 7,
                                      height: 7),
                                  SizedBox(
                                    height: 9.0,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.walking,
                                    color: Colors.grey[700],
                                    size: 22,
                                  ),
                                  SizedBox(
                                    height: 9.0,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius:
                                        BorderRadius.circular(1)),
                                    width: 7,
                                    height: 7,
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius:
                                        BorderRadius.circular(1)),
                                    width: 7,
                                    height: 7,
                                  ),
                                  SizedBox(
                                      height:
                                      screenSize.height * 0.1 -
                                          76),
                                  AnimatedContainer(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[700],
                                      borderRadius:
                                      BorderRadius.circular(1),
                                    ),
                                    height: heightLineStops,
                                    width: 5,
                                    duration: 200.milliseconds,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        ...stopsLineEx,
                                        SizedBox(
                                            height:
                                            screenSize.height *
                                                0.1 -
                                                76),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(1)),
                                          width: 9,
                                          height: 9,
                                        ),
                                        Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(1)),
                                          width: 9,
                                          height: 9,
                                        ),
                                        SizedBox(
                                            height:
                                            screenSize.height *
                                                0.1 -
                                                76),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                      screenSize.height * 0.1 -
                                          73),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius:
                                        BorderRadius.circular(1)),
                                    width: 7,
                                    height: 7,
                                  ),
                                  SizedBox(
                                      height:
                                      screenSize.height * 0.1 -
                                          78),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius:
                                        BorderRadius.circular(1)),
                                    width: 7,
                                    height: 7,
                                  ),
                                  SizedBox(
                                      height:
                                      screenSize.height * 0.1 -
                                          76),
                                  InkWell(
                                    onTap: () {
                                      print('object');
                                      setState(() {
                                        heightLineStops = 200;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red[900],
                                          borderRadius:
                                          BorderRadius.circular(
                                              1)),
                                      width: 13,
                                      height: 13,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  print(
                                      'st w d ${routeMapController.startWalkDurationTrip}');
                                  print(
                                      'route t d ${routeMapController.routeDurationTrip}');
                                  print(
                                      'sec route t d ${routeMapController.secondRouteDurationTrip}');
                                  print(
                                      'sec walk  d ${routeMapController.secondWalkDurationTrip}');
                                },
                                child: Column(
                                  children: [
                                    Text(
                                        '${DateFormat('HH:mm').format(timeDrew!).toString()} $timeC'),
                                    SizedBox(
                                        height:
                                        screenSize.height * 0.1),
                                    Text(
                                        '${DateFormat('HH:mm').format(timeDrew!.add(routeMapController.startWalkDurationTrip.value.minutes)).toString()} $timeC'),
                                    SizedBox(
                                        height: heightLineStops - 18),
                                    Text(
                                        '${DateFormat('HH:mm').format(timeDrew!.add(routeMapController.routeDurationTrip.value.minutes + routeMapController.startWalkDurationTrip.value.minutes + routeMapController.secondRouteDurationTrip.value.minutes)).toString()} $timeC'),
                                    SizedBox(
                                        height:
                                        screenSize.height * 0.1 -
                                            60),
                                    Text(
                                        '${DateFormat('HH:mm').format(timeDrew!.add(routeMapController.secondRouteDurationTrip.value.minutes + routeMapController.routeDurationTrip.value.minutes + routeMapController.startWalkDurationTrip.value.minutes + routeMapController.secondWalkDurationTrip.value.minutes)).toString()} $timeC'),
                                  ],
                                ),
                              ),
                            ],
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
    );
  }

  //build stops\
  _buildStopsOfTrip() {
    stops = [];
    for (var i = 0; i < routeMapController.jsonResponse.length; i++) {
      heightLineStops = heightLineStops + 36.0;
      stops.add(Padding(
        padding: EdgeInsets.only(top: 12),
        child: SizedBox(
            width: screenSize.width * 0.7 - 20,
            height: 24,
            child: Text(
              '${routeMapController.jsonResponse[i]['station']}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey[500]),
            )),
      ));
      setState(() {});
      Timer(200.milliseconds, () {
        _buildStopsLine();
      });
    }
  }

  _buildStopsLine() {
    stopsLineEx = [];
    for (var i = 0; i < routeMapController.jsonResponse.length; i++) {
      stopsLineEx.add(
        Padding(
          padding: EdgeInsets.only(top: 29.8),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(1)),
            width: 7,
            height: 7,
          ),
        ),
      );

      print(heightLineStops);
    }
    setState(() {});
  }

}
