import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/controller/home_page_controller.dart';

class HistoryController extends GetxController {
  final homeController = Get.put(HomeController());

  var _barGraphUserWaterIntake;

  get barGraphUserWaterIntake => _barGraphUserWaterIntake;

  getBarGraphDataUserWaterIntake() {
    var userWaterIntakeStream;

    userWaterIntakeStream = FirebaseFirestore.instance
        .collection('user-water-intake')
        .where('fusion_id', isEqualTo: getFusionId())
        .orderBy('date_time')
        .snapshots();

    return userWaterIntakeStream;
  }

  String getFusionId() {
    var fusionId = homeController.userId +
        '_${DateTime.now().day.toString().padLeft(2, "0")}_${DateTime.now().month.toString().padLeft(2, "0")}_${DateTime.now().year}';
    return fusionId;
  }

  saveBarGraphUserWaterIntake(dynamic val) {
    _barGraphUserWaterIntake = val;
  }
}
