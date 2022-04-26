import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black,),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white.withOpacity(1.0),
        foregroundColor: Colors.white.withOpacity(1.0),
      ),
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TITLE HELP
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                width: Get.width,
                color: Colors.white,
                alignment: Alignment.topLeft,
                child: Text(
                  'Help',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // TITLE OPTIONS
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                width: Get.width,
                color: Colors.white,
                alignment: Alignment.topLeft,
                child: Text(
                  'Account and Payment Options',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  launch("tel://21213123123");
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.insert_drive_file_rounded, color: Colors.black,),
                          onPressed: () {
                          },
                        ),
                      ),
                      SizedBox(width: 16,),
                      Container(
                        child: Text(
                            "I need to contact support"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
