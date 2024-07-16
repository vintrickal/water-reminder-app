import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:water_reminder_app/common/values/colors.dart';
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

  var monthlyBarGraphStream;
  var weeklyBarGraphStream;
  var dailyBarGraphStream;

  @override
  void initState() {
    _initialData();
    super.initState();
  }

  _initialData() {
    historyController.getGraphCount();
    monthlyBarGraphStream = historyController.getMonthlyBarGraph();
    historyController.saveMonthlyBarGraph(monthlyBarGraphStream);

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
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBox30(),
              historyController.barGraphFilter == 0
                  ? buildDailyCalendar()
                  : historyController.barGraphFilter == 1
                      ? buildBarGraphTitle()
                      : buildYearGraphTitle(),
              sizedBox20(),
              buildGraph(context),
              historyController.barGraphFilter == 0
                  ? sizedBox20()
                  : sizedBox10(),
              Obx(
                () => Center(
                  child: reusableText(
                      text: historyController.barGraphFilter == 0
                          ? 'Time'
                          : historyController.barGraphFilter == 1
                              ? 'Day'
                              : 'Monthly',
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
              buildDrinkWaterReport(),
              sizedBox30(),
            ],
          ),
        ),
      ),
    );
  }
}
