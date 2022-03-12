import 'dart:async';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:routes/view/screens/routes/all_routes_map.dart';
import '../../Assistants/assistantMethods.dart';
import '../../Assistants/globals.dart';
import '../widgets/destination_selection.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int navIndex = 3;
  double bottomPaddingOfMap = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethods.getCurrentOnLineUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = Get.size;
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height:screenSize.height *.1 -60,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.directions_bus_rounded,color: routes_color,size: 36,),
                SizedBox(width: 10.0,),
                Text('Routes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: routes_color2),),
              ],
            ),

            SizedBox(height:screenSize.height *.1 -80,),
            SizedBox(
              height: screenSize.height * .4,
              width: double.infinity,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AllRoutesMap()));
                },
                child: Carousel(
                  dotSize: 6.0,
                  dotSpacing: 15.0,
                  autoplayDuration: 4.seconds,
                  animationDuration: 500.milliseconds,
                  dotBgColor: routes_color.withOpacity(0.4),
                  dotColor: Colors.white,
                  dotIncreasedColor: Colors.red,
                  dotPosition: DotPosition.bottomCenter,
                  images: [
                    Image.asset('assets/images/bus/1.jpeg', fit: BoxFit.cover),
                    Image.asset('assets/images/bus/6a8c12b1fe.jpeg', fit: BoxFit.cover),
                    Image.asset('assets/images/bus/a62b7b51-fbdc-4a0e-938f-ed8cccd2c8bc.jpeg', fit: BoxFit.cover),
                    Image.asset('assets/images/bus/slide2.jpeg', fit: BoxFit.cover),
                    Image.asset('assets/images/routes_fullBlue_logo.jpeg', fit: BoxFit.cover),


                  ],
                ),
              ),
            ),
            SizedBox(height: screenSize.height *.1 ,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DestinationSelection(),
            ),
          ],
        ),
      ),


    );
  }

}