import 'package:get/get.dart';
import 'package:water_reminder_app/global.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/controller/home_page_controller.dart';
import 'package:water_reminder_app/screens/landing/tabs/settings/widgets/settings_page_widgets.dart';

HomeController homeController = Get.find();

class SettingsController extends GetxController {
  RxDouble _rating = 2280.0.obs;

  get rating => _rating.value;

  setGoalIntake(double value) {
    _rating.update((val) {
      _rating.value = value;
    });
  }

  updateIntakeGoal() {
    Map<String, dynamic> userWaterIntakeItems = {
      'goal_intake': settingsController.rating
    };
    // Update user water in take
    Global.storageService.updateUserWaterIntake(
        homeController.userWaterIntakeId.value, userWaterIntakeItems);
  }
}
