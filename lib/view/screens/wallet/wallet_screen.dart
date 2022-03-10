import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    walletController.getMyWallet();
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
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [

                      SizedBox(
                        height: 500,
                        child: FutureBuilder(
                          future: walletController.getMyListOfRecharges(),
                          builder: (context, data) =>data.connectionState == ConnectionState.waiting ?SizedBox(
                            width: 110,
                            height: 110,
                            child: FittedBox(
                              child: CircularProgressIndicator.adaptive(strokeWidth: 0.9,),
                            ),
                          ): Obx(() =>
                              CustomScrollView(
                                slivers: [
                                 SliverToBoxAdapter(
                                   child: Text('Recharges'),
                                 ),
                                  SliverList(delegate: SliverChildBuilderDelegate((context,index){
                                    return ListTile(
                                      leading: Icon(Icons.payments_outlined),
                                      title: Text(walletController.recharges[index].paymentGateway.toString()),
                                      subtitle:  Text(walletController.recharges[index].createdDate.toString()),
                                      trailing:  Text(walletController.recharges[index].invoiceValue.toString()),
                                    );
                                  },childCount:walletController.recharges.length ),)
                                ],
                              )
                            // ListView.builder(
                            //   physics: BouncingScrollPhysics(),
                            //   scrollDirection: Axis.vertical,
                            //   itemCount: walletController.recharges.length,
                            //   itemBuilder: (context, index) => Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.end,
                            //       children: [
                            //         Container(
                            //           height: 2,
                            //           width: screenSize.width,
                            //           decoration: BoxDecoration(
                            //             color: Colors.grey[400],
                            //           ),
                            //         ),
                            //         Container(
                            //           child: Row(
                            //             children: [
                            //               Container(
                            //                   height: 50,
                            //                   width: 50,
                            //                   decoration: BoxDecoration(
                            //                       color: Colors.grey[200],
                            //                       borderRadius:
                            //                           BorderRadius.circular(
                            //                               100)),
                            //                   child: Icon(
                            //                     Icons.payments,
                            //                     size: 22,
                            //                     color: Colors.grey[800],
                            //                   )),
                            //               SizedBox(
                            //                 width: 12.0,
                            //               ),
                            //               Column(
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.start,
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.spaceBetween,
                            //                 children: [
                            //                   Text(
                            //                     'Date',
                            //                     style: TextStyle(
                            //                         fontWeight: FontWeight.bold,
                            //                         fontSize: 16,
                            //                         color: Colors.grey[400]),
                            //                   ),
                            //                   SizedBox(
                            //                     width: 170,
                            //                     child: Text(
                            //                       walletController
                            //                           .recharges[index]
                            //                           .createdDate!,
                            //                       overflow:
                            //                           TextOverflow.ellipsis,
                            //                       maxLines: 1,
                            //                       style: TextStyle(
                            //                           fontWeight:
                            //                               FontWeight.bold,
                            //                           fontSize: 18,
                            //                           color: Colors.grey[900]),
                            //                     ),
                            //                   )
                            //                 ],
                            //               ),
                            //               Spacer(),
                            //               Text(
                            //                 '${walletController.recharges[index].invoiceValue} K.D',
                            //                 style: TextStyle(
                            //                     fontSize: 16,
                            //                     fontWeight: FontWeight.bold,
                            //                     color: Colors.black),
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          )
                        ),
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
