import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Data/current_data.dart';
import '../model/charge_toSave_model.dart';
import '../model/payment_saved_model.dart';
class PaymentController extends GetxController {
  var paymentDone = false.obs;
  var directPaymentDone = false.obs;
  var totalOfMyPayments = 0.obs;
  var myBalance = '0.0'.obs;
  var recharges = <ChargeSaved>[].obs;
  var payments = <PaymentSaved>[].obs;
  var gotMyBalance = false.obs;

  Future<bool> pay(bool isDirect) async {
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/PaymentMyWallet'));
    request.body = json.encode({
      "api_key": "\$FhlF]3;.OIic&{>H;_DeW}|:wQ,A8",
      "api_secret": "Z~P7-_/i!=}?BIwAd*S67LBzUo4O^G",
      "Value":   paymentSaved.value,
      "TripID": tripToSave.id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if(isDirect==true){
        directPaymentDone.value = true;
      }{
        paymentDone.value = true;
      }
      var json = jsonDecode(await response.stream.bytesToString());
      user.totalBalance = double.parse(json['description']['total']);
       paymentSaved.id = json['description']['paymentId'];
      // paymentSaved.value = json['description']['value'];
      print('value payed :: ${json['description']}');
      ///to do
      // بعد اتمام الدفعة يجب تعديل الرحلة المحفوظة لتاخذ paymentId , busId
      return true;
    }
    else {
      return false;
      print(response.reasonPhrase);
    }
  }

  Future<bool> recharge({required double invoiceValue,required int invoiceId,required String paymentGateway}) async {
    var headers = {
      'Authorization':
          'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://route.click68.com/api/ChargeMyWallet'));
    request.body = json.encode({
      "api_key": "\$FhlF]3;.OIic&{>H;_DeW}|:wQ,A8",
      "api_secret": "Z~P7-_/i!=}?BIwAd*S67LBzUo4O^G",
      "invoiceValue": invoiceValue,
      "invoiceId": invoiceId,
      "paymentGateway": paymentGateway
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    return true;
  }

  //get my wallet
  Future getMyWallet() async {
    var headers = {
      'Authorization':
          'bearer ${user.accessToken}'
    };
    var url =  Uri.parse('https://route.click68.com/api/GetWallet');
    var res = await  http.get(url,headers: headers);
    print(res.body);
    var jsonResponse = jsonDecode(res.body);
    if (res.statusCode == 200) {
      gotMyBalance.value = true;
      myBalance.value = jsonResponse['description']['total'];
      print(res.body);
    } else {
      print(res.reasonPhrase);
    }

    return res.body;
  }

  //get list of recharges
  Future getMyListOfRecharges() async {
    recharges.clear() ;
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/ListChrgingWalletByUser'));
    request.body = json.encode({
      "PageNumber": 0,
      "PageSize": 10
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      var data = json['description'];
      print(data);
        for(int i =0; i < data.length; i++){
          recharges.add(
              ChargeSaved(
               id: data[i]['id'],
                userName: data[i]['userName'],
                invoiceValue: double.parse(data[i]['value']),
                createdDate: data[i]['date'],
                paymentGateway: data[i]['paymentGateway'],
                invoiceId: data[i]['invoiceId']
              )
          );
        }
        update();
    }
    else {
      print(response.reasonPhrase);
    }
  }

  //get list of payments
  Future getMyListOfPayments() async {
    payments.clear() ;
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/ListPaymentWalletByUser'));
    request.body = json.encode({
      "PageNumber": 1,
      "PageSize": 22
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      var data = json['description'];
      print(data);
      print('total :: ${json['total']}');
      totalOfMyPayments.value = json['total'];
      for(int i =0; i < data.length; i++){
        payments.add(
                PaymentSaved (
                  userName: data[i]['userName'],
                  createdDate: data[i]['date'],
                  value: double.parse(data[i]['value']),
                  id: data[i]['id'],
            )
        );
      }
      update();
    }
    else {
      print(response.reasonPhrase);
    }

  }
}
