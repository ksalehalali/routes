
import 'dart:convert';

class PlacePredictions {
  String? place_name;
  String? text;
  String? id;
  double? lat;
  double? lng;

  PlacePredictions({this.text, this.place_name ,this.id});
  PlacePredictions.fromJson(Map<String, dynamic> json){
    id =json["id"];
    text =json["text"];
    place_name =json["place_name"];
    lat = json["center"][1];
    lng = json["center"][0];

  }

}