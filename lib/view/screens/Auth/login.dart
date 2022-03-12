import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:routes/view/screens/Auth/sign_up.dart';

import '../../../Assistants/globals.dart';
import '../../../controller/login_controller.dart';
import '../../../controller/profile_pic_controller.dart';
import 'confirm_number.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginController = Get.put(LoginController());
  final profilePicController = Get.put(ProfilePicController());

  bool chooseCamera = false;
  PhoneNumber number = PhoneNumber(isoCode: 'KW');

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //       image: AssetImage("${assetsDir}background/login_bg.png"), fit: BoxFit.cover),
      // ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // BODY
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.45
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          // USERNAME TEXT FIELD
                          Container(
                            padding: EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(                               
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1.0,
                              ),
                            ),
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                print(number.phoneNumber);
                                loginController.phoneNum.value = number.phoneNumber!;
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
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
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
                          ),
                          SizedBox(
                            height: 30,
                          ),
                            // PASSWORD TEXT FIELD
                          TextField(
                            controller: loginController.passwordController,
                            style: TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Password",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: routes_color, width: 1.0),
                                borderRadius: BorderRadius.circular(10),
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // LOGIN PROCEED
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
//                              SizedBox(width: 28,),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: routes_color,
                                child: Obx(() => IconButton(
                                    color: Colors.white,
                                    onPressed: () async{
                                      // TODO: login API
                                      loginController.isLoginLoading.value = true;
                                      await loginController.makeLoginRequest();
                                      loginController.isLoginLoading.value = false;
                                    },
                                    icon: !loginController.isLoginLoading.value ?
                                    Container(
                                        child: Icon(
                                          Icons.arrow_forward,
                                        )
                                    ):
                                    Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                    //icon: loginController.loginIcon.value
                                ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),

                          // SIGN UP / FORGOT PASSWORD SECTION
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    this.context,
                                    new MaterialPageRoute(builder: (context) => new SignUp()),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: routes_color,
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                              // FORGOT PASSWORD
                              TextButton(
                                  onPressed: () {
                                    Get.to(ConfirmNumber());
                                  },
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: routes_color,
                                      fontSize: 18,
                                    ),
                                  )),
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
