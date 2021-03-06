// QR Code Scanner
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../Data/current_data.dart';
import '../../controller/payment_controller.dart';
import 'package:routes/view/map.dart';

class QRScanner extends StatefulWidget {
  final bool isDirectPay;
  BuildContext? context;

  QRScanner({Key? key, this.context,required this.isDirectPay}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final PaymentController paymentController = Get.find();

  Barcode? result;
  QRViewController? controller;

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
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            paymentController.openCam.value =false;
          },
          child: Icon(Icons.arrow_back),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0.0,
      ),
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
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      print(scanData.code);
      controller.stopCamera();
      var json = jsonDecode(result!.code!);
      tripToSave.busId = json['busId'];
      paymentSaved.busId = json['busId'];
      paymentSaved.routeId = json['routeId'];
      paymentSaved.value = json['value'];

     if(widget.isDirectPay ==true){

      // for(int i =0; i<200;i++){
      //  Timer(5.milliseconds, ()async{
         var pay = await paymentController.pay(true);
         if (pay == true) {
           print(pay);
         } else {
           print(pay);
         }
      // });
     // }
     }else{
       var pay = await paymentController.pay(false);
       if (pay == true) {
         print(pay);
       } else {
         print(pay);
       }
     }

    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
