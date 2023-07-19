import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/landing/tabs/history/controller/history_page_controller.dart';
import 'dart:math' as math;

final historyController = Get.put(HistoryController());
Widget buildGraph(BuildContext context) {
  return Scrollbar(
    trackVisibility: true,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 280,
            child: Obx(
              () => Row(
                children: [
                  Container(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                          margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                          child:
                              reusableText(text: 'Amount (ml)', fontSize: 12)),
                    ),
                  ),
                  historyController.barGraphFilter == 0
                      ? dailyBarGraph(context)
                      : weeklyBarGraph(context)
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget weeklyBarGraph(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width / 1.2,
    child: StreamBuilder(
        stream: historyController.weeklyBarGraphStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          if (snapshot.hasData) {
            return Container(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                            data['date_time']);
                        return BarChartGroupData(
                          x: date.day,
                          barRods: [
                            BarChartRodData(
                              color: Colors.blue[400],
                              toY: data['current_intake'].toDouble(),
                              width: 45,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                          ],
                        );
                      })
                      .toList()
                      .cast(),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(
                          width: 2,
                          color: AppColors.primarySecondaryElementText),
                      bottom: BorderSide(
                          width: 2,
                          color: AppColors.primarySecondaryElementText),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        }),
  );
}

Widget dailyBarGraph(BuildContext context) {
  return StreamBuilder(
      stream: historyController.dailyBarGraphStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        if (snapshot.hasData) {
          return Container(
            height: 250,
            width: 500,
            child: Stack(
              children: [
                BarChart(
                  BarChartData(
                    barGroups: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return BarChartGroupData(
                            x: data['time'],
                            barRods: [
                              BarChartRodData(
                                color: Colors.blue[400],
                                toY: data['intake'].toDouble(),
                                width: 45,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                              ),
                            ],
                          );
                        })
                        .toList()
                        .cast(),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          interval: 1,
                          getTitlesWidget: bottomTitleWidgets,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(
                            width: 2,
                            color: AppColors.primarySecondaryElementText),
                        bottom: BorderSide(
                            width: 2,
                            color: AppColors.primarySecondaryElementText),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipMargin: -60,
                        tooltipPadding: EdgeInsets.all(8),
                        tooltipHorizontalOffset: -65,
                        tooltipBgColor: AppColors.primarySecondaryElementText,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          historyController.setToolTip(group.x);
                          return BarTooltipItem(
                            '${historyController.timeOfDay}\n',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${(rod.toY).round().toString()}ml',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      });
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  TextStyle style = GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: AppColors.primaryElementStatus);

  //Convert timestamp to dateTime;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());

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

  // Convert the time to 12hr format

  String format =
      '${time.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $dayIndicator';
  Widget text;
  text = Text(format, style: style);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 15,
    child: Transform.rotate(
      angle: -math.pi / 6,
      child: text,
    ),
  );
}
