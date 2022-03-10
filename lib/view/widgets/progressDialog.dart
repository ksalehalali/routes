
import 'package:flutter/material.dart';

import '../../Assistants/globals.dart';
import '../../Data/current_data.dart';

class ProgressDialog extends StatelessWidget {
  String? message;

   ProgressDialog({Key? key,this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.blue[100],
      child: Container(
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(width: 6.0,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              SizedBox(width: 26.0,),
              Text(message!,style: TextStyle(
                fontSize: 12.0,
                color: Colors.black
              ),)
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressDialogShowPayment extends StatelessWidget {
  String? message;

  ProgressDialogShowPayment({Key? key,this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: routes_color4,
      child: Container(
        height:370,
        margin: EdgeInsets.all(8.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text('Your Trip Payed',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 22.0,),
              const SizedBox(height: 8.0,),
              Text('Payment Id',style: TextStyle(fontSize: 13),),
              Text(paymentSaved.id!,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),maxLines: 1,),
              SizedBox(height: 12.0,),
              Text('Route',style: const TextStyle(fontSize: 14),),
              Text(trip.routeName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              SizedBox(height: 12.0,),
             Text('ticket price cut:',style: TextStyle(fontSize: 13),),
              Text(paymentSaved.value!.toStringAsFixed(3),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              const SizedBox(height: 8.0,),
              Text('your balance :',style: TextStyle(fontSize: 13),),
              Text(user.totalBalance!.toStringAsFixed(3),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
              ,
              SizedBox(height: 20.0,),
              Center(child: Icon(Icons.done,size: 66,color: Colors.green[800],))
            ],
          )
        ),
      ),
    );
  }
}

