import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../Assistants/globals.dart';
import '../../Data/current_data.dart';
import '../../controller/payment_controller.dart';
import '../widgets/progressDialog.dart';

class DirectPayment extends StatefulWidget {
  @override
  State<DirectPayment> createState() => _DirectPaymentState();
}

class _DirectPaymentState extends State<DirectPayment> {
  final PaymentController paymentController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(100.milliseconds, () {
      if (paymentController.directPaymentDone.value == true) {
        showDialog(
            context: context,
            builder: (BuildContext context) => SizedBox(
              width: 300,
              child: ProgressDialogShowPayment(
                message: "Please wait ...",
              ),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Image.asset(
                "${assetsDir}qrCode.jpg",
                width: MediaQuery.of(context).size.width * 0.66,
              ),
              Spacer(),
              // QR SCAN BUTTON
              Container(
                child: ElevatedButton(
                  onPressed: () async{
                    String balance = await checkWallet();
                    double balanceNum = double.parse(balance);
                    if(balanceNum >= 200.0) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>QRViewExample()));
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
                    "Scan QR Code",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      maximumSize: Size(Get.size.width -90,Get.size.width -90),
                      minimumSize: Size(Get.size.width -90, 40),primary: routes_color,
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
    );
  }

  Future<String> checkWallet() async{
    await paymentController.getMyWallet();
    return paymentController.myBalance.value;
  }

}



// QR Code Scanner
class QRViewExample extends StatefulWidget {
  BuildContext? context;
  QRViewExample({Key? key,this.context}) : super(key: key);

  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final PaymentController paymentController = Get.find();

  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                  'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async{
      result = scanData;
      print(scanData.code);
      controller.stopCamera();
      var json = jsonDecode(result!.code!);
      tripToSave.busId = json['busId'];
      paymentSaved.busId = json['busId'];
      paymentSaved.routeId = json['routeId'];
      paymentSaved.value = json['value'];

      var pay = await paymentController.pay(true);

      if(pay ==true){
        print(pay);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DirectPayment()));

      }else{
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DirectPayment()));
        print(pay);
      }

    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
