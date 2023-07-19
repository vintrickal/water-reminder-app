import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common/values/list.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/landing/tabs/history/controller/history_page_controller.dart';
import 'package:water_reminder_app/screens/landing/tabs/history/widgets/history_page_widgets.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final historyController = Get.put(HistoryController());

  var weeklyBarGraphStream;
  var dailyBarGraphStream;

  @override
  void initState() {
    _initialData();
    super.initState();
  }

  _initialData() {
    weeklyBarGraphStream = historyController.getWeeklyBarGraph();
    historyController.saveWeeklyBarGraph(weeklyBarGraphStream);

    dailyBarGraphStream = historyController.getDailyBarGraph();
    historyController.saveDailyBarGraph(dailyBarGraphStream);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBG,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBox30(),
            Container(
              margin: EdgeInsets.only(left: 34),
              child: Obx(
                () => reusableText(
                  text: historyController.barGraphFilter == 0
                      ? '${monthName[DateTime.now().month - 1]} ${DateTime.now().day.toString().padLeft(2, '0')}, ${DateTime.now().year.toString()}'
                      : 'July',
                  fontSize: 18,
                  textColor: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            sizedBox20(),
            buildGraph(context),
            sizedBox20(),
            Obx(
              () => Center(
                child: reusableText(
                    text:
                        historyController.barGraphFilter == 0 ? 'Time' : 'Day',
                    fontSize: 12),
              ),
            ),
            sizedBox30(),
            Center(
              child: ToggleSwitch(
                  activeBgColor: [Colors.blue[400]!],
                  inactiveBgColor: Colors.black26,
                  minWidth: 100,
                  initialLabelIndex: historyController.barGraphFilter,
                  totalSwitches: 3,
                  labels: ['Daily', 'Weekly', 'Monthly'],
                  onToggle: (index) {
                    historyController.setBarGraphFilter(index!);
                  },
                  customTextStyles: [GoogleFonts.poppins()]),
            ),
            sizedBox30(),
            Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(1, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  reusableText(
                      text: 'Drink Water Report',
                      fontSize: 15,
                      textColor: AppColors.cardBgColor),
                  sizedBox30(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      reusableText(text: 'Weekly Average'),
                      reusableText(text: '200 ml/day'),
                    ],
                  ),
                  sizedBox20(),
                  Divider(height: 1),
                  sizedBox20(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      reusableText(text: 'Monthly Average'),
                      reusableText(text: '200 ml/day'),
                    ],
                  ),
                  sizedBox20(),
                  Divider(height: 1),
                  sizedBox20(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      reusableText(text: 'Average Completion'),
                      reusableText(text: '16%'),
                    ],
                  ),
                  sizedBox20(),
                  Divider(height: 1),
                  sizedBox20(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      reusableText(text: 'Drink Frequency'),
                      reusableText(text: '2 times/day'),
                    ],
                  ),
                  sizedBox20(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
