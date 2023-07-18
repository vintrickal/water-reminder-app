import 'package:get/get.dart';
import 'package:water_reminder_app/global.dart';
import 'package:water_reminder_app/main_controller.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/controller/home_page_controller.dart';
import 'package:water_reminder_app/screens/landing/tabs/settings/widgets/settings_page_widgets.dart';

HomeController homeController = Get.find();
MainController mainController = Get.find();

class SettingsController extends GetxController {
  RxDouble _rating = 2280.0.obs;
  RxDouble _percentage = 50.0.obs;

  get rating => _rating.value;
  get percentage => _percentage.value;

  initializedData() async {
    _rating.update((val) {
      _rating.value = homeController.homeUserList[0]['user_goal_intake'];
    });

    _percentage.update((val) {
      _percentage.value = homeController.homeUserList[0]
              ['recommended_goal_intake'] /
          4500 *
          100;
    });
  }

  setGoalIntake(double value) {
    _rating.update((val) {
      _rating.value = value;
    });
  }

  updateIntakeGoal() {
    double newPercent = homeController.inTake / settingsController.rating * 100;

    Map<String, dynamic> userWaterIntakeItems = {
      'goal_intake': settingsController.rating,
      'percent_intake': newPercent.round(),
    };

    // Update user water in take
    Global.storageService.updateUserWaterIntake(
        homeController.userWaterIntakeId, userWaterIntakeItems);

    Map<String, dynamic> userGoalIntakeItems = {
      'user_goal_intake': settingsController.rating
    };

    Global.storageService
        .updateUserInfomation(homeController.userId, userGoalIntakeItems);
  }
}
