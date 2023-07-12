import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:water_reminder_app/common/utils/conversion.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/controller/home_page_controller.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/home_page.dart';

final homeController = Get.put(HomeController());
Widget buildFirstReminderAvatar({
  required String assetName,
  required String quote,
  required int count,
}) {
  return Row(
    key: ValueKey<int>(count),
    children: [
      Container(
        width: 70.w,
        height: 70.h,
        child: Image.asset(assetName),
      ),
      ChatBubble(
        clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
        backGroundColor: Colors.blue.shade200,
        margin: EdgeInsets.only(top: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 200,
          ),
          child: Text(
            quote,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      )
    ],
  );
}

Widget buildReminderAvatar({
  required String assetName,
  required String quote,
  required int count,
}) {
  return Row(
    key: ValueKey<int>(count),
    children: [
      Container(
        width: 70.w,
        height: 70.h,
        child: Image.asset(assetName),
      ),
      ChatBubble(
        clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
        backGroundColor: Colors.blue.shade200,
        margin: EdgeInsets.only(top: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 256,
          ),
          child: Text(
            quote,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      )
    ],
  );
}

Widget buildCircularProgressWaterInTake() {
  return StreamBuilder(
    stream: homeController.userWaterInTakeStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text("0/0");
      }

      return Column(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

          homeController.setVariables(
              begin: double.parse(
                data['current_intake'].toString(),
              ),
              documentId: data['id']);
          return buildCircularProgress(
            percent: double.parse(data['percent_intake'].toString()),
            begin: double.parse(data['past_intake'].toString()),
            end: double.parse(data['current_intake'].toString()),
            goal: double.parse(data['goal_intake'].toString()),
          );
        }).toList()
          ..reversed.cast(),
      );
    },
  );
}

Widget buildCircularProgress({
  required double percent,
  required double begin,
  required double end,
  required double goal,
}) {
  return CircularPercentIndicator(
    animateFromLastPercent: true,
    radius: 130.0,
    animation: true,
    animationDuration: 500,
    lineWidth: 30.0,
    percent: percent,
    center: CircleAvatar(
      radius: percent == 1 ? 100 : 90,
      backgroundColor: Colors.blue.shade600,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5.h, top: 15.h),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/icons/png/water_splash_icon.png'),
            )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Countup(
                    begin: begin,
                    end: end,
                    duration: Duration(milliseconds: 500),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.normal),
                  ),
                  reusableText(
                      text:
                          ' / ${goal.toString().contains('.') ? goal.toString().substring(0, goal.toString().indexOf('.')) : goal.toString()}',
                      textColor: Colors.white,
                      fontSize: 24.sp)
                ],
              ),
              reusableText(
                text: 'Water Intake Goal',
                textColor: Colors.white,
                fontSize: 18.sp,
              ),
            ],
          )
        ],
      ),
    ),
    circularStrokeCap: CircularStrokeCap.round,
    backgroundColor: Colors.grey.shade300,
    progressColor: Colors.blue.shade600,
  );
}

Widget buildAddWaterInTakeButton(
    {required String assetName, required void Function() onTap}) {
  return Container(
    margin: EdgeInsets.only(right: 30.w),
    child: Align(
      alignment: Alignment.centerRight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: onTap,
            child: Stack(alignment: Alignment.center, children: [
              Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade200,
                    border: Border.all(color: Colors.blue.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(1, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    child: Image.asset(assetName),
                  )),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  // border: Border.all(width: 2, color: Colors.blue),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  size: 15,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ]),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                print('InkWell was clicked!');
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  width: 25,
                  height: 25,
                  child: Icon(
                    Icons.edit,
                    size: 15,
                    color: Colors.blue.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildStartTimeline({
  required String assetName,
  required String time,
  required String inTake,
  void Function(OptionItem)? onSelected,
  void Function()? onTapDelete,
  void Function()? onTapEdit,
}) {
  return timelineTile(
    assetName: assetName,
    time: time,
    inTake: inTake,
    isFirst: false,
    isLast: true,
    onSelected: onSelected,
    onTapDelete: onTapDelete,
    onTapEdit: onTapEdit,
  );
}

OptionItem? selectedMenu;

Widget timelineTile({
  bool? isFirst = false,
  bool? isLast = false,
  double? indicatorXY = .5,
  double? topPadding = 20,
  void Function(OptionItem)? onSelected,
  void Function()? onTapDelete,
  void Function()? onTapEdit,
  required String assetName,
  required String time,
  required String inTake,
}) {
  return Column(
    children: [
      DottedLine(
        dashColor: AppColors.primaryThirdElementText,
      ),
      Container(
        height: 60.h,
        child: TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.0,
          isFirst: isFirst!,
          isLast: isLast!,
          afterLineStyle: LineStyle(
            color: Colors.blue.shade200,
            thickness: 3,
          ),
          beforeLineStyle: LineStyle(
            color: Colors.blue.shade200,
            thickness: 3,
          ),
          indicatorStyle: IndicatorStyle(
            width: 35,
            height: 35,
            indicator: _indicatorIcon(assetName),
            indicatorXY: indicatorXY!,
            padding: EdgeInsets.only(
                right: 20.w, left: 20.h, top: topPadding!, bottom: 20.h),
          ),
          axis: TimelineAxis.vertical,
          endChild: Container(
            margin: EdgeInsets.only(right: 10.w, bottom: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(inTake),
                      PopupMenuButton<OptionItem>(
                        initialValue: selectedMenu,
                        onSelected: onSelected,
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<OptionItem>>[
                          PopupMenuItem<OptionItem>(
                            onTap: onTapDelete,
                            value: OptionItem.delete,
                            child: Text('Delete'),
                          ),
                          PopupMenuItem<OptionItem>(
                            onTap: onTapEdit,
                            value: OptionItem.edit,
                            child: Text('Edit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _indicatorIcon(String assetName) {
  return Stack(children: [
    Image.asset(assetName),
  ]);
}

Widget buildTodayRecordText({void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: 15.w),
              child: reusableText(
                  text: "Today's Record",
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp)),
          Icon(
            Icons.add,
            size: 20,
            color: AppColors.primary_bg,
          )
        ],
      ),
    ),
  );
}

Widget buildTimelineTracker({Widget? streamBuilder}) {
  return Container(
      margin: EdgeInsets.only(top: 10.w, left: 10.w, right: 10.w, bottom: 10.w),
      decoration: BoxDecoration(
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
      child: StreamBuilder(
        stream: homeController.waterInTakeStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return Column(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              String timeFormat = homeController.getTimeFormat(data['time']);

              return buildStartTimeline(
                assetName: 'assets/icons/png/water_cup_icon_new.png',
                time: timeFormat,
                inTake:
                    '${data['intake'].toString().substring(0, data['intake'].toString().indexOf('.'))}ml',
                onSelected: homeController.setSelectedOption(),
                onTapDelete: () {
                  homeController.onTapDelete(data);
                },
                onTapEdit: () {
                  homeController.onTapEdit(data, context);
                },
              );
            }).toList()
              ..reversed.cast(),
          );
        },
      ));
}

Widget buildAnimatedSwitcher(Widget widget) {
  return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) =>
          ScaleTransition(
            child: child,
            scale: animation,
          ),
      child: widget);
}

Widget buildTimeOption(BuildContext context, TextEditingController controller,
    {void Function(DateTime)? onTimeChange, required DateTime time}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        width: 120,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image.asset('assets/icons/png/alarm_clock_digital.png'),
            Positioned(
              top: -85,
              left: 1,
              child: TimePickerSpinner(
                time: time,
                is24HourMode: true,
                normalTextStyle:
                    const TextStyle(fontSize: 20, color: Colors.transparent),
                highlightedTextStyle: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                spacing: 10,
                itemHeight: 80,
                isForce2Digits: true,
                onTimeChange: onTimeChange,
              ),
            ),
          ],
        ),
      ),
      Container(
        child: Row(children: [
          SizedBox(
            width: 45,
            height: 45,
            child: Image.asset('assets/icons/png/water_cup_icon_new.png'),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 50,
                child: Material(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 4,
                    controller: controller,
                    style: TextStyle(fontSize: 18.sp),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    onSubmitted: (String value) async {},
                  ),
                ),
              ),
            ],
          ),
          reusableText(text: 'ml', textColor: Colors.black, fontSize: 18.sp)
        ]),
      )
    ],
  );
}

showPopupDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width - 16,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8.0),
                      Icon(
                        Icons.watch_later_outlined,
                        size: 50,
                      ),
                      sizedBox20(),
                      Material(
                        color: Colors.white,
                        child: Text(
                          'Did you forgot to logged your intake again?',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                            fontFamily: 'LexendDeca',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildTimeOption(context, homeController.intakeController,
                          onTimeChange: (time) {
                        homeController.setTimeRecord(time);
                      }, time: DateTime.now()),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          var temp = homeController.intakeController.text;

                          if (temp.trim().isEmpty) {
                            Navigator.pop(context);
                            Get.snackbar('Missing intake value!',
                                'You forgot to put some value in it.',
                                backgroundColor: Colors.white);
                          } else if (temp.trim() == '0' ||
                              temp.trim() == '00' ||
                              temp.trim() == '000' ||
                              temp.trim() == '0000') {
                            Navigator.pop(context);
                            Get.snackbar('Did you even drink?',
                                'Come on, be serious!',
                                backgroundColor: Colors.white);
                          } else {
                            var value = double.parse(temp);

                            homeController.computeWaterInTake(
                                passedInTake: value,
                                goalInTake: 2280,
                                timestamp: homeController.dateTimeRecord);

                            // Reset the value
                            homeController.intakeController.text = '';
                            Navigator.pop(context);
                          }
                        },
                        child: Text('OK'.toUpperCase()),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFFFFF),
                          backgroundColor:
                              const Color(0xFFEB5353), // foreground
                          padding: const EdgeInsets.all(15.0),
                          minimumSize: const Size.fromHeight(48),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'LexendDeca',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ))
            ]);
      });
}

showPopupDialogEdit(BuildContext context, Map<String, dynamic> map) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width - 16,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8.0),
                      Icon(
                        Icons.watch_later_outlined,
                        size: 50,
                      ),
                      sizedBox20(),
                      Material(
                        color: Colors.white,
                        child: Text(
                          'Did you forgot to logged your intake again?',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                            fontFamily: 'LexendDeca',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildTimeOption(context, homeController.intakeController,
                          onTimeChange: (time) {
                        homeController.setTimeRecord(time);
                      },
                          time:
                              DateTime.fromMillisecondsSinceEpoch(map['time'])),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          var temp = homeController.intakeController.text;

                          if (temp.trim().isEmpty) {
                            Get.snackbar('Missing intake value!',
                                'You forgot to put some value in it.');
                          } else {
                            var value = double.parse(temp);

                            homeController.updateComputationWaterInTake(
                                passedInTake: value,
                                goalInTake: 2280,
                                timestamp: homeController.dateTimeRecord,
                                id: map['id'],
                                pastIntake: map['intake']);

                            // Reset the value
                            homeController.intakeController.text = '';
                            Navigator.pop(context);
                          }
                        },
                        child: Text('OK'.toUpperCase()),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFFFFF),
                          backgroundColor:
                              const Color(0xFFEB5353), // foreground
                          padding: const EdgeInsets.all(15.0),
                          minimumSize: const Size.fromHeight(48),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'LexendDeca',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ))
            ]);
      });
}
