import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/common/values/list.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/controller/home_page_controller.dart';

class HistoryController extends GetxController {
  final homeController = Get.put(HomeController());

  var _weeklyBarGraphStream;
  var _dailyBarGraphStream;
  RxInt _barGraphFilter = 1.obs;
  RxString _timeOfDay = ''.obs;
  RxString _dateOfDay = ''.obs;

  get weeklyBarGraphStream => _weeklyBarGraphStream;
  get dailyBarGraphStream => _dailyBarGraphStream;
  get barGraphFilter => _barGraphFilter.value;
  get timeOfDay => _timeOfDay.value;
  get dateOfDay => _dateOfDay.value;

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
}
