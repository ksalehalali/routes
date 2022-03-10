import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../Assistants/globals.dart';
import '../Data/current_data.dart';
import '../model/tripModel.dart';

class TripController extends GetxController {
  var trips = [].obs;
  var total = 0.obs;
  Future<void> getMyTrips()async{

    trips.clear() ;
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/ListTripByUser'));
    request.body = json.encode({
      "PageNumber": 1,
      "PageSize": 10
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      total.value = json['total'];
      var data = json['description'];
      print(data);
      trips.addAll(data);
      update();
    }
    else {
      print(response.reasonPhrase);
    }

  }


  Future<void> saveTrip()async{
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/CreateTrip'));
    request.body = json.encode({
      "StartStationID": trip.startStationId,
      "RouteID": trip.routeId,
      "EndStationID": trip.endStationId,
      "StartPointLong": trip.startPoint.longitude,
      "StartPointLut":trip.startPoint.latitude,
      "EndPointLong": trip.endPoint.longitude,
      "EndPointLut":trip.endPoint.latitude
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
       var json = jsonDecode(await response.stream.bytesToString());
      // print("trip id :: ${json['description']['id']}");
       tripToSave.id = json['description']['id'];
    }
    else {
      print(response.reasonPhrase);
    }

  }


}