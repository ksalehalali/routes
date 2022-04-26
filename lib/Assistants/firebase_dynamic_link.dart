import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../controller/start_up_controller.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class FirebaseDynamicLinkService{

  static Future<String> createDynamicLink(bool  short,String id ) async{
    String _linkMessage;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://routesbusapp.page.link',
      link: Uri.parse('https://www.routesme.com/storyData?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.routes.khaled.n.routes',
        minimumVersion: 1,
        //fallbackUrl: //for custom url
      //  fallbackUrl: Uri.parse('https://www.google.com')
      ),
      iosParameters: IosParameters(
        fallbackUrl: Uri.parse('https://www.facebook.com'),
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
            startUpController.saveInstallationForPromoters(id);
            // try{
            //   await firebaseFirestore.collection('Stories').doc(id).get()
            //       .then((snapshot) {
            //         StoryData storyData = StoryData.fromSnapshot(snapshot);
            //
            //         return Navigator.push(context, MaterialPageRoute(builder: (context) =>
            //           StoryPage(story: storyData,)
            //         ));
            //   });
            // }catch(e){
            //   print(e);
            // }
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

        startUpController.promoterId.value = id!;
        startUpController.saveInstallationForPromoters(id);
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