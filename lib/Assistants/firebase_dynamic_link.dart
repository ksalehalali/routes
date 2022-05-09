import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../Data/current_data.dart';
import '../controller/start_up_controller.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class FirebaseDynamicLinkService{

  static Future<String> createDynamicLink(bool  short,String id ) async{
    String _linkMessage;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://routesbusapp.page.link',
      link: Uri.parse('https://routesbusapp.page.link/all?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.routes.khaled.n.routes',
        minimumVersion: 1,
        //fallbackUrl: //for custom url
      //  fallbackUrl: Uri.parse('https://www.google.com')
      ),
      iosParameters: IosParameters(
        fallbackUrl: Uri.parse('https://apps.apple.com/us/app/%D8%A3%D8%AD%D9%83%D8%A7%D9%85/id1583579830'),
        customScheme: 'https://routesbusapp.page.link',
        bundleId: 'com.routes.khaled.n.routes',
        minimumVersion: '1.0.0',
      )
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
      Share.share(url.toString());
    } else {
      url = await parameters.buildUrl();
      Share.share(url.toString());

    }

    _linkMessage = url.toString();
    return _linkMessage;
  }

  static Future<void> initDynamicLink(BuildContext context)async {
    final StartUpController startUpController = Get.find();

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async{
        final Uri deepLink = dynamicLink.link;

        var isStory = deepLink.pathSegments.contains('storyData');
        // TODO :Modify Accordingly
        if(isStory){
          String? id = deepLink.queryParameters['id'];
          // TODO :Modify Accordingly
          print(id);
          if(deepLink!=null){
            print("deeplink:: $deepLink");
            // TODO : Navigate to your pages accordingly here

            startUpController.promoterId.value = id!;
            promoterId = id;
            startUpController.saveInstallationForPromoters(id);

          }else{
            return null;
          }
        }else{
          //try
          if(deepLink!=null){
            print("deeplink try:: $deepLink");
            // TODO : Navigate to your pages accordingly here
            String? id = deepLink.queryParameters['id'];
            promoterId = id!;

            startUpController.promoterId.value = id;


          }else{
            return null;
          }
        }


      }, onError: (OnLinkErrorException e) async{
        print('link error');
      }
    );


    //on termination
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    try{
      final Uri deepLink = data.link;
      var isStory = deepLink.pathSegments.contains('storyData');
      if(isStory){ // TODO :Modify Accordingly
        String? id = deepLink.queryParameters['id'];
        promoterId = id!;

        startUpController.promoterId.value = id;
        // TODO : Navigate to your pages accordingly here

        // try{
        //   await firebaseFirestore.collection('Stories').doc(id).get()
        //       .then((snapshot) {
        //     StoryData storyData = StoryData.fromSnapshot(snapshot);
        //
        //     return Navigator.push(context, MaterialPageRoute(builder: (context) =>
        //         StoryPage(story: storyData,)
        //     ));
        //   });
        // }catch(e){
        //   print(e);
        // }
      }
    }catch(e){
      print('No deepLink found');
    }
  }
}