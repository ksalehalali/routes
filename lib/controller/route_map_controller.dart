import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:routes/controller/trip_controller.dart';

import '../Assistants/globals.dart';
import '../Data/current_data.dart';
import '../config-maps.dart';
import 'location_controller.dart';

class RouteMapController extends GetxController {
  var clickedPoint = new LatLng(0, 0).obs; //Location(0, 0).obs;
  var routePoints = <LatLng>[new LatLng(0, 0), new LatLng(0, 0)].obs;
  var startPointLatLng = new LatLng(0.0, 0.0).obs;
  var endPointLatLng = new LatLng(0.0, 0.0).obs;
  var startStation = {};
  var sharedStation = {};
  var endStation = {};
  var tripFirstWalkDirData = {}.obs;
  var tripSecondWalkDirData = {}.obs;

  var tripStationDirData = {}.obs;
  var tripStationDirData2 = {}.obs;

  var tripRouteData = {}.obs;
  var multiRouteTripData = {}.obs;

  var fullDurationTrip = 0.0.obs;
  var startWalkDurationTrip = 0.0.obs;
  var secondRouteDurationTrip = 0.0.obs;

  var secondWalkDurationTrip = 0.0.obs;
  var routeDurationTrip = 0.0.obs;

  var fullDistanceTrip = 0.0.obs;
  var startWalkDistanceTrip = 0.0.obs;
  var secondRouteDistanceTrip = 0.0.obs;
  var secondWalkDistanceTrip = 0.0.obs;
  var routeDistanceTrip = 0.0.obs;



  var centerOfDirRoute = new LatLng(0.0, 0.0).obs;
  var index = 0.obs;
  int indexOfStations = 0;
  int intIndex = 0;
  var isMultiMode = false.obs;
  var firstTurn = true.obs;
  var isLongTrip = false.obs;
  var stationLocationPoints = <LatLng>[].obs;
  var stationLocationPoints2 = <LatLng>[].obs;

  var tripFirstWalkWayPoints = <LatLng>[].obs;
  var tripFirstWalkWayPointsG = <google_maps.LatLng>[].obs;

  var tripSecondWalkWayPoints = <LatLng>[].obs;
  var tripSecondWalkWayPointsG = <google_maps.LatLng>[].obs;

  var tripStationWayPoints = <LatLng>[].obs;
  var tripStationWayPointsG = <google_maps.LatLng>[].obs;

  var tripStationWayPoints2 = <LatLng>[].obs;
  var tripStationWayPoints2G = <google_maps.LatLng>[].obs;

  var latPinLoc = trip.startPoint.latitude.obs;
  var lngPinLoc = trip.startPoint.longitude.obs;

  var stationMarkers = <Marker>[].obs;

  // handle reset
  void resetAll() {
    stationMarkers.value = [];
    tripFirstWalkWayPoints.value = [];
    tripFirstWalkWayPointsG.value = [];

    tripSecondWalkWayPoints.value = [];
    tripSecondWalkWayPointsG.value = [];

    stationLocationPoints.value = [];
    tripStationWayPointsG.value = [];
    stationMarkers.value = [];
    tripStationWayPoints.value = [];
    tripRouteData.value = {};
    tripStationDirData2.value = {};
    tripStationWayPoints2.value = [];
    tripStationWayPoints2G.value = [];

    // trip.startPoint.latitude = 0.0;
    // trip.startPoint.longitude = 0.0;
    trip.endPoint.latitude = 0.0;
    trip.endPoint.longitude = 0.0;
    // trip.startPointAddress = '';
     trip.endPointAddress = '';
    startStation.clear();
    endStation.clear();
    sharedStation.clear();
    isMultiMode.value =false;
    update();
  }

  final LocationController locationController = Get.find();
  final TripController tripController = Get.find();

  Future<void> findFirstWalkDirection(
      LatLng startPoint, LatLng endPoint) async {
    final response = await http.get(Uri.parse(
        "https://api.mapbox.com/directions/v5/mapbox/walking/${startPoint.longitude},${startPoint.latitude};${endPoint.longitude},${endPoint.latitude}?alternatives=true&annotations=distance%2Cduration%2Cspeed%2Ccongestion&geometries=geojson&language=en&overview=full&access_token=$mapbox_token"));

    if (response.statusCode == 200) {
      print('true start polyline  ${response.body}');
      var decoded = jsonDecode(response.body);
      tripFirstWalkDirData.value = decoded;
      decoded = decoded["routes"][0]["geometry"];

      for (int i = 0; i < decoded["coordinates"].length; i++) {
        tripFirstWalkWayPoints.add(new LatLng(
            decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
        tripFirstWalkWayPointsG.add(google_maps.LatLng(
            decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
      }
    } else {
      print('11111NNNOOOOOONnonooooOOO ${response.statusCode}');
    }
  }

  Future<void> findSecondWalkDirection(
      LatLng startPoint, LatLng endPoint) async {
    final response = await http.get(Uri.parse(
        "https://api.mapbox.com/directions/v5/mapbox/walking/${startPoint.longitude},${startPoint.latitude};${endPoint.longitude},${endPoint.latitude}?alternatives=true&annotations=distance%2Cduration%2Cspeed%2Ccongestion&geometries=geojson&language=en&overview=full&access_token=$mapbox_token"));
    print('staaaart$startPoint');
    if (response.statusCode == 200) {
      print('trueeee sec polyline ${response.body}');
      var decoded = jsonDecode(response.body);
      tripSecondWalkDirData.value = decoded;
      decoded = decoded["routes"][0]["geometry"];
      for (int i = 0; i < decoded["coordinates"].length; i++) {
        tripSecondWalkWayPoints.add(new LatLng(
            decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
        tripSecondWalkWayPointsG.add(google_maps.LatLng(
            decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
      }

      //handle if index of routeStations lees than 2
      if (index.value < 2) {
        locationController.tripCreatedStatus(false);
        resetAll();
        Get.snackbar('Invalid Data', 'Please inter right points for your trip',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3));
        Timer(Duration(seconds: 1), () {
        });
        return;
      }
    } else {
      print('2222NNNOOOOOONnonooooOOO ${response.body}');
    }
  }

  Future<void> findStationDirection(String stationQuery, bool isSecond) async {
    if (isSecond == false) {
      final response = await http.get(Uri.parse(
          "https://api.mapbox.com/directions/v5/mapbox/driving/$stationQuery?alternatives=true&annotations=distance%2Cduration%2Cspeed%2Ccongestion&geometries=geojson&language=en&overview=full&access_token=$mapbox_token"));
      //print('full res from find == ${response.body}');
      if (response.statusCode == 200) {
        print('true 1 ${response.statusCode}');
        var decoded = jsonDecode(response.body);
        tripStationDirData.value = decoded;
        decoded = decoded["routes"][0]["geometry"];
        for (int i = 0; i < decoded["coordinates"].length; i++) {
          tripStationWayPoints.add(new LatLng(
              decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
          tripStationWayPointsG.add(google_maps.LatLng(
              decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
        }
        locationController.tripCreatedStatus(true);
      } else {
        print('error :: ${response.body}');
        print('stationNNNOOOOO 11 ${response.statusCode} \n${stationQuery}');
        locationController.tripCreatedStatus(false);
        return;
      }
    } else {
      final response = await http.get(Uri.parse(
          "https://api.mapbox.com/directions/v5/mapbox/driving/$stationQuery?alternatives=true&annotations=distance%2Cduration%2Cspeed%2Ccongestion&geometries=geojson&language=en&overview=full&access_token=$mapbox_token"));
      //print('full res from find == ${response.body}');
      if (response.statusCode == 200) {
        print('true 2 ${response.statusCode}');
        var decoded = jsonDecode(response.body);
        tripStationDirData2.value = decoded;
        decoded = decoded["routes"][0]["geometry"];
        for (int i = 0; i < decoded["coordinates"].length; i++) {
          tripStationWayPoints2.add(new LatLng(
              decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
          tripStationWayPoints2G.add(google_maps.LatLng(
              decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
        }
        locationController.tripCreatedStatus(true);
      } else {
        print('stationNNNOOOOO 2 ${response.statusCode} \n${stationQuery}');
        print(response.body);
      }
    }
  }

  Future<void> findStationLocations() async {
    final queryParameters = {
      "Longitude1": startPointLatLng.value.longitude,
      "Latitude1": startPointLatLng.value.latitude,
      "Longitude2": endPointLatLng.value.longitude,
      "Latitude2": endPointLatLng.value.latitude
    };

    print(queryParameters);
    final url = Uri.parse(baseURL + "/api/FindRoute");
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${user.accessToken}",
    };

    final response =
        await post(url, headers: headers, body: jsonEncode(queryParameters));

    print(response.statusCode);

    var jsonResponse = jsonDecode(response.body);

    ///handle multi routes
    if (jsonResponse["status"] == false) {
      findMultiRoute();
    }else if(jsonResponse['description']['res'].length <2){
      print('bad data ----');
      resetAll();
      Get.snackbar(
          'there is no route', 'wrong points entered',
          duration: 5.seconds, colorText: Colors.red[900]);
      return;
    }else{

        isMultiMode.value =false ;
        String stationQuery = "";
        String stationQuery2 = "";
        String stationQuery3 = "";
        print("find route res ::$jsonResponse");
        stationMarkers.value = [];
        tripRouteData.value = jsonResponse;
        startStation = jsonResponse["description"]['startStation'];
        endStation = jsonResponse["description"]['endStation'];

        jsonResponse = jsonResponse["description"]["res"];
        print('points count :: ${jsonResponse.length}');

        // dir 2
        if (jsonResponse.length > 25) {
          isLongTrip.value = true;
          print('get long route -----------');
          for (int i = 0; i < 24; i++) {
            print(jsonResponse[i]);
            stationQuery = stationQuery +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
            index.value = i;
          }

          for (int i = 24; i < jsonResponse.length; i++) {
            print(jsonResponse[i]);
            stationQuery2 = stationQuery2 +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints2.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
          }

          /// for more points
          // for (int i = 48; i < jsonResponse.length; i++) {
          //   print(jsonResponse[i]);
          //   stationQuery3 = stationQuery3 +
          //       jsonResponse[i]["longitude"].toString() +
          //       "," +
          //       jsonResponse[i]["latitude"].toString() +
          //       ";";
          //   stationLocationPoints2.add(new LatLng(
          //       jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
          // }

          stationQuery = stationQuery.substring(
              0,
              stationQuery.length -
                  1); // To remove the last semicolon from the string (would cause an error)
          stationQuery2 = stationQuery2.substring(0, stationQuery2.length - 1);
        } else {
          isLongTrip.value = false;
          for (int i = 0; i < jsonResponse.length; i++) {
            print(jsonResponse[i]);
            stationQuery = stationQuery +
                jsonResponse[i]["longitude"].toString() +
                "," +
                jsonResponse[i]["latitude"].toString() +
                ";";
            stationLocationPoints.add(new LatLng(
                jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
            index.value = i;
          }

          stationQuery = stationQuery.substring(
              0,
              stationQuery.length -
                  1); // To remove the last semicolon from the string (would cause an error)
        }

        var i = index.value / 2;
        intIndex = index.value;
        int b = i.round();
        centerOfDirRoute.value =
            LatLng(jsonResponse[b]["latitude"], jsonResponse[b]["longitude"]);

        print("center :: $b");

        //add mark for first station
        stationMarkers.add(
          new Marker(
            width: 84,
            height: 84,
            point: LatLng(startStation['latitude'], startStation['longitude']),
            builder: (context) => Center(
              child: Container(
                padding: EdgeInsets.all(0.0),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.directions_bus),
                  iconSize: 30,
                  color: Colors.blue[300],
                ),
              ),
            ),
          ),
        );
        //add mark for last station
        stationMarkers.add(
          new Marker(
            width: 60,
            height: 60,
            point: LatLng(endStation['latitude'], endStation['longitude']),
            builder: (context) => Container(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.directions_bus),
                iconSize: 30,
                color: Colors.blue[900],
              ),
            ),
          ),
        );

        tripFirstWalkWayPoints.value = [];
        tripSecondWalkWayPoints.value = [];
        tripStationWayPoints.value = [];
        update();
        await findFirstWalkDirection(
            LatLng(startPointLatLng.value.latitude,
                startPointLatLng.value.longitude),
            LatLng(startStation['latitude'], startStation['longitude']));

        if (jsonResponse.length <= 25) {
          await findStationDirection(stationQuery, false);
        } else {
          //await findStationDirection(stationQuery, false);
          await findStationDirection(stationQuery2, true);
          print('second points :: $stationQuery2');
        }

        await findSecondWalkDirection(
            LatLng(endStation['latitude'], endStation['longitude']),
            LatLng(
                endPointLatLng.value.latitude, endPointLatLng.value.longitude));
        locationController.tripCreatedStatus(true);

        calFullDurationDistance();

    }

  }

  //go multi
  findMultiRoute()async{
    final queryParameters = {
      "Longitude1": startPointLatLng.value.longitude,
      "Latitude1": startPointLatLng.value.latitude,
      "Longitude2": endPointLatLng.value.longitude,
      "Latitude2": endPointLatLng.value.latitude
    };
    print('multi route running .......');
    Get.snackbar(
        'go to multi routes', 'we trying to get multi routes for you',
        duration: 3.seconds, colorText: Colors.blue[900]);
    isMultiMode.value = true;
    final url = Uri.parse(baseURL + "/api/FindMultiRoute1");
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${user.accessToken}",
    };

    final response =
    await post(url, headers: headers, body: jsonEncode(queryParameters));

    print(response.statusCode);
    // print(" multi routes .... :: ${response.body}");
    var jsonResponse = jsonDecode(response.body);

    jsonResponse = jsonDecode(response.body);
    multiRouteTripData.value = jsonResponse;
    if (jsonResponse["status"] == false) {
      print('there is no route !! .......');
      Timer(3.seconds, () {
        Get.snackbar(
            'there is no route', 'no route please try change your points',
            duration: 5.seconds, colorText: Colors.red[900]);
      });
      isMultiMode.value = false;
      return;
    }else if(jsonResponse["status"] == true){
      locationController.tripCreatedDone.value =true;
      isMultiMode.value =true;
      print('findeMultiRoute1 res :: $jsonResponse');
      startStation = jsonResponse['startStation'];
      sharedStation = jsonResponse['sharedPoint'];
      endStation = jsonResponse['endStation'];
      print('route1 = ${jsonResponse['rout1'][0]['route']} ---- route 2 = ${jsonResponse['rout2'][0]['route']}');
      print('route1 = ${jsonResponse['rout1']} --- ');
      print('route 2 = ${jsonResponse['rout2']}');

      var rout1 = jsonResponse['rout1'];
      rout1.addAll(jsonResponse['rout2']) ;

      index.value = rout1.length;
      var i = index.value / 2;
      intIndex = index.value;
      int b = i.round();
      centerOfDirRoute.value =
          LatLng(rout1[b]["latitude"], rout1[b]["longitude"]);

      print("center :: $b");
      print("length :::2 ${rout1.length}");
      var stationQuery = "";
      var stationQuery1 = "";
      var stationQuery2 = "";

      if(rout1.length >50){
        for (int i = 0; i  < 23; i++) {
          print(rout1[i]['station']);
          print(rout1[i]['order']);
          stationQuery = stationQuery +
              rout1[i]["longitude"].toString() +
              "," +
              rout1[i]["latitude"].toString() +
              ";";

        }
        for (int i = 24; i  < 49; i++) {
          print(rout1[i]['station']);
          print(rout1[i]['order']);
          stationQuery1 = stationQuery1 +
              rout1[i]["longitude"].toString() +
              "," +
              rout1[i]["latitude"].toString() +
              ";";

        }
        for (int i = 49; i  < rout1.length; i++) {
          print(rout1[i]['station']);
          print(rout1[i]['order']);
          stationQuery2 = stationQuery2 +
              rout1[i]["longitude"].toString() +
              "," +
              rout1[i]["latitude"].toString() +
              ";";

        }


      }else if(rout1.length < 50 && rout1.length >25){
        for (int i = 0; i  < 24; i++) {
          print(rout1[i]['station']);
          print(rout1[i]['order']);
          stationQuery = stationQuery +
              rout1[i]["longitude"].toString() +
              "," +
              rout1[i]["latitude"].toString() +
              ";";

        }
        for (int i = 25; i  < rout1.length; i++) {
          print(rout1[i]['station']);
          print(rout1[i]['order']);
          stationQuery1 = stationQuery1 +
              rout1[i]["longitude"].toString() +
              "," +
              rout1[i]["latitude"].toString() +
              ";";

        }

      }else{
        for (int i = 0; i  < rout1.length; i++) {
          print(rout1[i]['station']);
          print(rout1[i]['order']);
          stationQuery = stationQuery +
              rout1[i]["longitude"].toString() +
              "," +
              rout1[i]["latitude"].toString() +
              ";";

        }

      }

      //
      print('======================================== d');
      //add mark for first station
      stationMarkers.add(
        new Marker(
          width: 84,
          height: 84,
          point: LatLng(startStation['latitude'], startStation['longitude']),
          builder: (context) => Center(
            child: Container(
              padding: EdgeInsets.all(0.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.directions_bus),
                iconSize: 30,
                color: Colors.blue[300],
              ),
            ),
          ),
        ),
      );

      print('endStation $endStation');
      //add mark for shared Station
      stationMarkers.add(
        new Marker(
          width: 60,
          height: 60,
          point: LatLng(sharedStation['latitude'], sharedStation['longitude']),
          builder: (context) => Container(
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.directions_bus),
              iconSize: 30,
              color: Colors.red[900],
            ),
          ),
        ),
      );

      //add mark for last station
      stationMarkers.add(
        new Marker(
          width: 60,
          height: 60,
          point: LatLng(endStation['latitude'], endStation['longitude']),
          builder: (context) => Container(
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.directions_bus),
              iconSize: 30,
              color: Colors.blue[900],
            ),
          ),
        ),
      );

      tripFirstWalkWayPoints.value = [];
      tripSecondWalkWayPoints.value = [];
      tripStationWayPoints.value = [];
      update();
      await findFirstWalkDirection(
          LatLng(startPointLatLng.value.latitude,
              startPointLatLng.value.longitude),
          LatLng(startStation['latitude'], startStation['longitude']));

      await findSecondWalkDirection(LatLng(endStation['latitude'], endStation['longitude']),LatLng(endPointLatLng.value.latitude,endPointLatLng.value.longitude) );
      return;
      // //
      // if (rout1.length > 50) {
      //   stationQuery = stationQuery.substring(0, stationQuery.length - 1);
      //   stationQuery1 = stationQuery1.substring(0, stationQuery1.length - 1);
      //   stationQuery2 = stationQuery2.substring(0, stationQuery2.length - 1);
      //
      //   await findStationDirection(stationQuery, false);
      //   await findStationDirection(stationQuery1, false);
      //   await findStationDirection(stationQuery2, true);
      // } else if(rout1.length < 50 && rout1.length > 25){
      //   await findStationDirection(stationQuery, false);
      //   await findStationDirection(stationQuery1, true);
      // }else{
      //   await findStationDirection(stationQuery, false);
      //
      // }
      //
      // await findSecondWalkDirection(
      //     LatLng(endStation['latitude'], endStation['longitude']),
      //     LatLng(
      //         endPointLatLng.value.latitude, endPointLatLng.value.longitude));
      // //locationController.tripCreatedStatus(true);
      // return;

    }
  }
  updatePinPos(double lat, double lng) {
    latPinLoc.value = lat;
    lngPinLoc.value = lng;
    update();
  }

  calFullDurationDistance(){
    //جمع كمل المدة الزمنية للرحلة
    fullDurationTrip.value =
    ((tripFirstWalkDirData['routes'][0]['duration']) / 120 +
        (tripSecondWalkDirData['routes'][0]['duration']) / 120 +
        (tripStationDirData['routes'][0]['duration']) / 120);
    startWalkDurationTrip.value = tripFirstWalkDirData['routes'][0]['duration'];
    secondWalkDurationTrip.value  = tripSecondWalkDirData['routes'][0]['duration'];
    routeDurationTrip.value = tripStationDirData['routes'][0]['duration'];

// distance
    fullDistanceTrip.value =
    ((tripFirstWalkDirData['routes'][0]['distance']) /1000 +
        (tripSecondWalkDirData['routes'][0]['distance']) /1000 +
        (tripStationDirData['routes'][0]['distance']) ) /1000;
    startWalkDistanceTrip.value = tripFirstWalkDirData['routes'][0]['distance'];
    secondWalkDistanceTrip.value  = tripSecondWalkDirData['routes'][0]['distance'];
    routeDistanceTrip.value = tripStationDirData['routes'][0]['distance'];


    if(isLongTrip.value ==true){
      secondRouteDurationTrip.value = tripStationDirData2['routes'][0]['duration'] /120;
      secondRouteDistanceTrip.value = tripStationDirData2['routes'][0]['distance']/1000;
      fullDurationTrip.value = fullDurationTrip.value + (tripStationDirData2['routes'][0]['duration']) / 120;
      fullDistanceTrip.value = fullDistanceTrip.value + (tripStationDirData2['routes'][0]['distance']) / 1000;

      update();
    }
    print("full distance :: ${fullDistanceTrip.value}");

    print(' full duration :: ${fullDurationTrip.value}');
  }
  callSaveTrip() async {
    //    save trip
    print('intIndex = $intIndex');
    trip.startStationId = tripRouteData['description']['startStation']['id'];
    trip.endStationId = tripRouteData['description']['endStation']['id'];
    trip.routeId = tripRouteData['description']['res'][0]['routeID'];
    trip.routeName = tripRouteData['description']['res'][0]['route'];
    trip.startPoint.latitude =
        tripRouteData['description']['startPoint']['latitude'];

    await tripController.saveTrip();
  }

  @override
  void onInit() {
    super.onInit();
  }
}
