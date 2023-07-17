import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/common/utils/conversion.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common/values/list.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/landing/tabs/history/controller/history_page_controller.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          sizedBox30(),
          Center(child: reusableText(text: 'July', fontSize: 17)),
          sizedBox20(),
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Container(
                        margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        child: reusableText(text: 'Amount')),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: StreamBuilder(
                      stream: barGraphUserWaterIntake,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }

                        if (snapshot.hasData) {
                          return Container(
                            height: 250,
                            child: BarChart(
                              BarChartData(
                                barGroups: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;
                                      DateTime date =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              data['date_time']);
                                      return BarChartGroupData(
                                        x: date.day,
                                        barRods: [
                                          BarChartRodData(
                                            color: Colors.blue[400],
                                            toY: data['current_intake']
                                                .toDouble(),
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
                                  // bottomTitles: AxisTitles(
                                  //   sideTitles: SideTitles(
                                  //     reservedSize: 25,
                                  //     showTitles: true,
                                  //   ),
                                  // ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    left: BorderSide(
                                        width: 2,
                                        color: AppColors
                                            .primarySecondaryElementText),
                                    bottom: BorderSide(
                                        width: 2,
                                        color: AppColors
                                            .primarySecondaryElementText),
                                  ),
                                ),
                                // barTouchData: BarTouchData(
                                //     enabled: true,
                                //     handleBuiltInTouches: false,
                                //     mouseCursorResolver: (event, response) {
                                //       return response == null || response.spot == null
                                //           ? MouseCursor.defer
                                //           : SystemMouseCursors.click;
                                //     }),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                        // return Container(
                        //   height: 250,
                        //   child: BarChart(
                        //     BarChartData(
                        //       barGroups: barChartList
                        //           .map((e) => e)
                        //           .toList(), // Create a model for [BarChartGroupData]
                        //       titlesData: FlTitlesData(
                        //           rightTitles: const AxisTitles(
                        //             sideTitles: SideTitles(showTitles: false),
                        //           ),
                        //           topTitles: const AxisTitles(
                        //             sideTitles: SideTitles(
                        //               showTitles: false,
                        //             ),
                        //           ),
                        //           bottomTitles: AxisTitles(
                        //               sideTitles: SideTitles(
                        //             reservedSize: 25,
                        //             showTitles: true,
                        //             getTitlesWidget: (value, meta) {
                        //               return Container(
                        //                   child: Text(
                        //                       'Mon')); // It should be dynamic based on the [date_time] from firebase
                        //             },
                        //           ))),
                        //       borderData: FlBorderData(
                        //         show: true,
                        //         border: Border(
                        //           left: BorderSide(
                        //               width: 2,
                        //               color: AppColors.primarySecondaryElementText),
                        //           bottom: BorderSide(
                        //               width: 2,
                        //               color: AppColors.primarySecondaryElementText),
                        //         ),
                        //       ),
                        //       barTouchData: BarTouchData(
                        //           enabled: true,
                        //           handleBuiltInTouches: false,
                        //           mouseCursorResolver: (event, response) {
                        //             return response == null || response.spot == null
                        //                 ? MouseCursor.defer
                        //                 : SystemMouseCursors.click;
                        //           }),
                        //     ),
                        //   ),
                        // );
                      }),
                ),
              ],
            ),
          ),
          sizedBox10(),
          reusableText(text: 'Day')
        ],
      ),
    );
  }
}
