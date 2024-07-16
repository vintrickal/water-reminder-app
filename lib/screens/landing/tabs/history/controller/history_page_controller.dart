import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/common/values/list.dart';
import 'package:water_reminder_app/global.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/controller/home_page_controller.dart';

class HistoryController extends GetxController {
  final homeController = Get.put(HomeController());

  var _monthlyBarGraphStream;
  var _weeklyBarGraphStream;
  var _dailyBarGraphStream;
  RxInt _barGraphFilter = 1.obs;
  RxInt _monthlyCount = 0.obs;
  RxInt _weeklyCount = 0.obs;
  RxInt _dailyCount = 0.obs;
  RxInt _weeklyAverage = 0.obs;
  RxInt _monthlyAverage = 0.obs;
  RxInt _averageCompletion = 0.obs;
  RxInt _drinkFrequency = 0.obs;
  RxString _timeOfDay = ''.obs;
  RxString _dateOfDay = ''.obs;
  RxDouble _barGraphWidthDaily = 350.0.obs;
  RxDouble _barGraphWidthWeekly = 350.0.obs;
  RxDouble _barGraphWidthMonthly = 350.0.obs;

  get monthlyBarGraphStream => _monthlyBarGraphStream;
  get weeklyBarGraphStream => _weeklyBarGraphStream;
  get dailyBarGraphStream => _dailyBarGraphStream;
  get barGraphFilter => _barGraphFilter.value;
  get timeOfDay => _timeOfDay.value;
  get dateOfDay => _dateOfDay.value;
  get monthlyCount => _monthlyCount.value;
  get weeklyCount => _weeklyCount.value;
  get dailyCount => _dailyCount.value;
  get weeklyAverage => _weeklyAverage.value;
  get monthlyAverage => _monthlyAverage.value;
  get averageCompletion => _averageCompletion.value;
  get drinkFrequency => _drinkFrequency.value;
  get barGraphWidthDaily => _barGraphWidthDaily.value;
  get barGraphWidthWeekly => _barGraphWidthWeekly.value;
  get barGraphWidthMonthly => _barGraphWidthMonthly.value;

  processXAxisMonthly(double month) {
    int value;

    String temp = monthName[month.toInt() - 1];
    value = int.parse(temp);

    return value;
  }

  getMonthlyBarGraph() {
    var monthlyBarGraphStream;

    monthlyBarGraphStream = FirebaseFirestore.instance
        .collection('monthly-user-water-intake')
        .where('user_id', isEqualTo: homeController.userId)
        .where('year', isEqualTo: DateTime.now().year)
        .orderBy('month')
        .snapshots();

    return monthlyBarGraphStream;
  }

  getWeeklyBarGraph() {
    var weeklyBarGraphStream;

    weeklyBarGraphStream = FirebaseFirestore.instance
        .collection('user-water-intake')
        .where('user_id', isEqualTo: homeController.userId)
        .orderBy('date_time')
        .snapshots();

    return weeklyBarGraphStream;
  }

  getDailyBarGraph() {
    var dailyBarGraphStream;

    dailyBarGraphStream = FirebaseFirestore.instance
        .collection('water-intake')
        .where('user_water_intake_id', isEqualTo: getFusionId())
        .orderBy('time')
        .snapshots();

    return dailyBarGraphStream;
  }

  getGraphCount() async {
    var tempDaily = await Global.storageService.getCollectionLength(
        collectionName: 'water-intake',
        keyword: 'user_water_intake_id',
        value: getFusionId());

    _dailyCount.update((val) {
      _dailyCount.value = tempDaily;
    });

    var tempWeekly = await Global.storageService.getCollectionLength(
        collectionName: 'user-water-intake',
        keyword: 'user_id',
        value: homeController.userId);

    _weeklyCount.update((val) {
      _weeklyCount.value = tempWeekly;
    });

    var tempMonthly = await Global.storageService.getCollectionLength(
        collectionName: 'monthly-user-water-intake',
        keyword: 'user_id',
        value: homeController.userId);

    _monthlyCount.update((val) {
      _monthlyCount.value = tempMonthly;
    });

    setBarGraphWidth();
  }

  String getFusionId() {
    var fusionId = homeController.userId +
        '_${DateTime.now().day.toString().padLeft(2, "0")}_${DateTime.now().month.toString().padLeft(2, "0")}_${DateTime.now().year}';
    return fusionId;
  }

  setBarGraphFilter(int value) {
    _barGraphFilter.update((val) {
      _barGraphFilter.value = value;
    });
  }

  saveMonthlyBarGraph(dynamic val) {
    _monthlyBarGraphStream = val;
  }

  saveWeeklyBarGraph(dynamic val) {
    _weeklyBarGraphStream = val;
  }

  saveDailyBarGraph(dynamic val) {
    _dailyBarGraphStream = val;
  }

  setToolTip(int timestamp) {
    //Convert timestamp to dateTime;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Get the day indicator and 12hr format
    String dayIndicator = '';
    String time = '';
    if (dateTime.hour >= 12) {
      dayIndicator = 'PM';
      time = (dateTime.hour - 12).toString();
    } else if (dateTime.hour == 00) {
      dayIndicator = 'AM';
      time = '12';
    } else {
      dayIndicator = 'AM';
      time = dateTime.hour.toString();
    }
    _dateOfDay.update((val) {
      _dateOfDay.value =
          '${monthName[dateTime.month - 1]} ${dateTime.day.toString().padLeft(2, '0')}, ${dateTime.year.toString()}';
    });
    _timeOfDay.update(
      (val) {
        _timeOfDay.value =
            '${time.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $dayIndicator';
      },
    );
  }

  setBarGraphWidth() {
    // Daily Bar Graph Width
    _barGraphWidthDaily.update((val) {
      _barGraphWidthDaily.value = 250 + _dailyCount.value * 50;
    });

    // Weekly Bar Graph Width
    _barGraphWidthWeekly.update((val) {
      _barGraphWidthWeekly.value = 250 + _weeklyCount.value * 50;
    });

    // Monthly Bar Graph Width
    _barGraphWidthMonthly.update((val) {
      _barGraphWidthMonthly.value = 250 + _monthlyCount.value * 50;
    });
  }

  setWeeklyAverageReport() {}
}
