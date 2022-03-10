
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/payment_controller.dart';

class YourTransactionsScreen extends StatefulWidget {
  const YourTransactionsScreen({Key? key}) : super(key: key);

  @override
  _YourTransactionsScreenState createState() => _YourTransactionsScreenState();
}

class _YourTransactionsScreenState extends State<YourTransactionsScreen> {
  final PaymentController walletController = Get.find();
  final screenSize = Get.size;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: InkWell(
          onTap: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back,color: Colors.blue[900],size: 32,),
        ),
        title: Text('Your Transactions',style: TextStyle(color: Colors.blue[900]),),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('History',style: TextStyle(color: Colors.blue[900],fontSize: 16,fontWeight: FontWeight.bold),),
                    ),
               Spacer(),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Obx(()=>Text('${walletController.totalOfMyPayments.value}',style: TextStyle(color: Colors.blue[900],fontSize: 16,fontWeight: FontWeight.bold),)),
               ),
             ],
           ),
            SizedBox(
              height: screenSize.height -140,
              child: FutureBuilder(
                  future: walletController.getMyListOfPayments(),
                  builder: (context,data)=> Obx(()=> ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: walletController.payments.length,
                      itemBuilder: (context,index)=>Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 2,
                              width: screenSize.width ,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],

                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10.0,),
                                      SizedBox(
                                        width: 220.0,
                                        child: Text(  walletController.payments[index].createdDate!,overflow:TextOverflow.ellipsis,maxLines: 1
                                          ,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                      ),
                                      SizedBox(height: 5.0,),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${walletController.payments[index].userName}",style: TextStyle(color: Colors.black,),),
                                              SizedBox(height: 12.0,),
                                              Text("id : ${walletController.payments[index].id}",style: TextStyle(color: Colors.black,fontSize: 12),),

                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  //Text('Route : ${trips.trips[index]['rout']}'),
                                  RichText(text: TextSpan(
                                      children: [
                                        TextSpan(text: 'value : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black)),
                                        TextSpan(text: walletController.payments[index].value!.toStringAsFixed(3),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),

                                      ]
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
