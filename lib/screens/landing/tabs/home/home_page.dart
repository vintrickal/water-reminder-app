import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    homeController.setUserId();
    _initialData();
    _getUserWaterIntake();
    _getWaterIntake(homeController.getFusionId());
    super.initState();
  }

  //#region Initialization
  _initialData() async {
    await homeController.initiateData();
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
    return SingleChildScrollView(
      child: Column(
        children: [
          sizedBox10(),
          buildReminderAvatar(
              assetName: 'assets/icons/png/thumbs_up.png',
              quote: "Drink your glass of water slowly with some small sips",
              count: 0),
          sizedBox10(),
          buildCircularProgressWaterInTake(),
          buildAddWaterInTakeButton(
            assetName: 'assets/icons/png/water_cup_icon_v2.png',
            onTap: () {
              setState(() {
                homeController.computeWaterInTake(
                    passedInTake: 200,
                    goalInTake: 2280,
                    timestamp: DateTime.now().millisecondsSinceEpoch);
              });
            },
          ),
          buildTodayRecordText(
            onTap: () {
              showPopupDialog(context);
            },
          ),
          buildTimelineTracker(),
        ],
      ),
    );
  }
}
