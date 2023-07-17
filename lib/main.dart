import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/global.dart';
import 'package:water_reminder_app/main_controller.dart';
import 'package:water_reminder_app/screens/landing/landing_page.dart';
import 'package:water_reminder_app/screens/splash/splash_page.dart';

void main() async {
  await Global.init();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final mainController = Get.put(MainController());

  @override
  void initState() {
    mainController.getSharedPref();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Alarm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Obx(
        () => mainController.isLoading
            ? Scaffold(
                backgroundColor: Colors.white,
              )
            : mainController.didUserExist
                ? LandingPage()
                : const SplashPage(),
      ),
      builder: EasyLoading.init(),
    );
  }
}
