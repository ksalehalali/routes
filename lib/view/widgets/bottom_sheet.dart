import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

Widget slidingSheet(controller){
  return SlidingUpPanel(
      controller: controller,
      backdropColor: Colors.white,
      parallaxEnabled: true,
      panel: Center(
        child: Text('SSSS'),
      ),
      maxHeight: 200,//screenSize.height *0.5,
      minHeight: 100,//screenSize.height *0.2,
      body: Text('AAAAAAAAA'),
  panelBuilder: (controller) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children: [
          Text('BBBBBBB')
        ],
      ),);
  });}
