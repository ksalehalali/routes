import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routes/view/screens/routes/all_routes_map.dart';
import '../../Assistants/assistantMethods.dart';
import '../../Assistants/globals.dart';
import '../widgets/destination_selection.dart';
import '../widgets/headerDesgin.dart';
import 'destination_selection_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int navIndex = 3;
  double bottomPaddingOfMap = 0;
  CameraPosition cameraPosition =CameraPosition(target: LatLng(29.370314422169248, 47.98216642044717),zoom: 14.0);
  Completer<GoogleMapController> _controllerMaps = Completer();
  bool showDisSelection = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethods.getCurrentOnLineUserInfo();
  }
  //
  void locatePosition() async {
    print("on crate map");
    LatLng latLngPosition =
    LatLng(initialPointToFirstMap.latitude, initialPointToFirstMap.longitude);

    CameraPosition cameraPosition =
    new CameraPosition(target: latLngPosition, zoom: 15);
    print("init point $initialPoint");
    newGoogleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));
    // var assistantMethods = AssistantMethods();
    // String address = await assistantMethods.searchCoordinateAddress(
    //     position, context, false);
    // print(address);
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = Get.size;
    print(screenSize.height * .4,);
    print(screenSize.width ,);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [

            routes_color6,
            routes_color,
          ]
          )
              ,
        color: Colors.white
      ),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              SizedBox(
                  height: screenSize.height ,
                  width: screenSize.width,
                  child: GoogleMap(initialCameraPosition: cameraPosition,
                    mapToolbarEnabled: true,

                    padding: EdgeInsets.only(top: 100,bottom: 140),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,

                    onMapCreated: (GoogleMapController controller) {
                      _controllerMaps.complete(controller);
                      newGoogleMapController = controller;
                      setState(() {
                        bottomPaddingOfMap = 320.0;
                      });
                      locatePosition();
                    },
                  ),
              ),
              // SizedBox(
              //   height: screenSize.height * .4,
              //   width: double.infinity,
              //   child: InkWell(
              //     onTap: (){
              //       Navigator.push(context, MaterialPageRoute(builder: (context)=>AllRoutesMap()));
              //     },
              //     child: Carousel(
              //       dotSize: 6.0,
              //       dotSpacing: 15.0,
              //       autoplayDuration: 6.seconds,
              //       showIndicator: true,
              //       animationDuration: 600.milliseconds,
              //       dotBgColor: routes_color.withOpacity(0.4),
              //       dotColor: Colors.white,
              //       dotIncreasedColor: Colors.red,
              //       dotPosition: DotPosition.bottomCenter,
              //       images: [
              //         Image.asset('assets/images/routes/fc3cde7b3a4645919cfedda7a46dc87c-0001.jpeg', fit: BoxFit.fill),
              //         Image.asset('assets/images/bus/kgl.jpeg', fit: BoxFit.fill),
              //         // Image.asset('assets/images/bus/a62b7b51-fbdc-4a0e-938f-ed8cccd2c8bc.jpeg', fit: BoxFit.cover),
              //         // Image.asset('assets/images/bus/slide2.jpeg', fit: BoxFit.cover),
              //         // Image.asset('assets/images/routes_fullBlue_logo.jpeg', fit: BoxFit.cover),
              //
              //
              //       ],
              //     ),
              //   ),
              // ),
             // SizedBox(height: screenSize.height *.1 ,),
            Positioned(
                top: screenSize.height *0.8 -80,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(18),topRight: Radius.circular(18))
                  ),
                  height: screenSize.height *0.2+50,
                  width: screenSize.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            width: 38.0,
                            height: 5.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Text('Where to?',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[900],fontSize: 22),),
                      ),


                      Center(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 1,right: 22,left: 22),
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: routes_color7.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 8.0,),
                                SvgPicture.asset("assets/icons/search.svg", width: 28, color: Colors.grey[900],),
                                SizedBox(width: 8.0,),
                                Text('Enter your destination',style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey[500]),)
                              ],
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 0.0,
                  child: SizedBox(
                      height: screenSize.height*0.1,
                      width: screenSize.width,
                      child: Header(screenSize))),
            ],
          ),


        ),
      ),
    );
  }

}