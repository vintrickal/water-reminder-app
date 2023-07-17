import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  var barGraphUserWaterIntake;

  @override
  void initState() {
    _initialData();
    super.initState();
  }

  _initialData() {
    barGraphUserWaterIntake =
        historyController.getBarGraphDataUserWaterIntake();
    historyController.saveBarGraphUserWaterIntake(barGraphUserWaterIntake);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBox30(),
            Center(child: reusableText(text: 'July', fontSize: 15)),
            sizedBox20(),
            buildGraph(context),
            sizedBox10(),
            Center(child: reusableText(text: 'Day', fontSize: 12)),
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
