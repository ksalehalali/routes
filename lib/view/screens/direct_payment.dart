import 'dart:async';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../Assistants/globals.dart';
import '../../controller/location_controller.dart';
import '../../controller/payment_controller.dart';
import '../widgets/QRCodeScanner.dart';
import '../widgets/headerDesgin.dart';

class DirectPayment extends StatefulWidget {
  @override
  State<DirectPayment> createState() => _DirectPaymentState();
}

class _DirectPaymentState extends State<DirectPayment> {
  final PaymentController paymentController = Get.find();
  final LocationController locationController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Get.size;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [

            routes_color6,
            routes_color,
          ]
          )
      ),
      child: SafeArea(
        child: Scaffold(
          body: Obx(()=>Stack(
              children: [
                Positioned(
                    top: 0.0,
                    child: SizedBox(
                        height: screenSize.height*0.1+11,
                        width: screenSize.width,
                        child: Header(screenSize))),
               Positioned(
                  top:screenSize.height *0.1 +50,
                  child: SizedBox(
                    height: screenSize.height,
                    width: screenSize.width,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 16,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Start direct payment by scanning the QR code via your camera",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 16,),
                          DelayedDisplay(
                            child: Image.asset(
                              "${assetsDir}scanqrcode2.png",
                             // width: MediaQuery.of(context).size.width * 0.66,
                            ),
                          ),
                         SizedBox(height: screenSize.height*0.1-20,),
                          // QR SCAN BUTTON
                          Container(
                            child: ElevatedButton(
                              onPressed: () async{
                                String balance = await checkWallet();
                                double balanceNum = double.parse(balance);
                                if(balanceNum >= 0.200) {
                                 setState(() {
                                   paymentController.openCam.value =true;
                                 });
                                } else {
                                Fluttertoast.showToast(
                                msg: "Remaining amount $balanceNum is not enough to complete the payment",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white70,
                                textColor: Colors.black,
                                fontSize: 16.0);
                                }
                              },
                              child: Text(
                                "Scan",
                                style: TextStyle(
                                  fontSize: 17,
                                  letterSpacing: 1
                                ),
                              ),
                              style: ElevatedButton.styleFrom(

                                  maximumSize: Size(Get.size.width -90,Get.size.width -90),
                                  minimumSize: Size(Get.size.width -90, 40),primary: routes_color2,
                                  onPrimary: Colors.white,
                                  alignment: Alignment.center
                              ),
                            ),

                          ),
                          SizedBox(height: 32,)
                        ],
                      ),
                    ),
                  ),
                ),
                paymentController.openCam.value ==true? QRScanner(isDirectPay: true,):Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> checkWallet() async{
    await paymentController.getMyWallet();
    return paymentController.myBalance.value;
  }

}

