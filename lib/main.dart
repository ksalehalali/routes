
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:myfatoorah_flutter/utils/MFCountry.dart';
import 'package:myfatoorah_flutter/utils/MFEnvironment.dart';
import 'package:routes/Assistants/globals.dart';
import 'controller/lang_controller.dart';
import 'controller/location_controller.dart';
import 'package:get_storage/get_storage.dart';

import 'controller/payment_controller.dart';
import 'controller/start_up_controller.dart';
import 'controller/transactions_controller.dart';
import 'controller/trip_controller.dart';
import 'localization/localization.dart';


Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller =Get.putAsync(() async => LocationController(),permanent: true);
  final paymentController =Get.putAsync(() async => PaymentController(),permanent: true);
  final tripsController =Get.putAsync(() async => TripController(),permanent: true);
  final transactionsController =Get.putAsync(() async => TransactionsController(),permanent: true);
  final langController =Get.putAsync(() async => LangController(),permanent: true);
  MFSDK.init( 'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL',MFCountry.KUWAIT,MFEnvironment.TEST);
  await GetStorage.init();

  runApp( GetMaterialApp(
    locale: Locale('en'),
    fallbackLocale: Locale('en'),
    translations: Localization(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(),
    home:  MYApp()
  ),);
}
class MYApp extends StatefulWidget {
  const MYApp({Key? key}) : super(key: key);

  @override
  _MYAppState createState() => _MYAppState();
}

class _MYAppState extends State<MYApp> with TickerProviderStateMixin {
  final startUpController = Get.put(StartUpController());
  late final AnimationController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this,duration: 22.seconds);
    startUpController.fetchUserLoginPreference();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Lottie.asset(
        'assets/animation/17314-bus.json',
        height: 122,
        width: 122,
        controller: _controller,
        onLoaded: (composition) {
          // Configure the AnimationController with the duration of the
          // Lottie file and start the animation.
          _controller..duration = composition.duration
            ..forward();
        },
      ),
    );
  }
}

