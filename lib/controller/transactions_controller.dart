import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../Assistants/globals.dart';
import '../model/tripModel.dart';
import '../model/trip_to_save_model.dart';

class TransactionsController extends GetxController {
  var transactions = [].obs;

  Future<void> getMyTrips()async{
    transactions.value = [];
    final response = await http.get(Uri.parse(
        "https://route.click68.com/api/ListTripByUser"),headers: {"Authorization":"bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJOYW1lIjoia2hhbGVkOTkiLCJSb2xlIjoiVXNlciIsImV4cCI6MTY0NzE3MTAwNSwiaXNzIjoiSW52ZW50b3J5QXV0aGVudGljYXRpb25TZXJ2ZXIiLCJhdWQiOiJJbnZlbnRvcnlTZXJ2aWNlUG90bWFuQ2xpZW50In0.BSSgbxyc5wrngBnqOnX-J0C9fkUzAb2RASXtrjFZmPc"});

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      //print('trips ::  ${response.body}');
      transactions.addAll(decoded['description']);
      print(transactions);
      update();
    } else {
      print('11111NNNOOOOOONnonooooOOO ${response.statusCode}');
    }
    update();
  }

  Future<void> saveTransaction(TripToSave tripToSave)async{
    print('object');


    final body = {
      "StartStationID":tripToSave.startStationID,
      "RouteID": tripToSave.routeID,
      "EndStationID": tripToSave.endStationID,
      "StartPointLong": tripToSave.startPointLong,
      "StartPointLut": tripToSave.startPointLut,
      "EndPointLong": tripToSave.endPointLong,
      "EndPointLut": tripToSave.endPointLut
    };

    final url = Uri.parse(baseURL + "/api/CreateTrip");

    final headers = {
      "Content-type": "application/json",
      "Authorization": "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJOYW1lIjoia2hhbGVkOTkiLCJSb2xlIjoiVXNlciIsImV4cCI6MTY0NzE3MTAwNSwiaXNzIjoiSW52ZW50b3J5QXV0aGVudGljYXRpb25TZXJ2ZXIiLCJhdWQiOiJJbnZlbnRvcnlTZXJ2aWNlUG90bWFuQ2xpZW50In0.BSSgbxyc5wrngBnqOnX-J0C9fkUzAb2RASXtrjFZmPc",
    };

    final response2 =
    await post(url, headers: headers, body: jsonEncode(body));

    if (response2.statusCode == 200) {
      var decoded = jsonDecode(response2.body);
      print('trip save ::  ${response2.body}');
      update();
    } else {
      print('error save trip ${response2.body}');
    }
  }


}