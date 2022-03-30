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
  var jsonResponse;

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
    final queryParameters = {
      "StartStationID": trip.startStationId,
      "RouteID": trip.routeId,
      "EndStationID": trip.endStationId,
      "StartPointLong": trip.startPoint.longitude,
      "StartPointLut":trip.startPoint.latitude,
      "EndPointLong": trip.endPoint.longitude,
      "EndPointLut":trip.endPoint.latitude
    };

    print(queryParameters);
    final url = Uri.parse(baseURL + "/api/CreateTrip");

    final response = await http.post(url,
        headers: headers, body: jsonEncode(queryParameters));

    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      tripToSave.id = jsonResponse['description']['id'];
    }

  }



}