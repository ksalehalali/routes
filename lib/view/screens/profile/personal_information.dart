
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:routes/view/screens/profile/personal_information_edit.dart';
import '../../../Assistants/globals.dart';
import '../../../Data/current_data.dart';
import '../../../controller/payment_controller.dart';
import '../../../controller/personal_information_controller.dart';


class PersonalInformation extends StatefulWidget {
  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final PaymentController paymentController = Get.find();

  final personalInfoController = Get.put(PersonalInformationController());
  var payCode ='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  getPaymentCode()async{
    payCode =await paymentController.getPaymentCode();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: routes_color,

        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit Profile',
            onPressed: () {
              Get.to(PersonalInformationEdit());
            },
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // EDIT PROFILE PICTURE
                Obx(() =>  Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0.h),
                  alignment: Alignment.center,
                  // If no profile picture is fetched, a placeholder Image will be displayed
                  child: personalInfoController.profilePicture.value.path == "" ?
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://www.pngkey.com/png/full/349-3499617_person-placeholder-person-placeholder.png',
                    ),
                  ):
                  // display user profile picture.
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        personalInfoController.profilePictureUrl.value//'https://www.pngkey.com/png/full/349-3499617_person-placeholder-person-placeholder.png',
                    ),
                  ),
                ),
                ),
                SizedBox(height: 46.0.h,),
                // EDIT NAME
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 14.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "name_txt".tr,
                        style: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                      SizedBox(height: 4.0.h,),
                      Obx(() => TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: personalInfoController.nameHint.value
                        ),
                      ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.0.h,),
//            // EDIT PHONE
//            Container(
//              margin: EdgeInsets.symmetric(horizontal: 8.0),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Text(
//                    "Username/Phone",
//                    style: TextStyle(
//                        color: Colors.grey
//                    ),
//                  ),
//                  SizedBox(height: 4.0,),
//                  TextField(
//                    decoration: InputDecoration(
//                        hintText: "+99921312 "
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            SizedBox(height: 32.0,),
                // EDIT EMAIL
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 14.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "email_txt".tr,
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                      SizedBox(height: 4.0.h,),
                      Obx(() => TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: personalInfoController.emailHint.value,
                        ),
                      ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.0.h,),

                QrImage(
                  data: "{\"userId\":\"${user.id!}\",\"userName\":\"${user.name}\",\"paymentCode\":\"${user.PaymentCode}\"}",
                  version: QrVersions.auto,
                  size: 300.0.sp,
                ),

                SizedBox(height: 12.h,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
