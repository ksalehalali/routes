import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../Assistants/globals.dart';
import '../Data/current_data.dart';
import '../config-maps.dart';

class AllRoutes extends GetxController {
  var routePoints = <LatLng>[].obs;
  var routeStations = {}.obs;
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

  var stationLocationPoints = <LatLng>[].obs;
  var stationLocationPoints2 = <LatLng>[].obs;

  Future getStationsRoute(String routeId) async {
    reset();
    final queryParameters = {'id': routeId};

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

      if (jsonResponse.length > 74) {
        for (int i = 0; i < 25; i++) {
          stationQuery = stationQuery +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));

        }

        for (int i = 24; i < 49; i++) {
          stationQuery2 = stationQuery2 +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
        }

        /// for more points
        for (int i = 48; i < 74; i++) {
          stationQuery3 = stationQuery3 +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
        }

        for (int i = 74; i < 99; i++) {
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
      } else if (jsonResponse.length <= 75 && jsonResponse.length > 50) {
        print('less than 25 points');
        for (int i = 0; i < 24; i++) {
          stationQuery = stationQuery +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));

        }

        for (int i = 24; i < 49; i++) {
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
        for (int i = 0; i < 25; i++) {
          stationQuery = stationQuery +
              jsonResponse[i]["longitude"].toString() +
              "," +
              jsonResponse[i]["latitude"].toString() +
              ";";
          stationLocationPoints.add(new LatLng(
              jsonResponse[i]["latitude"], jsonResponse[i]["longitude"]));
        }

        for (int i = 24; i < jsonResponse.length; i++) {
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
      findStationDirection(stationQuery, false);
      findStationDirection(stationQuery2, false);
      findStationDirection(stationQuery3, false);
      findStationDirection(stationQuery4, false);
    } else if (jsonResponse.length <= 75 && jsonResponse.length > 50) {
      await findStationDirection(stationQuery, false);

      await findStationDirection(stationQuery2, false);

      findStationDirection(stationQuery3, false);
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
        print('all route no ${response.statusCode} \n${stationQuery}');
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


    update();
  }
}
