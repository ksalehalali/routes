

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:routes/Assistants/globals.dart';
import 'package:routes/view/screens/profile/help_screen.dart';
import 'package:routes/view/screens/profile/personal_information.dart';
import 'package:routes/view/widgets/headerDesgin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Assistants/firebase_dynamic_link.dart';
import '../../../Data/current_data.dart';
import '../../../controller/lang_controller.dart';
import '../../../controller/personal_information_controller.dart';
import '../../../controller/start_up_controller.dart';
import '../Auth/login.dart';
import '../Home.dart';
import 'about_us.dart';
import 'your_activities_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final personalInfoController = Get.put(PersonalInformationController());
  final StartUpController startUpController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenSize = Get.size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [

          routes_color6,
          routes_color,
        ]
        )
      ),
      child: SafeArea(
        child: Scaffold(

            body: Stack(
              children: [
                Positioned(
                    top: 0.0,
                    child: SizedBox(
                        height: screenSize.height*0.1+11,
                        width: screenSize.width,
                        child: Header(screenSize))),
                Positioned(
                  top: 84 ,
                  child: SizedBox(
                    height: screenSize.height,
                    width: screenSize.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //
                            // Padding(
                            //     padding:
                            //     EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
                            //     child: personalInfoController.profilePicture.value.path == "" ?
                            //     CircleAvatar(
                            //       radius: 40,
                            //       backgroundImage: NetworkImage(
                            //         'https://www.pngkey.com/png/full/349-3499617_person-placeholder-person-placeholder.png',
                            //       ),
                            //     ):
                            //     // display user profile picture.
                            //     CircleAvatar(
                            //       radius: 40,
                            //       backgroundImage: NetworkImage(
                            //           personalInfoController.profilePictureUrl.value//'https://www.pngkey.com/png/full/349-3499617_person-placeholder-person-placeholder.png',
                            //       ),
                            //     ),
                            // ),
                            SizedBox(
                              height: screenSize.height * 0.1 - 50,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    print(promoterId);
                                    Get.snackbar('Promoter Id', promoterId);
                      },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'your_account'.tr,
                                      style:TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.grey[800]),

                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(()=> PersonalInformation());
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person_pin,
                                          size: 32,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                          'personal_info'.tr,
                                          style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.grey[600]),

                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 22,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),

                                InkWell(
                                  onTap: (){
                                    Get.to(()=>YourActivitiesScreen());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                          size: 32,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                          'your_activities'.tr,
                                          style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.grey[600]),

                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 22,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                        SizedBox(
                        height: screenSize.height * 0.1 - 56,
                        ),
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'get_support_btn'.tr,
                              style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.grey[800]),

                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
                            child: InkWell(
                              onTap: () {
                                Get.to(()=> const HelpScreen());
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.help_center_outlined,
                                    size: 32,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    'help_btn'.tr,
                                    style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.grey[600]),

                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 22,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // SizedBox(
                          //   height: 12,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: InkWell(
                          //     onTap: () {
                          //       Get.to(()=> const AboutUs());
                          //     },
                          //     child: Row(
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Icon(
                          //           Icons.help_center_outlined,
                          //           size: 32,
                          //           color: Colors.grey,
                          //         ),
                          //         SizedBox(
                          //           width: 8.0,
                          //         ),
                          //         Text(
                          //           'About Us',
                          //           style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.grey[600]),
                          //
                          //         ),
                          //         Spacer(),
                          //         Icon(
                          //           Icons.arrow_forward_ios_outlined,
                          //           size: 22,
                          //           color: Colors.grey,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
                            child: InkWell(
                              onTap: () {
                                FirebaseDynamicLinkService.createDynamicLink(false, user.id!);

                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.share_outlined,
                                    size: 32,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    'share_app_btn'.tr,
                                    style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.grey[600]),

                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 22,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),



                          SizedBox(
                              height: screenSize.height * 0.1 - 58,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'setting_title'.tr,
                                    style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.grey[800]),

                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.language,
                                        size: 32,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        'btn_Lang'.tr,
                                        style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.grey[600]),

                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: 100,
                                        child: ListTile(

                                          leading: GetBuilder<LangController>(
                                            init: LangController(),
                                            builder: (controller)=> DropdownButton(
                                              iconSize: 38,
                                              style: TextStyle(fontSize: 18,color: Colors.blue[900],),
                                              items: [
                                                DropdownMenuItem(child: Text('EN'),value: 'en',),
                                                DropdownMenuItem(child: Text('AR'),value: 'ar',),
                                               // DropdownMenuItem(child: Text('HI'),value: 'hi',)

                                              ],
                                              value:controller.appLocal ,
                                              onChanged: (val)async{
                                                print(val.toString());
                                                controller.changeLang(val.toString());
                                                Get.updateLocale(Locale(val.toString()));
                                                controller.changeDIR(val.toString());
                                                print(Get.deviceLocale);
                                                print(Get.locale);
                                                SharedPreferences prefs = await SharedPreferences.getInstance();

                                                await prefs.setString('lang', val.toString());
                                              },
                                            ),
                                          ),
                                          onTap: () {
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  height: 2,
                                  width: screenSize.width - 20,
                                  color: Colors.grey[200],
                                ),
                                SizedBox(
                                  height: 22.0,
                                ),
                                Center(
                                    child: ElevatedButton.icon(
                                      icon: Icon(
                                        Icons.logout,
                                        size: 32,
                                        color: Colors.red,
                                      ),
                                      onPressed: ()async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        print(prefs.getString('token'));
                                        prefs.remove('token');
                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);
                                      },
                                      label: Text('btn_logOut'.tr,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                                      style: ElevatedButton.styleFrom(
                                          maximumSize: Size(Get.size.width -220,Get.size.width -220),
                                          minimumSize: Size(Get.size.width -220, 40),primary: Colors.white,
                                          onPrimary: routes_color,
                                          alignment: Alignment.center
                                      ),)
                                ),
                                SizedBox(height: 22,),

                                Center(
                                  child: InkWell(
                                    onTap: ()async{
                                      // final genDynUrl=await FirebaseDynamicLinkService.createDynamicLink(false,'a1');
                                      // print(genDynUrl);
                                    },
                                    child:Text('terms_conditions_btn'.tr,style: TextStyle(fontSize: 15,color: Colors.green[700]),),
                                  ),
                                ),

                                const Divider(),


                              ],
                            )
                          ],
                        ),
                            SizedBox(height:220)
                        ]),
                      )),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}