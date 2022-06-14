import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:routes/Assistants/globals.dart';
import 'package:routes/model/transaction_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Data/current_data.dart';
import '../../../controller/payment_controller.dart';
import '../../widgets/dialogs.dart';
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
  Color? _color = routes_color;
  Color? _color2 = Colors.grey[700];
  bool showPayments =true;
  bool showRecharges = false;

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
                height: screenSize.height * .1 - 70.h,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'available_balance_txt'.tr,
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5.0.h,
                      ),
                      Obx(
                        () => walletController.gotMyBalance.value == true
                            ? Text(
                                walletController.myBalance.value,
                                style: TextStyle(
                                    fontSize: 17.sp, fontWeight: FontWeight.bold),
                              )
                            : SizedBox(
                                height: 18.h,
                                width: 18.w,
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.black,
                                  strokeWidth: 3.w,
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
                          size: 28.sp,
                        ),
                        SizedBox(
                          height: 5.0.h,
                        ),
                        Text(
                          'add_redit_btn'.tr,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenSize.height * 0.1 - 42.h,
              ),

              Container(
                child: ElevatedButton(
                  onPressed: () async{
                    await walletController.getPaymentCode();
                    Get.dialog(Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: Container(
                      height:360.h,
                        color: Colors.white,
                        child: Center(
                          child: QrImage(
                            data: "{\"userId\":\"${user.id!}\",\"userName\":\"${user.name}\",\"paymentCode\":\"${user.PaymentCode}\"}",
                            version: QrVersions.auto,
                            size: 250.0.sp,
                          ),
                        ),
                      )
                    ));
                    print("{\"userId\":\"${user.id!}\",\"userName\":\"${user.name}\",\"paymentCode\":\"${user.PaymentCode}\"}");
                  },
                  child: Text(
                    "pay_btn".tr,
                    style: TextStyle(
                        fontSize: 17.sp,
                        letterSpacing: 1
                    ),
                  ),
                  style: ElevatedButton.styleFrom(

                      maximumSize: Size(Get.size.width -90.w,Get.size.width -90.w),
                      minimumSize: Size(Get.size.width -90.w, 40.w),primary: routes_color2,
                      onPrimary: Colors.white,
                      alignment: Alignment.center
                  ),
                ),

              ),
              SizedBox(
                height: 12.0.h,
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
                      SizedBox(height: 10.0.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                _color = routes_color;
                                _color2 = Colors.grey[700];
                                showPayments =true;
                                showRecharges =false;

                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(duration: 11.seconds,
                                    curve: Curves.easeIn,
                                    child: Text('payments_txt'.tr,style: TextStyle(color: _color,fontWeight: FontWeight.w600))),
                                SizedBox(height: 10.0.h,),
                                AnimatedContainer(
                                  curve: Curves.easeInOut,
                                  width:screenSize.width/2-15.w,
                                  height: 2.5.h,
                                  color: _color,
                                  duration: 900.milliseconds ,

                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                _color2 = routes_color;
                                _color = Colors.grey[700];
                                showPayments =false;
                                showRecharges =true;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                    curve: Curves.easeIn,
                                    duration: 14.seconds,

                                    child: Text('recharges_txt'.tr,style: TextStyle(color: _color2,fontWeight: FontWeight.w600),)),
                                SizedBox(height: 10.0.h,),
                                AnimatedContainer(
                                  curve: Curves.easeInOut,
                                  width: screenSize.width/2-15.w,
                                  height: 2.5.h,
                                  color: _color2,
                                  duration: 900.milliseconds ,

                                )
                              ],
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: screenSize.height * 0.1 - 62.h,
                      ),
                       Obx(()=> (walletController.gotPayments.value ==false&&walletController.gotRecharges.value==false)?Center(child: Image.asset('assets/animation/Logo animated-loop-fast.gif',fit: BoxFit.fill,color: routes_color,),):Container()),
                      showPayments?SizedBox(
                        height: screenSize.height-200.h,
                        child: Padding(
                          padding:  EdgeInsets.only(bottom: 122.0.h),
                          child: CustomScrollView(
                            slivers: [
                              Obx(()=> SliverList(delegate: SliverChildBuilderDelegate((context,index){
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text('route ${walletController.payments[index].routeName.toString()}',style: TextStyle(color: Colors.black),),
                                        subtitle:  Text(DateFormat('yyyy-MM-dd  HH:mm :ss').format(DateTime.parse(walletController.payments[index].date!)),style: TextStyle(height: 2),),
                                        trailing:  Text(walletController.payments[index].value!.toStringAsFixed(3),style: TextStyle(color:Colors.red,fontWeight: FontWeight.w600),),
                                        onTap: (){
                                          showDialog(context: context, builder: (context)=>CustomDialog(payment:  walletController.payments[index],fromPaymentLists: false,failedPay: false,));
                                        },
                                      ),
                                      Divider(thickness: 1,height: 10.h,),
                                    ],
                                  );
                                },childCount:walletController.payments.length ),),
                              )
                            ],
                          ),
                        )

                      ):Container(),

                      showRecharges?SizedBox(
                          height: screenSize.height-200.h,
                          child: Padding(
                            padding:  EdgeInsets.only(bottom: 122.0.h),
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
                                        title: Text(walletController.recharges[index].paymentGateway.toString(),style: TextStyle(color: Colors.black),),
                                        subtitle:  Text(DateFormat('yyyy-MM-dd  HH:mm :ss').format(DateTime.parse(walletController.recharges[index].createdDate!)),style: TextStyle(height: 2),),
                                        trailing:  Text(walletController.recharges[index].invoiceValue!.toStringAsFixed(3),style: TextStyle(color:routes_color,fontWeight: FontWeight.w600),),
                                      ),
                                      Divider(thickness: 1,height: 10.h,)
                                    ],
                                  );
                                },childCount:walletController.recharges.length ),),
                                )
                              ],
                            ),
                          )

                      ):Container(),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Container(
                        width: screenSize.width - 20.w,
                        height: 2,
                        color: Colors.grey[300],
                      ),

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
