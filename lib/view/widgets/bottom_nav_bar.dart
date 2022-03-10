import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

Widget btmNavBar() {
  int index = 1;
  return NavigationBar(
      height: 62.0,
      backgroundColor: Colors.white,
      selectedIndex: index,
      onDestinationSelected: (index){

      },
      destinations: [
    NavigationBarTheme(
        data: NavigationBarThemeData(indicatorColor: Colors.blue,labelTextStyle: MaterialStateProperty.all(
          TextStyle(fontSize: 18)
        )),
        child: NavigationDestination(icon: Icon(Icons.home), label: 'Home')),
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),

  ]);
}
