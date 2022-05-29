import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../Assistants/globals.dart';
import '../../Assistants/request-assistant.dart';
import '../../Data/current_data.dart';
import '../../config-maps.dart';
import '../../controller/location_controller.dart';
import '../../controller/route_map_controller.dart';
import '../../model/address.dart';
import '../../model/placePredictions.dart';
import '../map.dart';
import '../widgets/divider.dart';
import '../widgets/dialogs.dart';
import 'main_screen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

bool pickUpFilling = false;
TextEditingController pickUpController = TextEditingController();

TextEditingController dropOffController = TextEditingController();

class _SearchScreenState extends State<SearchScreen> {
  FocusNode? focusNodePickUp;
  FocusNode? focusNodeDropOff;
  final LocationController locationController = Get.find();

  // List<PlacePredictions> placePredictionList =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationController.refreshPlacePredictionList();
    focusNodeDropOff = FocusNode();
    focusNodePickUp = FocusNode();
    if(locationController.addDropOff.value ==true){
      dropOffController.text = locationController.dropOffAddress.value;
    }else if(locationController.addPickUp.value == true){
      pickUpController.text = locationController.pickUpAddress.value;
    }else{
      pickUpController.text = '';
      dropOffController.text = '';
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNodeDropOff!.dispose();
    focusNodePickUp!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Get.size;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 199.0,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.blue[900]!,
                blurRadius: 6.0,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              )
            ]),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 12.0, top: 20.0, right: 12.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 26.0,
                  ),
                  Stack(
                    children: [
                      InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(indexOfScreen: 0,)));
                          },
                          child: Icon(Icons.arrow_back)),
                      Center(
                        child: Text(
                          "set_pickup_rop_off_txt".tr,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green
                        ),
                        height: 10,
                        width: 10,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text('from_txt'.tr,style: TextStyle(color: Colors.grey,fontSize: 16),),
                      SizedBox(
                        width: 8.0,
                      ),
                      Spacer(),
                      Obx(() {
                        return SizedBox(
                          width:screenSize.width <400? 270:280,
                          height: 35,
                          child: TextFormField(
                            controller: pickUpController,
                            focusNode: focusNodePickUp,
                            onTap: () {
                              pickUpFilling = true;
                              locationController.startAddingPickUpStatus(true);
                              locationController.startAddingDropOffStatus(false);
                            },
                            onChanged: (val) {
                              locationController.startAddingPickUpStatus(true);
                              locationController.startAddingDropOffStatus(false);
                              pickUpFilling = true;
                              locationController.findPlace(val);
                            },
                            onFieldSubmitted: (val) {
                              FocusScope.of(context)
                                  .requestFocus(focusNodeDropOff);
                            },
                            decoration: InputDecoration(
                              hintText: locationController
                                          .gotMyLocation.value ==
                                      true
                                  ? locationController.pickUpAddress.value
                                  : 'loading..._txt'.tr,
                              hintStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: locationController
                                              .gotMyLocation.value ==
                                          true
                                      ? Colors.blue[900]
                                      : Colors.red),
                              fillColor: Colors.grey[300],
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  left: 9.0, top: 7.0, bottom: 2.0),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                     Container(
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(20),
                         color: Colors.red[900]
                       ),
                       height: 10,
                       width: 10,
                     ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text('to_txt'.tr,style: TextStyle(color: Colors.grey,fontSize: 16),),

                      SizedBox(
                        width: 18.0,
                      ),
                      Spacer(),

                      SizedBox(
                        width:screenSize.width < 400? 270:280,
                        height: 35,
                        child: TextFormField(
                          focusNode: focusNodeDropOff,
                          autofocus: true,
                          onChanged: (val) {
                            pickUpFilling = false;
                            locationController.startAddingPickUpStatus(false);
                            locationController.startAddingDropOffStatus(true);
                            print(locationController.startAddingDropOff.value);
                            locationController.findPlace(val);
                          },
                          onTap: () {
                            pickUpFilling = false;
                            locationController.startAddingPickUpStatus(false);
                            locationController.startAddingDropOffStatus(true);
                          },
                          controller: dropOffController,
                          decoration: InputDecoration(
                            hintText: "where_To?_txt".tr,
                            hintStyle: TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                            fillColor: Colors.grey[300],
                            filled: true,
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(
                                left: 9.0, top: 7.0, bottom: 7.0),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          //tile for predictions
          Obx(() {
            return Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) => PredictionTile(
                      placePredictions:
                          locationController.placePredictionList[index],
                    ),
                    itemCount: locationController.placePredictionList.length,
                    separatorBuilder: (BuildContext context, index) =>
                        DividerWidget(),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  )),
            );
          })
        ],
      ),
    );
  }

}

class PredictionTile extends StatelessWidget {
  final PlaceShort? placePredictions;

  PredictionTile({Key? key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.find();

    return InkWell(
      onTap: () {
        Address address = Address(
          placeName: placePredictions!.mainText,
        );

        if (placePredictions!.placeId == '0') {
          initialPoint.latitude = locationController.currentLocation.value.latitude;
          initialPoint.longitude = locationController.currentLocation.value.longitude;
          locationController.buttonString.value = 'confirm_drop_off_spot_txt'.tr;
          locationController.startAddingDropOff.value = true;
          locationController.startAddingPickUpStatus(false);
          locationController.startAddingDropOffStatus(true);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Map()),
                  (route) => false);
        } else {
          getPlaceAddressDetails(placePredictions!.placeId!, context);
          //print(placePredictions!.placeId);

          initialPoint.latitude = placePredictions!.lat!;
          initialPoint.longitude = placePredictions!.lng!;
          locationController.showPinOnMap.value = true;

          if (pickUpFilling == false) {

            locationController.buttonString.value = 'confirm_drop_off_spot_txt'.tr;
            locationController.updatePickUpLocationAddress(address);

            trip.endPointAddress =
                "${placePredictions!.mainText!} ,${placePredictions!.secondText!}";
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Map()),
                (route) => false);
          } else {
           locationController.updateDropOffLocationAddress(address);
            locationController.buttonString.value = 'confirm_pick_up_spot_txt'.tr;

            trip.startPointAddress =
                "${placePredictions!.mainText!} ,${placePredictions!.secondText!}";
            locationController.changePickUpAddress(
                "${placePredictions!.mainText!} ,${placePredictions!.secondText!}");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Map()),
                (route) => false);
          }
        }

      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 10.0,
            ),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placePredictions!.mainText!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        placePredictions!.secondText!,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                      ),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 14.0,
            ),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    final LocationController locationController = Get.find();
    final RouteMapController routeMapController = Get.find();

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Setting DropOff , Please wait ...",
            ));

    String placeDetailsURL =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var res = await RequestAssistant.getRequest(placeDetailsURL);

    if (res == "failed") {
      return;
    }

    if (res["status"] == "OK") {
      Address address = Address();

      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      initialPoint.latitude = address.latitude!;
      initialPoint.longitude = address.longitude!;
      locationController.updateDropOffLocationAddress(address);

      locationController.positionFromPin.value = Position(
       longitude:address.longitude!,
       latitude: address.latitude!,
       speedAccuracy: 1.0,
       altitude:  address.latitude!,
       speed: 1.0,
       heading: 1.0,
       timestamp: DateTime.now(),
       accuracy: 1.0,
     );
      print("this drop off location :: ${address.placeName}");
      print(
          "this drop off location :: lat ${address.latitude} ,long ${address.longitude}");
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Map()), (route) => false);
    }
  }
}
