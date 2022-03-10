import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Assistants/globals.dart';
import '../view/screens/Auth/reset_password.dart';

class ConfirmNumberController extends GetxController {
  RxString phoneNum = "".obs;

  Future<void> makeCodeConfirmationRequest() async{

    List<String> codeCredentials = [
      phoneNum.value.replaceAll("+", ""),
    ];

    var head = {
      "Accept": "application/json",
      "content-type":"application/json"
    };

    if (codeCredentials[0].isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter your number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0);
    } else {
      var response = await http.post(Uri.parse(baseURL + "/api/RestUser"), body: jsonEncode(
        {
          "UserName": "${codeCredentials[0]}",
        },
      ), headers: head
      ).timeout(const Duration(seconds: 20), onTimeout:() {
        Fluttertoast.showToast(
            msg: "The connection has timed out, Please try again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white70,
            textColor: Colors.black,
            fontSize: 16.0
        );
        throw TimeoutException('The connection has timed out, Please try again!');
      });

      if(response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if(jsonResponse["status"]){
          Fluttertoast.showToast(
              msg: "An SMS message has been sent to your number.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white70,
              textColor: Colors.black,
              fontSize: 16.0);

          Get.to(ResetPassword(phoneNum.value.replaceAll("+", "")));
        } else{
          Fluttertoast.showToast(
              msg: "${jsonResponse["description"]}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white70,
              textColor: Colors.black,
              fontSize: 16.0);
        }
      } else{
        Fluttertoast.showToast(
            msg: "Error ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white70,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    }

  }

}