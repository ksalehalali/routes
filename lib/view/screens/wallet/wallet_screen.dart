import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:routes/Assistants/globals.dart';
import 'package:routes/model/transaction_model.dart';

import '../../../controller/payment_controller.dart';
import 'balance_calculator.dart';


class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final PaymentController walletController = Get.find();
  int navIndex = 2;
  final box = GetStorage();
  bool? thereIsCard = false;
  var wallet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData()async{
     walletController.getMyWallet();
      walletController.getMyListOfRecharges();
      walletController.getMyListOfPayments();
  }

  @override
  Widget build(BuildContext context) {


    final screenSize = Get.size;
    return Scaffold(
      backgroundColor: Colors.blue[50]!.withOpacity(0.5),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height * .1 - 40,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Balance',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Obx(
                        () => walletController.gotMyBalance.value == true
                            ? Text(
                                walletController.myBalance.value,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            : SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.black,
                                  strokeWidth: 3,
                                )),
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BalanceCalculator()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_box_sharp,
                          color: Colors.green[900],
                          size: 28,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Add Credit',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenSize.height * 0.1 - 22,
              ),

              SizedBox(
                height: 12.0,
              ),
              //trans3131

              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text('Transactions',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                      ),
                      SizedBox(
                        height: screenSize.height-200,
                        child: CustomScrollView(
                          slivers: [
                            Obx(()=> SliverList(delegate: SliverChildBuilderDelegate((context,index){
                            // print( DateFormat('yyyy-MM-dd-HH:mm').format(walletController.allTrans[0].time as DateTime));
                              //final sortedCars = walletController.allTrans..sort((a, b) => a.time!.compareTo(b.time!));
                              //print(sortedCars);
                                return Column(
                                  children: [
                                    ListTile(
                                      //leading: Icon(Icons.payments_outlined),
                                      title: Text(walletController.allTrans[index].type.toString(),style: TextStyle(color: Colors.black),),
                                      subtitle:  Text(walletController.allTrans[index].time.toString(),style: TextStyle(height: 2),),
                                      trailing:  Text(walletController.allTrans[index].amount!.toStringAsFixed(3),style: TextStyle(color:walletController.allTrans[index].isPay==true? Colors.red:routes_color,fontWeight: FontWeight.w600),),
                                    ),
                                    Divider(thickness: 1,height: 10,)
                                  ],
                                );
                              },childCount:walletController.allTrans.length ),),
                            )
                          ],
                        )

                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: screenSize.width - 20,
                        height: 2,
                        color: Colors.grey[300],
                      )
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
