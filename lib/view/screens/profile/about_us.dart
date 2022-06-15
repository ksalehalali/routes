import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Assistants/firebase_dynamic_link.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(240, 240, 240, 1),
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.black,),
              onPressed: () {
                Get.back();
              },
            ),
            backgroundColor: Colors.white.withOpacity(1.0),
            foregroundColor: Colors.white.withOpacity(1.0),
          ),
          body: Center(
            child: Container(
//          height: Get.size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // HELP TITLE
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    width: Get.width,
                    color: Colors.white,
                    alignment: Alignment.topLeft,
                    child: Text(
                      'About Us',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // ALL TOPICS
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    color: Color.fromRGBO(240, 240, 240, 1),
                    child: Text(
                        "All Topics"
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  // ROW HELP
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.menu_outlined, color: Colors.black,),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(width: 16,),
                        Container(
                          child: Text(
                              "........."
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 30,
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black54,),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        SizedBox(width: 16,),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 16.0,
                  ),
                  // ROW ACCOUNT

                  SizedBox(height: 16.0),
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    color: Color.fromRGBO(240, 240, 240, 1),
                    child: Text(
                        "......>"
                    ),
                  ),

                  // ROW CALL SUPPORT
                  GestureDetector(
                    onTap: () {
                     // FirebaseDynamicLinkService.createDynamicLink(false, '');
                    },
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.share, color: Colors.black,),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          SizedBox(width: 16,),
                          Container(
                            child: Text(
                                "Share App"
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 30,
                            child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black54,),
                              onPressed: () {

                              },
                            ),
                          ),
                          SizedBox(width: 16,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
