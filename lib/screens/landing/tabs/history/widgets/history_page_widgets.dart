import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common/values/list.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/landing/tabs/history/controller/history_page_controller.dart';
import 'dart:math' as math;

final historyController = Get.put(HistoryController());

Widget buildYearGraphTitle() {
  return Container(
    margin: EdgeInsets.only(left: 34),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        reusableText(
          text: '${DateTime.now().year}',
          fontSize: 18,
          textColor: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          width: 10,
        ),
      ],
    ),
  );
}

Widget buildBarGraphTitle() {
  return Container(
    margin: EdgeInsets.only(left: 34),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        reusableText(
          text: monthName[DateTime.now().month - 1],
          fontSize: 18,
          textColor: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          width: 10,
        ),
      ],
    ),
  );
}

Widget buildDailyCalendar() {
  return CalendarTimeline(
    initialDate: DateTime.now(),
    firstDate: DateTime(2022, 1, 01),
    lastDate: DateTime(2054, 12, 30),
    onDateSelected: (date) => print(date),
    leftMargin: 20,
    monthColor: Colors.blueGrey,
    dayColor: Colors.blue[400],
    activeDayColor: Colors.white,
    activeBackgroundDayColor: Colors.green[500],
    dotsColor: Color(0xFF333A47),
    locale: 'en',
  );
}

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
                      : historyController.barGraphFilter == 1
                          ? weeklyBarGraph(context)
                          : monthlyBarGraph(context)
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget monthlyBarGraph(BuildContext context) {
  return StreamBuilder(
      stream: historyController.monthlyBarGraphStream,
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
            width: historyController.barGraphWidthMonthly,
            margin: EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                BarChart(
                  BarChartData(
                    barGroups: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return BarChartGroupData(
                            x: data['month'],
                            barRods: [
                              BarChartRodData(
                                color: Colors.blue[400],
                                toY: data['water_intake'].toDouble(),
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
                          getTitlesWidget: monthlyBottomTitle,
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
                            '${historyController.dateOfDay}\n',
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

Widget weeklyBarGraph(BuildContext context) {
  return StreamBuilder(
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
            width: historyController.barGraphWidthWeekly,
            margin: EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                BarChart(
                  BarChartData(
                    barGroups: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return BarChartGroupData(
                            x: data['date_time'],
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
                      bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          interval: 1,
                          getTitlesWidget: weeklyBottomTitle,
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
                            '${historyController.dateOfDay}\n',
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
          return Obx(
            () => Container(
              height: 250,
              width: historyController.barGraphWidthDaily,
              margin: EdgeInsets.only(right: 16),
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
                                  width: 50,
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
                            getTitlesWidget: dailyBottomTitles,
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
            ),
          );
        } else {
          return Container();
        }
      });
}

Widget dailyBottomTitles(double value, TitleMeta meta) {
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
  } else if (dateTime.hour == 00) {
    dayIndicator = 'AM';
    time = '12';
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

Widget weeklyBottomTitle(double value, TitleMeta meta) {
  TextStyle style = GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: AppColors.primaryElementStatus);

  //Convert timestamp to dateTime;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());

  String format =
      '${monthName[dateTime.month - 1]} ${dateTime.day.toString().padLeft(2, '0')}';
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

Widget monthlyBottomTitle(double value, TitleMeta meta) {
  TextStyle style = GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: AppColors.primaryElementStatus);

  String format = '${monthName[value.toInt() - 1]}';
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

Widget buildDrinkWaterReport() {
  return Container(
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
  );
}
