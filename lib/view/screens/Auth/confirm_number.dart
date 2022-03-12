
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../Assistants/globals.dart';
import '../../../controller/confirm_number_controller.dart';


class ConfirmNumber extends StatefulWidget {
  @override
  _ConfirmNumberState createState() => _ConfirmNumberState();
}

class _ConfirmNumberState extends State<ConfirmNumber> {

  final confirmNumberController = Get.put(ConfirmNumberController());
  PhoneNumber number = PhoneNumber(isoCode: 'KW');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Container(
                child: Text(
                  "Reset your password",
                  style: TextStyle(
                    fontSize: 30
                  ),
                ),
              ),
              SizedBox(height: 32,),
              Container(
                child: Text(
                  "Type in your phone number and we will send you a code to reset your password",
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
              SizedBox(height: 64,),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                  confirmNumberController.phoneNum.value = number.phoneNumber!;
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                maxLength: 8,
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.black),
                textStyle: TextStyle(color: Colors.black),
                inputDecoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                initialValue: number,
//                textFieldController: controller,
                formatInput: false,
                keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
                inputBorder: OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  print('On Saved: $number');
                },
              ),
              SizedBox(height: 32,),
              Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: routes_color
                  ),
                  onPressed: () async{
                    confirmNumberController.makeCodeConfirmationRequest();
                  },
                  child: Text(
                    "Send Code",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
