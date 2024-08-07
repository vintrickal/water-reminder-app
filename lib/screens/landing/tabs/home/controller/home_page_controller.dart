import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:water_reminder_app/common/models/cup_model.dart';
import 'package:water_reminder_app/common/models/monthly_user_water_intake_model.dart';
import 'package:water_reminder_app/common/models/user_water_intake_model.dart';
import 'package:water_reminder_app/common/models/water_intake_model.dart';
import 'package:water_reminder_app/common/utils/conversion.dart';
import 'package:water_reminder_app/common/values/list.dart';
import 'package:water_reminder_app/global.dart';
import 'package:water_reminder_app/main_controller.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/home_page.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/widgets/home_page_widgets.dart';
import 'package:water_reminder_app/screens/onboarding/controller/onboarding_controller.dart';

class HomeController extends GetxController {
  MainController mainController = Get.find();
  final onboardingController = Get.put(OnboardingController());

  RxDouble _inTake = 0.0.obs;
  RxDouble _percent = 0.0.obs;
  RxDouble _begin = 0.0.obs;
  RxDouble _end = 0.0.obs;
  RxDouble _goal = 0.0.obs;
  RxString _userWaterIntakeId = ''.obs;
  RxString _monthlyUserWaterIntakeId = ''.obs;
  RxString _userId = ''.obs;
  RxString _deviceToken = ''.obs;
  RxString _selectedCup = '3'.obs;
  RxString _selectedCupCapacity = '200'.obs;
  RxString _selectedCupPath = 'assets/icons/png/200ml.png'.obs;
  RxString _editSelectedCup = '3'.obs;
  RxString _editSelectedCupCapacity = '200'.obs;
  RxString _editSelectedCupPath = 'assets/icons/png/200ml.png'.obs;

  RxInt _dateTimeRecord = 0.obs;
  var _waterInTakeStream;
  var _userWaterInTakeStream;
  var intakeController = TextEditingController();
  var _homeUserList = [].obs;

  get inTake => _inTake.value;
  get percent => _percent.value;
  get begin => _begin.value;
  get end => _end.value;
  get goal => _goal.value;
  get waterInTakeStream => _waterInTakeStream;
  get userWaterIntakeId => _userWaterIntakeId.value;
  get userWaterInTakeStream => _userWaterInTakeStream;
  get userId => _userId.value;
  get dateTimeRecord => _dateTimeRecord.value;
  get deviceToken => _deviceToken.value;
  get selectedCup => _selectedCup.value;
  get selectedCupCapacity => _selectedCupCapacity.value;
  get selectedCupPath => _selectedCupPath.value;
  get editSelectedCup => _editSelectedCup.value;
  get editSelectedCupCapacity => _editSelectedCupCapacity.value;
  get editSelectedCupPath => _editSelectedCupPath.value;

  get homeUserList => _homeUserList;

  setUserId() async {
    if (mainController.userId != '') {
      _userId.update((val) {
        _userId.value = mainController.userId;
      });
      _deviceToken.update((val) {
        _deviceToken.value = mainController.deviceToken;
      });
    }

    if (onboardingController.userId != '') {
      _userId.update((val) {
        _userId.value = onboardingController.userId;
      });
      _deviceToken.update((val) {
        _deviceToken.value = onboardingController.deviceToken;
      });
    }

    var tempList = await Global.storageService.getCollection(
        collectionName: 'user', keyword: 'user_id', value: _userId.value);

    _homeUserList = RxList(tempList);
  }

  initiateData() async {
    //#region Data Creation
    bool isDataCreated = await Global.storageService.checkDataExistence(
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
      model.goal_intake =
          double.parse(onboardingController.recommendedWaterIntake.toString());
      model.percent_intake = 0;
      model.month_id =
          '${DateTime.now().month.toDouble()}_${DateTime.now().year.toDouble()}';

      _goal.update((val) {
        _goal.value = double.parse(
            onboardingController.recommendedWaterIntake.toString());
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
    //#endregion

    //#region Cup setup
    List defaultCup = await Global.storageService.getCollection(
        collectionName: 'user', keyword: 'user_id', value: _userId.value);

    var index = int.parse(defaultCup[0]['selected_cup']);

    // Set the user cup
    _selectedCup.update((val) {
      _selectedCup.value = defaultCup[0]['selected_cup'];
    });

    // Set the user cup capacity
    _selectedCupCapacity.update(
      (val) {
        _selectedCupCapacity.value = cups[index].capacity!;
      },
    );

    // Set the user cup path
    _selectedCupPath.update((val) {
      _selectedCupPath.value = cups[index].path!;
    });

    //#endregion

    //#region Monthly user water intake
    bool isMonthlyDataCreated = await Global.storageService
        .checkMultipleDataExistence(
            collectionName: 'monthly-user-water-intake',
            keyword1: 'year',
            value1: DateTime.now().year,
            keyword2: 'month',
            value2: DateTime.now().month,
            keyword3: 'user_id',
            value3: _userId.value);

    if (!isMonthlyDataCreated) {
      MonthlyUserWaterIntakeModel model = MonthlyUserWaterIntakeModel();

      model.id = '';
      model.month = DateTime.now().month;
      model.water_intake = 0;
      model.year = DateTime.now().year;
      model.user_id = _userId.value;

      Map<String, dynamic> monthlyUserWaterIntakeItems = model.toJson();

      // Create document and return the document id
      _monthlyUserWaterIntakeId.value = await Global.storageService
          .addMonthlyUserIntakeGoal(
              'monthly-user-water-intake', monthlyUserWaterIntakeItems);
    } else {
      List document = await Global.storageService.getCollection(
          collectionName: 'monthly-user-water-intake',
          keyword: 'month',
          value: DateTime.now().month);

      _monthlyUserWaterIntakeId.value = document[0]['id'];
    }
    //#endregion
  }

  getProgressWaterInTake() {
    var userWaterIntakeStream;

    userWaterIntakeStream = FirebaseFirestore.instance
        .collection('user-water-intake')
        .where('fusion_id', isEqualTo: getFusionId())
        .snapshots();

    return userWaterIntakeStream;
  }

  void computeWaterInTake({
    required double passedInTake,
    required int timestamp,
    required String selectedCup,
  }) async {
    try {
      var roundedPercent = _percent.value * 100;
      if (roundedPercent.round() < 100) {
        _begin.value = _inTake.value;
        _inTake.value = _begin.value + passedInTake;
        _end.value = _inTake.value;
        _percent.value =
            (_end.value / _homeUserList[0]['user_goal_intake']) * 100;
      } else {
        _percent.value = _percent.value * 100;
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
    model.type = homeController.selectedCup;
    model.user_id = _userId.value;
    model.time = timestamp;

    Map<String, dynamic> items = model.toJson();

    Global.storageService.addUserIntake('water-intake', items);

    updateUserWaterIntakeGoal(goal: _homeUserList[0]['user_goal_intake']);
    updateMonthlyUserWaterIntake();
  }

  Future<void> updateUserWaterIntakeGoal({required double goal}) async {
    Map<String, dynamic> userWaterIntakeItems = {
      'past_intake': _begin.value,
      'current_intake': _end.value,
      'goal_intake': goal,
      'percent_intake': _percent.value.round()
    };

    // Update user water in take
    Global.storageService
        .updateUserWaterIntake(_userWaterIntakeId.value, userWaterIntakeItems);
  }

  Future<void> updateMonthlyUserWaterIntake() async {
    Map<String, dynamic> monthlyUserWaterIntakeItems = {
      'water_intake': _end.value,
    };

    // Update monthly user water in take
    Global.storageService.updateMonthlyUserWaterIntake(
        _monthlyUserWaterIntakeId.value, monthlyUserWaterIntakeItems);
  }

  void updateComputationWaterInTake({
    required double passedInTake,
    required int timestamp,
    required String id,
    required double pastIntake,
  }) async {
    try {
      var roundedPercent = _percent.value * 100;
      if (roundedPercent.round() < 100) {
        _begin.value = _inTake.value - pastIntake;
        _inTake.value = _begin.value + passedInTake;
        _end.value = _inTake.value;
        _percent.value =
            (_end.value / _homeUserList[0]['user_goal_intake']) * 100;
      } else {
        _percent.value = _percent.value * 100;
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
    updateUserWaterIntakeGoal(goal: _homeUserList[0]['user_goal_intake']);
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

    if (_homeUserList[0]['user_goal_intake'] != []) {
      _percent.value = (_inTake.value / _homeUserList[0]['user_goal_intake']);
    } else if (mainController.mainUserList[0]['user_goal_intake'] != []) {
      _percent.value =
          (_inTake.value / mainController.mainUserList[0]['user_goal_intake']);
    }

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
    _end.update((val) {
      _end.value = currentIntake;
    });
    var percent = currentIntake == 0 ? 0 : currentIntake / _goal.value * 100;

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
    homeController.setEditSelectedCup(map);
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

  setEditSelectedCup(Map<String, dynamic> map) {
    _editSelectedCup.update((val) {
      _editSelectedCup.value = map['type'];
      _editSelectedCupCapacity = map['intake'];
      _editSelectedCupPath.value = cups[int.parse(map['type'])].path!;
    });
  }

  setSelectedCup(CupModel model) {
    _selectedCup.update((val) {
      _selectedCup.value = model.id!;
    });

    _selectedCupCapacity.update((val) {
      _selectedCupCapacity.value = model.capacity!;
    });

    _selectedCupPath.update((val) {
      _selectedCupPath.value = model.path!;
    });

    Map<String, dynamic> item = {'selected_cup': _selectedCup.value};
    Global.storageService.updateSelectedCup(_userId.value, item);
  }
}
