import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:routes/view/screens/profile/support.dart';
import 'package:url_launcher/url_launcher.dart';


// TODO url_launcher
class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Text(
                  'help_txt'.tr,
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
                  "all_topics_txt".tr
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
                        "help_with_a_trip_txt".tr
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
              GestureDetector(
                onTap: () {
                  Get.to(Support());
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
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
                            "account_and_payment_options".tr,
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
              ),
              SizedBox(height: 16.0),
              Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                color: Color.fromRGBO(240, 240, 240, 1),
                child: Text(
                    "need_help_now".tr,
                ),
              ),
              SizedBox(height: 16.0,),
              // ROW CALL SUPPORT
              GestureDetector(
                onTap: () {
                  launch("tel://21213123123");
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.call, color: Colors.black,),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                      SizedBox(width: 16,),
                      Container(
                        child: Text(
                            "call_support".tr,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
