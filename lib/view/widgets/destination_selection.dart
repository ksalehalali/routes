import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Assistants/globals.dart';
import '../../controller/location_controller.dart';
import '../screens/destination_selection_screen.dart';

class DestinationSelection extends StatelessWidget {
  const DestinationSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.find();
    final screenSize = Get.size;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), color: Colors.grey[200]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Start Your Trip'),
                SizedBox(
                  height: screenSize.height *.1 -40,
                ),
                InkWell(
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SearchScreen()), (route) => false);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: routes_color),
                            child: Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Container(
                            height: screenSize.height *.1 -20,
                            width: 2.0,
                            decoration: BoxDecoration(
                                color: routes_color,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: routes_color),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(()=> SizedBox(
                                  width:270,child: Text(locationController.pickUpAddress.value != ''?locationController.pickUpAddress.value:'Your current location',overflow: TextOverflow.ellipsis,))),

                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 16,
                              )
                            ],
                          ),
                          SizedBox(
                            height: Get.size.height *0.1 -55,
                          ),
                          Container(
                            width: Get.size.width -130,
                            height: 2,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          SizedBox(
                            height: Get.size.height *0.1 -55,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Where To ?'),
                              SizedBox(
                                width: Get.size.width -200,
                              ),
                              Icon(
                                Icons.search,
                                size: 16,
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height *.1 -50,),
                Center(child: ElevatedButton(onPressed: (){

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SearchScreen()), (route) => false);
                }, child: Text("Select the point of arrival.",style: TextStyle(fontSize: 16),), style: ElevatedButton.styleFrom(
                    maximumSize: Size(Get.size.width -90,Get.size.width -90),
                    minimumSize: Size(Get.size.width -90, 40),primary: routes_color,
                    onPrimary: Colors.white,
                    alignment: Alignment.center
                ),))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
