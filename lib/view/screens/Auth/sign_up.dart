import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../Assistants/globals.dart';
import '../../../controller/sign_up_controller.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final signUpController = Get.put(SignUpController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//  final TextEditingController controller = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'KW');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("${assetsDir}background/sign_up_bg.png"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            // TITLE
//            Container(
//              padding: EdgeInsets.only(left: 35, top: 30),
//              child: Text(
//                'Create\nAccount',
//                style: TextStyle(color: Colors.white, fontSize: 33),
//              ),
//            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
//                          // PHONE TEXT FIELD
//                          Row(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: [
//                              // FIXED INIT NUMBER
//                              Container(
//                                padding: EdgeInsets.symmetric(horizontal: 8.0),
//                                height: 60,
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(10),
//                                  border: Border.all(color: Colors.white)
//                                ),
//                                child: Center(
//                                  child: Text(
//                                    "965",
//                                    style: TextStyle(
//                                      color: Colors.white
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              SizedBox(width: 16.0,),
//                              Expanded(
//                                child: Container(
//                                  child: TextField(
//                                    controller: signUpController.phoneNumController,
//                                    keyboardType: TextInputType.number,
//                                    maxLength: 8,
//                                    style: TextStyle(color: Colors.white),
//                                    decoration: InputDecoration(
//                                        enabledBorder: OutlineInputBorder(
//                                          borderRadius: BorderRadius.circular(10),
//                                          borderSide: BorderSide(
//                                            color: Colors.white,
//                                          ),
//                                        ),
//                                        focusedBorder: OutlineInputBorder(
//                                          borderRadius: BorderRadius.circular(10),
//                                          borderSide: BorderSide(
//                                            color: Colors.black,
//                                          ),
//                                        ),
//                                        hintText: "Phone Number",
//                                        hintStyle: TextStyle(color: Colors.white),
//                                        border: OutlineInputBorder(
//                                          borderRadius: BorderRadius.circular(10),
//                                        )),
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                          SizedBox(
//                            height: 30,
//                          ),
                          // PHONE TEXT FIELD
                          InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                              signUpController.phoneNum.value = number.phoneNumber!;

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
                            selectorTextStyle: TextStyle(color: Colors.white),
                            textStyle: TextStyle(color: Colors.white),
                            inputDecoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white,
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
//                            textFieldController: controller,
                            formatInput: false,
                            keyboardType:
                            TextInputType.numberWithOptions(signed: true, decimal: true),
                            inputBorder: OutlineInputBorder(),
                            onSaved: (PhoneNumber number) {
                              print('On Saved: $number');
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          // PASSWORD TEXT FIELD
                          TextField(
                            controller: signUpController.passwordController,
                            style: TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SIGN UP TEXT
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              // SIGN UP BUTTON
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child:  Obx(() => IconButton(
                                  color: Colors.white,
                                  onPressed: () async{
                                    signUpController.isSignUpLoading.value = true;
                                    await signUpController.makeSignUpRequest(context);
                                    signUpController.isSignUpLoading.value = false;
                                  },
                                  icon: !signUpController.isSignUpLoading.value ?
                                  Icon(Icons.arrow_forward,
                                  ):
                                  Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          // NAV LOGIN BUTTON
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.to(Login());
                                },
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}