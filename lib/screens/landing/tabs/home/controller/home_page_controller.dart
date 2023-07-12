import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:water_reminder_app/common/models/user_water_intake_model.dart';
import 'package:water_reminder_app/common/models/water_intake_model.dart';
import 'package:water_reminder_app/common/utils/conversion.dart';
import 'package:water_reminder_app/global.dart';
import 'package:water_reminder_app/main_controller.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/home_page.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/widgets/home_page_widgets.dart';
import 'package:water_reminder_app/screens/onboarding/controller/onboarding_controller.dart';

class HomeController extends GetxController {
  final mainController = Get.put(MainController());
  final onboardingController = Get.put(OnboardingController());

  RxDouble _inTake = 0.0.obs;
  RxDouble _percent = 0.0.obs;
  RxDouble _begin = 0.0.obs;
  RxDouble _end = 0.0.obs;
  RxDouble _goal = 0.0.obs;
  RxString _userWaterIntakeId = ''.obs;
  RxString _userId = ''.obs;
  RxInt _dateTimeRecord = 0.obs;
  var _waterInTakeStream;
  var _userWaterInTakeStream;
  var intakeController = TextEditingController();

  get inTake => _inTake.value;
  get percent => _percent.value;
  get begin => _begin.value;
  get end => _end.value;
  get goal => _goal.value;
  get waterInTakeStream => _waterInTakeStream;
  get userWaterIntakeId => _userWaterIntakeId;
  get userWaterInTakeStream => _userWaterInTakeStream;
  get userId => _userId.value;
  get dateTimeRecord => _dateTimeRecord.value;

  setUserId() {
    if (mainController.userId != '') {
      _userId.update((val) {
        _userId.value = mainController.userId;
      });
    }

    if (onboardingController.userId != '') {
      _userId.update((val) {
        _userId.value = onboardingController.userId;
      });
    }
  }

  initiateData() async {
    bool isDataCreated = await Global.storageService
        .checkIfUserWaterIntakeExists(
            collectionName: 'user-water-intake',
            keyword: 'fusion_id',
            value: getFusionId());

    if (!isDataCreated) {
      UserWaterIntakeModel model =
          UserWaterIntakeModel(date_time: DateTime.now());

      model.id = '';
      model.fusion_id = getFusionId();
      model.user_id = _userId.value;
      model.past_intake = 0;
      model.current_intake = 0;
      model.goal_intake = 2280;
      model.percent_intake = 0;

      _goal.update((val) {
        _goal.value = 2280;
      });

      Map<String, dynamic> userWaterIntakeItems = model.toJson();

      // Create document and return the document id
      await Global.storageService
          .addUserIntakeGoal('user-water-intake', userWaterIntakeItems);
    } else {
      List document = await Global.storageService.getCollection(
          collectionName: 'user-water-intake',
          keyword: 'fusion_id',
          value: getFusionId());

      _goal.value = document[0]['goal_intake'];
    }
  }

  getProgressWaterInTake() {
    var userWaterIntakeStream;

    userWaterIntakeStream = FirebaseFirestore.instance
        .collection('user-water-intake')
        .where('fusion_id', isEqualTo: getFusionId())
        .snapshots();

    return userWaterIntakeStream;
  }

  void computeWaterInTake(
      {required double passedInTake,
      required double goalInTake,
      required int timestamp}) async {
    try {
      if (_percent + 0.1 < 1.0) {
        _begin.value = _inTake.value;
        _inTake.value = _begin.value + passedInTake;
        _end.value = _inTake.value;
        _percent.value = (_end.value / 2280);
      } else {
        _percent.value = 1.0;
        _begin.value = _inTake.value;
        _inTake.value = _begin.value + passedInTake;
        _end.value = _inTake.value;
      }
    } catch (e) {
      print('Error log: $e');
    }

    WaterIntakeModel model = WaterIntakeModel();
    model.id = '';
    model.user_water_intake_id = getFusionId();
    model.intake = passedInTake;
    model.type = 'cup';
    model.user_id = _userId.value;
    model.time = timestamp;

    Map<String, dynamic> items = model.toJson();

    Global.storageService.addUserIntake('water-intake', items);

    updateUserWaterIntakeGoal(goal: goalInTake);
  }

  Future<void> updateUserWaterIntakeGoal({required double goal}) async {
    Map<String, dynamic> userWaterIntakeItems = {
      'past_intake': _begin.value,
      'current_intake': _end.value,
      'goal_intake': goal,
      'percent_intake': _percent.value
    };

    // Update user water in take
    Global.storageService
        .updateUserWaterIntake(_userWaterIntakeId.value, userWaterIntakeItems);
  }

  void updateComputationWaterInTake({
    required double passedInTake,
    required double goalInTake,
    required int timestamp,
    required String id,
    required double pastIntake,
  }) async {
    try {
      if (_percent + 0.1 < 1.0) {
        _begin.value = _inTake.value - pastIntake;
        _inTake.value = _begin.value + passedInTake;
        _end.value = _inTake.value;
        _percent.value = (_end.value / 2280);
      } else {
        _percent.value = 1.0;
        _begin.value = _inTake.value;
        _inTake.value = _begin.value + passedInTake;
        _end.value = _inTake.value;
      }
    } catch (e) {
      print('Error log: $e');
    }

    Map<String, dynamic> items = {
      'intake': passedInTake,
      'time': timestamp,
    };

    // Update water intake
    Global.storageService.updateWaterIntake(id, items);

    // Update user water intake
    updateUserWaterIntakeGoal(goal: goalInTake);
  }

  String getFusionId() {
    return _userId.value +
        '_${DateTime.now().day.toString().padLeft(2, "0")}_${DateTime.now().month.toString().padLeft(2, "0")}_${DateTime.now().year}';
  }

  String getTimeFormat(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var timeFormat = DateFormat.jm().format(DateFormat("hh:mm:ss").parse(
        '${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}'));

    return timeFormat;
  }

  saveWaterIntake(dynamic water) {
    _waterInTakeStream = water;
  }

  saveUserWaterIntake(dynamic goal) {
    _userWaterInTakeStream = goal;
  }

  setVariables({required double begin, required String documentId}) {
    _inTake.value = begin;
    _percent.value = (_inTake.value / 2280);
    _userWaterIntakeId.value = documentId;
  }

  setSelectedOption() {
    (OptionItem item) {
      selectedMenu = item;
    };
  }

  onTapDelete(Map<String, dynamic> map) {
    print('Delete option was pressed! ${map['id']}');

    // process the updated water intake
    var currentIntake = _end.value - map['intake'];
    var percent = currentIntake == 0 ? 0 : currentIntake / _goal.value;

    Map<String, dynamic> items = {
      'current_intake': currentIntake,
      'past_intake': _begin.value == 0 ? 0 : _begin.value - map['intake'],
      'percent_intake': percent
    };

    //Update water user intake
    Global.storageService
        .updateUserWaterIntake(_userWaterIntakeId.value, items);

    // Delete individual data for water intake
    FirebaseFirestore.instance
        .collection('water-intake')
        .doc(map['id'])
        .delete();
  }

  onTapEdit(Map<String, dynamic> map, BuildContext context) {
    print('Edit option was pressed! ${map['id']}');
    homeController.setEditTextController(map['intake']);
    showPopupDialogEdit(context, map);
  }

  setTimeRecord(DateTime time) {
    _dateTimeRecord.update((val) {
      _dateTimeRecord.value = timestampConversion(time);
    });
  }

  setEditTextController(double intake) {
    intakeController.text = intake.toString().contains('.')
        ? intake.toString().substring(0, intake.toString().indexOf('.'))
        : intake.toString();
  }
}
