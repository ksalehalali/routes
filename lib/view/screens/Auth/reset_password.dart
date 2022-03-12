
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../Assistants/globals.dart';
import '../../../controller/confirm_number_controller.dart';
import '../../../controller/reset_password_controller.dart';

class ResetPassword extends StatefulWidget {
  final String phoneNum;
  ResetPassword(this.phoneNum);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final resetPasswordController = Get.put(ResetPasswordController());
  final confirmNumberController = Get.put(ConfirmNumberController());




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // MESSAGE
                  SizedBox(height: 16,),
                  Container(
                    child: Text(
                      "The confirmation code has been sent to ${widget.phoneNum} via SMS",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16,),
                  // TIMER
                  CountdownTimer(
                    endTime: resetPasswordController.endTime,
                    onEnd: resetPasswordController.onEnd,
                    textStyle: TextStyle(
                      fontSize: 25,
                      color: routes_color,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 16,),
                  // CODE TEXT FIELD
                  Container(
                    width: 200,
                    child: TextField(
                      cursorColor: routes_color,
                      controller: resetPasswordController.codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 8.0
                      ),
                      decoration: InputDecoration(
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
                          hintText: "Code",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: () {
                      // TODO: recall that function
                      confirmNumberController.makeCodeConfirmationRequest();
                    },
                    child: Container(
                      child: Text(
                        "Resend Code",
                        style: TextStyle(
                          color: routes_color
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 64,),
                  // PASSWORD
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Password",
                          ),
                        ),
                        SizedBox(height: 8,),
                        TextField(
                          cursorColor: routes_color,
                          controller: resetPasswordController.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
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
                              hintText: "Code",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  // CONFIRM PASSWORD
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Password Confirm",
                          ),
                        ),
                        SizedBox(height: 8,),
                        TextField(
                          cursorColor: routes_color,
                          controller: resetPasswordController.passwordConfirmController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
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
                              hintText: "Code",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: routes_color,
        onPressed: () async{
          await resetPasswordController.resetPassword(widget.phoneNum.replaceAll("+", ""));
        },
        child: Icon(Icons.forward),
      ),
    );
  }
}
