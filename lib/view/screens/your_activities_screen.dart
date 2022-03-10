
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:routes/view/screens/wallet/your_transactions.dart';
import 'package:routes/view/screens/your_trips.dart';


class YourActivitiesScreen extends StatefulWidget {
  const YourActivitiesScreen({Key? key}) : super(key: key);

  @override
  _YourActivitiesScreenState createState() => _YourActivitiesScreenState();
}

class _YourActivitiesScreenState extends State<YourActivitiesScreen> {
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
        title: Text('Your Activities',style: TextStyle(color: Colors.blue[900]),),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0,),

              Text('History',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
              SizedBox(height: 30.0,),

              InkWell(
                onTap: (){
                  Get.to(()=>YourTrips());
                },
                child: Row(
                  children: [
                    Icon(Icons.map_outlined),
                    SizedBox(width: 4.0,),

                    Text('Trips'),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_outlined),

                  ],
                ),
              ),
              SizedBox(height: 16,),
              InkWell(
                onTap: (){
                  Get.to(()=>YourTransactionsScreen());
                },
                child: Row(
                  children: [
                    Icon(Icons.payments_outlined),
                    SizedBox(width: 4.0,),
                    Text('Transactions'),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_outlined),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
