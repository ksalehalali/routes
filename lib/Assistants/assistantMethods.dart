import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routes/Assistants/request-assistant.dart';

import '../Data/current_data.dart';
import '../config-maps.dart';
import '../controller/location_controller.dart';
import '../model/address.dart';
import '../model/directionDetails.dart';

class AssistantMethods {
  final LocationController locationController = Get.find();

  Future<String> searchCoordinateAddress(Position position, context, bool homeCall) async {
    String placeAddress = "";

    var res = await RequestAssistant.getRequest('https://api.mapbox.com/geocoding/v5/mapbox.places/${position.longitude},${position.latitude}.json?access_token=pk.eyJ1Ijoia2hhbGVkOTg4MjQiLCJhIjoiY2t6Mmg5NjlmMW5rZzJubXY4NTN4enp5YSJ9.37lqCbPUZEusWKQtoc_FIQ');
    if (res != "failed") {
      if (locationController.startAddingPickUp.value == true) {
        locationController.changePickUpAddress(res['features'][0]['place_name']);

      } else if(locationController.startAddingDropOff.value == true){
        locationController.changeDropOffAddress(res['features'][0]['place_name']);

      }
      placeAddress = res['features'][0]['place_name']  ;

      Address userAddress = new Address();
      userAddress.latitude = position.latitude;
      userAddress.longitude = position.longitude;
      userAddress.placeName = placeAddress;

    } else {
      print("get address failed");
    }

    return placeAddress;
  }

  //
   Future<DirectionDetails?> obtainDirectionDetails(
     ) async {
    String directionURL =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${trip.startPoint.latitude},${trip.startPoint.longitude}&origin=29.37477,47.994738;29.374678,47.99484;29.374527,47.995005&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionURL);

    if (res == "failed") {
      return null;
    }
    print("res :: $res");
    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];

    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];

    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static double calculateFares(DirectionDetails directionDetails) {
    double timeTraveledFare = (directionDetails.durationValue! / 60) * 0.20;
    double distanceTraveledFare =
        (directionDetails.distanceValue! / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    //convert to kd
    double totalKDAmount = totalFareAmount * 0.315;

    return totalKDAmount;
  }

  static void getCurrentOnLineUserInfo()async{



  }

  static double createRandomNumber (int num){
    var random = Random();
    int redNumber = random.nextInt(num);

    return redNumber.toDouble();
  }
}
