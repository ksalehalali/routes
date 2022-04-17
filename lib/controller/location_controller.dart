import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;

import '../Assistants/assistantMethods.dart';
import '../Assistants/request-assistant.dart';
import '../Data/current_data.dart';
import '../config-maps.dart';
import '../model/address.dart';
import '../model/location.dart';
import '../model/placePredictions.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart' as loc ;

class LocationController extends GetxController {
  var pickUpAddress = ''.obs;
  var dropOffAddress = ''.obs;
  List placePredictionList = [].obs;
  var latPinLoc = 0.0.obs;
  var lngPinLoc = 0.0.obs;
  var startAddingPickUp = false.obs;
  var startAddingDropOff = false.obs;
  var buttonString = ''.obs;
  var addDropOff = false.obs;
  var addPickUp = false.obs;
  var tripCreatedDone = false.obs;
  var liveLocation = new LatLng(0.0, 0.0).obs;
  var currentLocation = new LatLng(0.0, 0.0).obs;
  var currentLocationG = new google_maps.LatLng(0.0, 0.0).obs;
  var liveLocationG = new google_maps.LatLng(0.0, 0.0).obs;
  var pickUpLocationAddress =''.obs;
  var dropOffLocationAddress = ''.obs;
  Address? pickUpLocation;
  Address? dropOffLocation ;
  var location = loc.Location();
  geo.Position? currentPosition;
  double bottomPaddingOfMap = 0;
  late loc.PermissionStatus _permissionGranted;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getLocation();
  }

  Future getLocation()async{
    loc.Location location = loc.Location.instance;
    geo.Position? currentPos;
    loc.PermissionStatus permissionStatus = await location.hasPermission();
    _permissionGranted = permissionStatus;
    if (_permissionGranted != loc.PermissionStatus.granted) {
      final loc.PermissionStatus permissionStatusReqResult =
      await location.requestPermission();

      _permissionGranted = permissionStatusReqResult;
    }

    geo.Position position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    gotMyLocation(true);
    addPickUp.value = true;
    changePickUpAddress('Current Location');

    print("--------------------========== position controller $position");
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    var assistantMethods = AssistantMethods();
    String address =
    await assistantMethods.searchCoordinateAddress(currentPosition!,true);
    trip.startPointAddress = address;
    trip.startPoint = LocationModel(latLngPosition.latitude, latLngPosition.longitude);
    gotMyLocation(true);
    changePickUpAddress(address);
    addPickUp.value = true;

  }

  void changePickUpAddress(String pickUpAddressV) {
    pickUpAddress.value = pickUpAddressV;
    update();
  }

  void changeDropOffAddress(String dropOffAddressV) {
    dropOffAddress.value = dropOffAddressV;
    update();
  }

  void startAddingPickUpStatus(bool status){
    startAddingPickUp.value = status;
    update();
  }
  void startAddingDropOffStatus(bool status){
    startAddingDropOff.value = status;
    update();
  }

  void tripCreatedStatus(bool status){
    tripCreatedDone.value = status;
    update();
  }

  refreshPlacePredictionList(){
    placePredictionList.clear();
    placePredictionList.add(
        PlaceShort(
            placeId: '0',
            mainText: 'Set Location on map',
            secondText: 'choose'
    ));
  }
  void updatePickUpLocationAddress( Address pickUpAddress){
    pickUpLocation = pickUpAddress;
    update();
  }

  void updateDropOffLocationAddress( Address dropOffAddress){
    dropOffLocation = dropOffAddress;
    update();
  }
  updateLiveLoc(LatLng latLng){
    liveLocation.value = latLng;
  }
  void findPlace(String placeName) async {
    if (placeName.length > 1) {

      placePredictionList.clear();
      String autoCompleteUrl =
          "https://api.mapbox.com/geocoding/v5/mapbox.places/$placeName.json?worldview=us&country=kw&access_token=$mapbox_token";

      var res = await RequestAssistant.getRequest(autoCompleteUrl);


      if (res == "failed") {
        print('failed');
        return;
      }
      if (res["features"] != null) {
        print(res['status']);
        var predictions = res["features"];

        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();

        //placePredictionList = placesList;
        placesList.forEach((element) {
          placePredictionList.add(PlaceShort(
              placeId: element.id,
              mainText: element.text,
              secondText: element.place_name,
            lat: element.lat,
            lng: element.lng
          ));
        });
        print(placePredictionList.first.mainText);
        update();
      }
    }
  }

  //
  RxBool gotMyLocation = false.obs;
  addMyLocation(bool got){
    gotMyLocation.value = got;
    update();
}

updatePinPos(double lat , double lng){
    latPinLoc.value = lat;
    lngPinLoc.value = lng;
    currentLocationG.value=google_maps.LatLng(lat,lng);
    update();
}

}

class PlaceShort {
  String? placeId;
  String? mainText;
  String? secondText;
  double? lat;
  double? lng;

  PlaceShort({this.mainText, this.placeId, this.secondText,this.lat,this.lng});

}
