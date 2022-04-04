import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../Assistants/globals.dart';
import '../Data/current_data.dart';
import '../config-maps.dart';
import '../view/screens/routes/all_routes_map.dart';

class AllRoutes extends GetxController {
  var routePoints = <LatLng>[].obs;
  var routeStations = {}.obs;
  RxInt centerIndex = 0.obs;
  var jsonResponse;
  var markersStations = <Marker>[].obs;
  var routePolyLine = <Polyline>[].obs;
  var allStation = [].obs;
  String stationQuery = "";
  String stationQuery2 = "";
  String stationQuery3 = "";
  String stationQuery4 = "";
  var isDrawing = false.obs;
  var isSearching = false.obs;
  CameraPosition? cameraPosition ;

  var stationLocationPoints = <LatLng>[].obs;
  var stationLocationPoints2 = <LatLng>[].obs;

  Future getStationsRoute(String routeId) async {
    reset();
    final queryParameters = {'id': routeId,
      "PageNumber": 0,
      "PageSize":120
    };

    print(queryParameters);
    final url = Uri.parse(baseURL + "/api/ListStationByRouteID");
    final headers = {
      "Content-type": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJOYW1lIjoiUm91dGVTdGF0aW9uIiwiUm9sZSI6InN1cGVyQWRtaW4iLCJleHAiOjE2NDkzOTgxMDEsImlzcyI6IkludmVudG9yeUF1dGhlbnRpY2F0aW9uU2VydmVyIiwiYXVkIjoiSW52ZW50b3J5U2VydmljZVBvdG1hbkNsaWVudCJ9.TIiNpFfP3H6n1qfhR7cGi6WVxUDHhHgZE2wFx9HkNUc",
    };

    final response = await http.post(url,
        headers: headers, body: jsonEncode(queryParameters));

    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      print(jsonResponse['description'].length);

      jsonResponse = jsonResponse['description'];
      if(jsonResponse.length <1){
        Get.snackbar(
            'there is no stations', 'please try change the route',
            backgroundColor: Colors.white,
            duration: 5.seconds, colorText: Colors.red[900]);
        stationLocationPoints.value = [];
        stationLocationPoints2.value = [];
        markersStations.value = [];
        routePolyLine.value =[];

        return;}
      int l =jsonResponse.length;
      var c = l/4;
      centerIndex.value = c.round();
      if (jsonResponse.length > 74) {
        print('stations > 74');
        for (int i = 0; i < 24; i++) {
          print(jsonResponse[i]);
          stationQuery = stationQuery +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));

        }

        for (int i = 24; i < 49; i++) {
          print(jsonResponse[i]);
          stationQuery2 = stationQuery2 +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
        }

        /// for more points
        for (int i = 49; i < 74; i++) {
          print(jsonResponse[i]);
          stationQuery3 = stationQuery3 +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
        }

        for (int i = 74; i < jsonResponse.length; i++) {
          print(jsonResponse[i]);
          stationQuery4 = stationQuery4 +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
        }

        stationQuery = stationQuery.substring(
            0,
            stationQuery.length -
                1); // To remove the last semicolon from the string (would cause an error)
        stationQuery2 = stationQuery2.substring(0, stationQuery2.length - 1);

        stationQuery3 = stationQuery3.substring(
            0,
            stationQuery3.length -
                1); // To remove the last semicolon from the string (would cause an error)
        stationQuery4 = stationQuery4.substring(0, stationQuery4.length - 1);
      } else if (jsonResponse.length <= 74 && jsonResponse.length > 50) {
        print('stations <= 74 && > 50');
        for (int i = 0; i < 24; i++) {
          print(jsonResponse[i]);
          stationQuery = stationQuery +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));

        }

        for (int i = 24; i < 49; i++) {
          print(jsonResponse[i]);
          stationQuery2 = stationQuery2 +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
        }

        /// for more points
        for (int i = 49; i < jsonResponse.length; i++) {
          print(jsonResponse[i]);
          stationQuery3 = stationQuery3 +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
        }

        stationQuery = stationQuery.substring(
            0,
            stationQuery.length -
                1); // To remove the last semicolon from the string (would cause an error)
        stationQuery2 = stationQuery2.substring(0, stationQuery2.length - 1);

        stationQuery3 = stationQuery3.substring(
            0,
            stationQuery3.length -
                1); // To remove the last semicolon from the string (would cause an

      } else if (jsonResponse.length <= 50 && jsonResponse.length > 25) {
        print('stations < 50 && >25 ');

        for (int i = 0; i < 24; i++) {
          print(jsonResponse[i]);

          stationQuery = stationQuery +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
        }

        for (int i = 24; i < jsonResponse.length; i++) {
          print(jsonResponse[i]);

          stationQuery2 = stationQuery2 +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
        }

        stationQuery = stationQuery.substring(
            0,
            stationQuery.length -
                1); // To remove the last semicolon from the string (would cause an error)
        stationQuery2 = stationQuery2.substring(0, stationQuery2.length - 1);
      }
      else if (jsonResponse.length < 25 && jsonResponse.length >0 ) {
        print('stations < 25 ');

        for (int i = 0; i < jsonResponse.length; i++) {
          stationQuery = stationQuery +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
        }

        stationQuery = stationQuery.substring(
            0,
            stationQuery.length -
                1); // To remove the last semicolon from the string (would cause an error)
      }
    }

    //add markers
    for (int i = 0; i < stationLocationPoints.length; i++) {
      markersStations.add(Marker(
        markerId: MarkerId('marker$i'),
        position: LatLng(stationLocationPoints[i].latitude,
            stationLocationPoints[i].longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue,),
        infoWindow: InfoWindow(title: '${jsonResponse[i]['title_Station']}',snippet: '${jsonResponse[i]['order']}',)
      ));
    }

    if (jsonResponse.length > 74) {
      await findStationDirection(stationQuery, false);
      await findStationDirection(stationQuery2, false);
      await findStationDirection(stationQuery3, false);
      await findStationDirection(stationQuery4, false);
      cameraPosition = CameraPosition(target:LatLng(stationLocationPoints[centerIndex.value].latitude,stationLocationPoints[centerIndex.value].longitude),zoom: 12.0 );
      homeMapController!.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition!));
    } else if (jsonResponse.length <= 75 && jsonResponse.length > 49) {
      await findStationDirection(stationQuery, false);

      await findStationDirection(stationQuery2, false);

      await findStationDirection(stationQuery3, false);
      cameraPosition = CameraPosition(target:LatLng(stationLocationPoints[centerIndex.value].latitude,stationLocationPoints[centerIndex.value].longitude),zoom: 12 );
      homeMapController!.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition!));
    }else if(jsonResponse.length <= 49 && jsonResponse.length > 24 ){
      await findStationDirection(stationQuery, false);

       await findStationDirection(stationQuery2, false);
      cameraPosition = CameraPosition(target:LatLng(stationLocationPoints[centerIndex.value].latitude,stationLocationPoints[centerIndex.value].longitude),zoom: 12 );
      homeMapController!.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition!));
    }else if( jsonResponse.length < 24){
      await findStationDirection(stationQuery, false);
      cameraPosition = CameraPosition(target:LatLng(stationLocationPoints[centerIndex.value].latitude,stationLocationPoints[centerIndex.value].longitude),zoom: 12 );
      homeMapController!.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition!));
    }
    update();
  }

  //
  Future<void> findStationDirection(String stationQuery, bool isSecond) async {

    if (isSecond == false) {
      int i = 0;
      final response = await http.get(Uri.parse(
          "https://api.mapbox.com/directions/v5/mapbox/driving/$stationQuery?alternatives=true&annotations=distance%2Cduration%2Cspeed%2Ccongestion&geometries=geojson&language=en&overview=full&access_token=$mapbox_token"));
      //print('full res from find == ${response.body}');
      if (response.statusCode == 200) {
        isDrawing.value =true;
        isSearching.value=false;
        print('true 1 ${response.statusCode}');
        var decoded = jsonDecode(response.body);
        decoded = decoded["routes"][0]["geometry"];
        for (int i = 0; i < decoded["coordinates"].length; i++) {
          i=i;
          routePoints.add(new LatLng(
              decoded["coordinates"][i][1], decoded["coordinates"][i][0]));
          update();
        }
        routePolyLine.add(Polyline(polylineId: PolylineId('s$i'),points: routePoints,
          color: Colors.red.withOpacity(0.8),
          jointType: JointType.round,
          width: 5,
          startCap:Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
        ));
        update();
      } else {
        print('error :: ${response.body}');
        print('status code ${response.statusCode} \n${stationQuery}');
        return;
      }
    }
  }

  reset() {
    isDrawing.value = false;
    stationLocationPoints.value = [];
    stationLocationPoints2.value = [];
    jsonResponse = {};
    routePoints.value = [];
    stationQuery = '';
    stationQuery2 = '';
    stationQuery3 = '';
    stationQuery4 = '';
    markersStations.value = [];
    centerIndex.value =0;


    update();
  }
}
