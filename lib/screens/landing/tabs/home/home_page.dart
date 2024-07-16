import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/global.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/controller/home_page_controller.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/widgets/home_page_widgets.dart';

enum OptionItem { delete, edit }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = Get.put(HomeController());

  var waterIntakeStream;
  var userWaterInTakeStream;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  @override
  void initState() {
    homeController.setUserId();
    _initialData();
    super.initState();
  }

  //#region Initialization
  _initialData() {
    homeController.initiateData();
    _getUserWaterIntake();
    _getWaterIntake(homeController.getFusionId());
  }

  _getUserWaterIntake() {
    userWaterInTakeStream = homeController.getProgressWaterInTake();
    print('Data: ${userWaterInTakeStream}');
    homeController.saveUserWaterIntake(userWaterInTakeStream);
  }

  _getWaterIntake(String fusionID) {
    waterIntakeStream = Global.storageService.getWaterInTake(fusionID);
    homeController.saveWaterIntake(waterIntakeStream);
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBG,
      body: SingleChildScrollView(
        child: Column(
          children: [
            sizedBox10(),
            buildReminderAvatar(
                assetName: 'assets/icons/png/thumbs_up.png',
                quote: "Drink your glass of water slowly with some small sips",
                count: 0),
            sizedBox20(),
            buildCircularProgressWaterInTake(),
            sizedBox20(),
            buildTodayRecordText(
              onTap: () {
                showPopupDialog(context);
              },
            ),
            buildTimelineTracker(),
          ],
        ),
      ),
      floatingActionButton:
          buildFloatingActionButton(context, isDialOpen: isDialOpen),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
