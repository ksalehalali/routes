import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:routes/model/transaction_model.dart';

import '../Data/current_data.dart';
import '../model/charge_toSave_model.dart';
import '../model/payment_saved_model.dart';
import '../view/widgets/dialogs.dart';
class PaymentController extends GetxController {
  var paymentDone = false.obs;
  var directPaymentDone = false.obs;
  var paymentFailed = false.obs;
  var directPaymentFailed = false.obs;
  var totalOfMyPayments = 0.obs;
  var myBalance = '0.0'.obs;
  var recharges = <ChargeSaved>[].obs;
  var payments = <PaymentSaved>[].obs;
  var gotMyBalance = false.obs;
  var gotPayments = false.obs;
  var gotRecharges = false.obs;

  var allTrans = <TransactionModel>[].obs;
  int indexA = 0;
  int indexB = 0;
  var allTransSorted = <TransactionModel>[].obs;
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
      "TripID": tripToSave.id,
      "BusId": paymentSaved.busId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if(isDirect==true){
        directPaymentDone.value = true;
        directPaymentFailed.value =false;
      }{
        paymentFailed.value =false;
        paymentDone.value = true;
      }
      var json = jsonDecode(await response.stream.bytesToString());
      print(json);
      user.totalBalance = double.parse(json['description']['total']);
       paymentSaved.id = json['description']['paymentId'];
       paymentSaved.routeName = json['description']['routeName'];
       paymentSaved.userName = json['description']['userName'];
      print('value payed :: ${json}');
      //to do
      // بعد اتمام الدفعة يجب تعديل الرحلة المحفوظة لتاخذ paymentId , busId

      return true;
    }
    else {
      var json = jsonDecode(await response.stream.bytesToString());
      print(json);
      if(isDirect==true){
        directPaymentDone.value = false;
        directPaymentFailed.value =true;

      }{
        paymentDone.value = false;
        paymentFailed.value =true;

      }
update();
      return false;
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
    gotRecharges.value =false;

    recharges.clear() ;
    allTrans.clear();

    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/ListChrgingWalletByUser'));
    request.body = json.encode({
      "PageNumber": 0,
      "PageSize": 50
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      var data = json['description'];
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

          allTrans.add(TransactionModel(
            time: data[i]['date'],
            amount: double.parse(data[i]['value']),
              type: data[i]['paymentGateway'],
            isPay: false
          ));
        }
        gotRecharges.value =true;
        update();
    }
    else {
      print(response.reasonPhrase);
    }
    // if(gotPayments.value ==true && gotRecharges.value==true){
    //   sort();
    // }
  }

  //get list of payments
  Future getMyListOfPayments() async {
    gotPayments.value =false;

    payments.clear() ;
    allTrans.clear();
    var headers = {
      'Authorization': 'bearer ${user.accessToken}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://route.click68.com/api/ListPaymentWalletByUser'));
    request.body = json.encode({
      "PageNumber": 1,
      "PageSize": 50
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      var data = json['description'];
      totalOfMyPayments.value = json['total'];
print('payment ::${data[2]}');
      for(int i =0; i < data.length; i++){
        payments.add(
                PaymentSaved (
                  userName: data[i]['userName'],
                  createdDate: data[i]['date'],
                  value: double.parse(data[i]['value']),
                  id: data[i]['id'],
                  routeName: data[i]['routeName']??'',
                  date: data[i]['date'],
            )
        );
        allTrans.add(TransactionModel(
          time: data[i]['date'],
          amount: double.parse(data[i]['value']),
          type: 'pay',
          isPay: true

        ));
      }
      gotPayments.value =true;
      update();

    }
    else {
      print(response.reasonPhrase);
    }
    // if(gotPayments.value ==true && gotRecharges.value==true){
    //   sort();
    // }
  }
  sort(){
    // var a = walletController.allTrans.where((p0) => p0.amount! ==0.105).toList();
    TransactionModel c =TransactionModel();
    c = allTrans[0];
    // print(DateTime.parse(walletController.allTrans[0].time!).hour);
   for(int i =0; i<allTrans.length;i++){
     for(int index =i; index< allTrans.length; index++){

         if(DateTime.parse(allTrans[i].time!).isBefore(DateTime.parse(c.time!))){
          c = allTrans[i];

         };


     }
     allTransSorted.add(c);

   }
    print(allTransSorted.length);
    for(int i =0; i<allTransSorted.length;i++){
    print("$i :: ${allTransSorted[i].time}");
  }

  }
}
