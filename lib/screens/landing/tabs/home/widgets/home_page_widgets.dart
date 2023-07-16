import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common/values/list.dart';
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
          child: reusableText(text: quote, textColor: Colors.white),
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
        backGroundColor: Colors.blue.shade400,
        margin: EdgeInsets.only(top: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 256,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: reusableText(
                text: quote, fontSize: 13.sp, textColor: Colors.white),
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
        return Container();
      }

      return Column(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

          homeController.setVariables(
              begin: double.parse(
                data['current_intake'].toString(),
              ),
              documentId: data['id']);
          return buildRowProgress(
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

Widget buildRowProgress({
  required double percent,
  required double begin,
  required double end,
  required double goal,
}) {
  return Container(
    margin: EdgeInsets.only(left: 10, right: 10),
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(1, 3), // changes position of shadow
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircularPercentIndicator(
          animateFromLastPercent: true,
          radius: 55.0,
          animation: true,
          animationDuration: 500,
          lineWidth: 10.0,
          percent: percent,
          center: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Countup(
                  begin: 0,
                  end: percent * 100,
                  duration: Duration(milliseconds: 500),
                  style: GoogleFonts.poppins(
                      color: Colors.blue,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.normal),
                ),
                reusableText(text: '%', textColor: Colors.blue, fontSize: 24.sp)
              ],
            ),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Colors.grey.shade300,
          progressColor: Colors.blue.shade600,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: reusableText(
                text: 'Today You Drank:',
                fontSize: 18,
              ),
            ),
            Container(
              child: Row(
                children: [
                  Countup(
                    begin: begin,
                    end: end,
                    duration: Duration(milliseconds: 500),
                    style: GoogleFonts.poppins(
                        color: AppColors.cardBgColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    child: reusableText(
                        text: 'ml',
                        fontSize: 15,
                        textColor: AppColors.cardBgColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: reusableText(
                text: 'Goal intake:',
                fontSize: 18,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  reusableText(
                      text: '2280ml',
                      fontSize: 15,
                      textColor: AppColors.cardBgColor),
                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
}

Widget buildFloatingActionButton(BuildContext context,
    {required ValueNotifier<bool> isDialOpen}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: SpeedDial(
      tooltip: 'Click me after drinking water!',
      icon: Icons.water_drop_outlined,
      activeIcon: Icons.water_drop,
      spacing: 2,
      mini: false,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 2,
      buttonSize: Size(56.0, 56.0),
      childrenButtonSize: Size(56.0, 56.0),
      visible: true,
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,
      closeManually: false,
      renderOverlay: true,
      overlayOpacity: 0.5,
      onOpen: () => debugPrint('OPENING DIAL'),
      onClose: () => debugPrint('DIAL CLOSED'),
      useRotationAnimation: true,
      heroTag: 'speed-dial-hero-tag',
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      children: [
        SpeedDialChild(
          child: Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                onTap: () {
                  showPopupDialogCups(context);
                },
                child: Container(
                  child: Stack(alignment: Alignment.center, children: [
                    Obx(
                      () => Container(
                        width: homeController.selectedCupPath ==
                                    'assets/icons/png/300ml.png' ||
                                homeController.selectedCupPath ==
                                    'assets/icons/png/500ml.png' ||
                                homeController.selectedCupPath ==
                                    'assets/icons/png/200ml.png'
                            ? 50.w
                            : 35.w,
                        height:
                            homeController.selectedCupPath ==
                                        'assets/icons/png/300ml.png' ||
                                    homeController.selectedCupPath ==
                                        'assets/icons/png/500ml.png' ||
                                    homeController.selectedCupPath ==
                                        'assets/icons/png/200ml.png'
                                ? 50.w
                                : 35.w,
                        child: Image.asset(homeController.selectedCupPath),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue[400],
                        child: Icon(
                          Icons.repeat_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                        maxRadius: 10,
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          label: 'Switch Cup',
          onTap: () => showPopupDialogCups(context),
        ),
        SpeedDialChild(
          child: Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                onTap: () {
                  homeController.setTimeRecord(DateTime.now());
                  homeController.computeWaterInTake(
                      passedInTake:
                          double.parse(homeController.selectedCupCapacity),
                      goalInTake: 2280,
                      timestamp: homeController.dateTimeRecord,
                      selectedCup: homeController.selectedCup);
                  isDialOpen.value = false;
                },
                child: Container(
                  // height: 120,
                  child: Stack(alignment: Alignment.center, children: [
                    Icon(
                      Icons.water_drop,
                      size: 50,
                      color: Colors.blue,
                    ),
                    Container(
                      child: Icon(
                        Icons.add,
                        size: 25,
                        weight: 50,
                        color: Colors.white,
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          label: 'Drink Water',
          onTap: () {
            homeController.setTimeRecord(DateTime.now());
            homeController.computeWaterInTake(
                passedInTake: double.parse(homeController.selectedCupCapacity),
                goalInTake: 2280,
                timestamp: homeController.dateTimeRecord,
                selectedCup: homeController.selectedCup);
            isDialOpen.value = false;
          },
          onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
        ),
      ],
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
        height: 70.h,
        child: TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.0,
          isFirst: isFirst!,
          isLast: isLast!,
          afterLineStyle: LineStyle(
            color: Colors.transparent,
            thickness: 3,
          ),
          beforeLineStyle: LineStyle(
            color: Colors.transparent,
            thickness: 3,
          ),
          indicatorStyle: IndicatorStyle(
            width: 30,
            height: 30,
            indicator: _indicatorIcon(assetName),
            indicatorXY: indicatorXY!,
            padding: EdgeInsets.only(
                right: 20.w, left: 20.h, top: topPadding!, bottom: 20.h),
          ),
          axis: TimelineAxis.vertical,
          endChild: Container(
            margin: EdgeInsets.only(right: 10.w, bottom: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                reusableText(
                  text: time,
                  fontSize: 13.sp,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      reusableText(
                        text: inTake,
                        fontSize: 13.sp,
                      ), // Intake Value String
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
  return Image.asset(assetName);
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
                  text: "Tracking Record",
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
            return Container();
          }

          return Column(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              String timeFormat = homeController.getTimeFormat(data['time']);

              return buildStartTimeline(
                assetName: cups[int.parse(data['type'])].path!,
                time: timeFormat,
                inTake:
                    '${data['intake'].toString().substring(0, data['intake'].toString().indexOf('.'))}ml',
                onSelected: homeController.setSelectedOption(),
                onTapDelete: () {
                  EasyLoading.show(
                    indicator: loadingStaggeredDots,
                    status: 'Retrieving data...',
                    maskType: EasyLoadingMaskType.clear,
                    dismissOnTap: false,
                  );
                  homeController.onTapDelete(data);
                  EasyLoading.dismiss();
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
          Stack(
            children: [
              SizedBox(
                width: 45,
                height: 45,
                child: Image.asset(homeController.selectedCupPath),
              ),
            ],
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
        return StatefulBuilder(builder: (context, setState) {
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
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0,
                              )),
                        ),
                        const SizedBox(height: 50),
                        buildTimeOption(
                            context, homeController.intakeController,
                            onTimeChange: (time) {
                          homeController.setTimeRecord(time);
                        }, time: DateTime.now()),
                        const SizedBox(height: 50),
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
                              Get.snackbar(
                                  'Did you even drink?', 'Come on, be serious!',
                                  backgroundColor: Colors.white);
                            } else {
                              var value = double.parse(temp);

                              homeController.computeWaterInTake(
                                  passedInTake: value,
                                  goalInTake: 2280,
                                  timestamp: homeController.dateTimeRecord,
                                  selectedCup: homeController.selectedCup);

                              // Reset the value
                              homeController.intakeController.text = '';
                              Navigator.pop(context);
                            }
                          },
                          child: Text('OK'.toUpperCase()),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFFFFFFFF),
                            backgroundColor:
                                AppColors.primaryElement, // foreground
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
      });
}

showPopupDialogEdit(BuildContext context, Map<String, dynamic> map) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
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
                            'Here to change your water intake?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        buildTimeOption(
                          context,
                          homeController.intakeController,
                          onTimeChange: (time) {
                            homeController.setTimeRecord(time);
                          },
                          time:
                              DateTime.fromMillisecondsSinceEpoch(map['time']),
                        ),
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
                                AppColors.primaryElement, // foreground
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
      });
}

showPopupDialogCups(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
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
                        Material(
                          color: Colors.white,
                          child: Text(
                            'Switch Cups',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        sizedBox20(),
                        GridView(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 130.0 / 110.0,
                            ),
                            children: List.generate(cups.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(
                                    () {
                                      homeController
                                          .setSelectedCup(cups[index]);
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: homeController.selectedCup == ''
                                          ? Colors.transparent
                                          : homeController.selectedCup ==
                                                  cups[index].id!
                                              ? Colors.grey[300]
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(cups[index].path!),
                                      ),
                                      sizedBox10(),
                                      reusableText(
                                        text: cups[index].type,
                                        textColor:
                                            homeController.selectedCup == ''
                                                ? AppColors.primary_bg
                                                : homeController.selectedCup ==
                                                        cups[index].id!
                                                    ? Colors.black
                                                    : AppColors.primary_bg,
                                        fontWeight:
                                            homeController.selectedCup == ''
                                                ? FontWeight.normal
                                                : homeController.selectedCup ==
                                                        cups[index].id!
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })),
                        sizedBox20(),
                      ],
                    ))
              ]);
        });
      });
}
