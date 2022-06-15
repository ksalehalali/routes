//
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_form.dart';
// import 'package:flutter_credit_card/credit_card_model.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
//
//
// class CreditCardScreen extends StatefulWidget {
//   final bool? isPay;
//
//   const CreditCardScreen({Key? key,this.isPay}) : super(key: key);
//
//   @override
//   _CreditCardScreenState createState() => _CreditCardScreenState();
// }
//
// class _CreditCardScreenState extends State<CreditCardScreen> {
//   String cardNumber = '';
//   String expiryDate= '';
//   String cardHolderName = '';
//   String cvvCode= '';
//   bool isCvvFocused = false;
//   final box = GetStorage();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.teal[50],
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//         automaticallyImplyLeading: false,
//         title: Text(widget.isPay!?"Recharge":'Add Yor Card',style: TextStyle(color: Colors.blue[900]),),
//         leading: InkWell(
//           onTap: (){
//             Get.back();
//           },
//           child: Icon(Icons.clear,color: Colors.blue[900],),
//         ),
//       ),
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: Column(
//           children: [
//            widget.isPay == true ? RichText(
//               text:TextSpan(
//                children: [
//                  TextSpan(
//                    text: 'Amount : ',
//                    style: TextStyle(
//                      fontSize: 18,
//
//                    )
//                  ),
//                  TextSpan(
//                      text: '',
//                    style: TextStyle(
//                      fontSize: 18,
//                      fontWeight: FontWeight.bold
//                    )
//                  )
//                ],
//               style: TextStyle(color: Colors.blue[900])
//             ) ,):Container(),
//             CreditCardWidget(
//               height: Get.size.height *0.2 +30,
//               cardNumber: cardNumber,
//               expiryDate: expiryDate,
//               cardHolderName: cardHolderName,
//               cvvCode: cvvCode,
//               showBackView: isCvvFocused,
//               obscureCardNumber: true,
//               obscureCardCvv: true,),
//             Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       CreditCardForm(
//                         cardNumber: cardNumber,
//                         expiryDate: expiryDate,
//                         cardHolderName: cardHolderName,
//                         cvvCode: cvvCode,
//
//                         onCreditCardModelChange: onCreditCardModelChange,
//                         themeColor: Colors.blue,
//                         formKey: formKey,
//                         cardNumberDecoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: 'Number',
//                             hintText: 'xxxx xxxx xxxx xxxx'
//                         ),
//                         expiryDateDecoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: 'Expired Date',
//                             hintText: 'xx/xx'
//                         ),
//                         cvvCodeDecoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: 'CVV',
//                             hintText: 'xxx'
//                         ),
//                         cardHolderDecoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Card Holder',
//                         ),
//                       ),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             primary: Color(0xff1b447b)
//
//                         ),
//                         child: Container(
//                           margin: EdgeInsets.all(8.0),
//                           child: const Text(
//                             'validate',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontFamily: 'halter',
//                               fontSize: 14,
//                               package: 'flutter_credit_card',
//                             ),
//                           ),
//                         ),
//                         onPressed: (){
//                           if(formKey.currentState!.validate()){
//                             box.write('cardNumber', cardNumber);
//                             box.write('expiryDate', expiryDate);
//                             box.write('cardHolderName', cardHolderName);
//                             box.write('cvvCode', cvvCode);
//                             box.write('isCvvFocused', isCvvFocused);
//
//                             print('valid');
//                             FocusScope.of(context).unfocus();
//
//                           }
//                           else{
//                             print('inValid');
//                           }
//                         },)
//                     ],
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void onCreditCardModelChange(CreditCardModel creditCardModel){
//     setState(() {
//       cardNumber = creditCardModel.cardNumber;
//       expiryDate = creditCardModel.expiryDate;
//       cardHolderName = creditCardModel.cardHolderName;
//       cvvCode = creditCardModel.cvvCode;
//       isCvvFocused = creditCardModel.isCvvFocused;
//     });
//   }
// }