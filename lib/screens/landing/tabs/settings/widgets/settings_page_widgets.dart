import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/landing/tabs/settings/controller/settings_page_controller.dart';

final settingsController = Get.put(SettingsController());

showPopupDialogIntakeGoalSlider(
  BuildContext context, {
  required Function(int, dynamic, dynamic)? onDragging,
  required Function(int, dynamic, dynamic)? onDragCompleted,
}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, set) {
          return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          elevation: 0,
                          color: Colors.white,
                          child: Column(
                            children: [
                              reusableText(
                                text: 'Adjust intake goal',
                                fontSize: 14.0,
                                textColor: Colors.black,
                              ),
                              sizedBox30(),
                              _flutterSlide(
                                onDragging: onDragging,
                                onDragCompleted: onDragCompleted,
                              ),
                              reusableText(text: 'Recommended')
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ))
              ]);
        });
      });
}

Widget _flutterSlide(
    {Function(int, dynamic, dynamic)? onDragging,
    Function(int, dynamic, dynamic)? onDragCompleted}) {
  return Padding(
    padding: const EdgeInsets.only(left: 1.0),
    child: FlutterSlider(
      values: [settingsController.rating],
      max: 4500,
      min: 0,
      onDragging: onDragging,
      onDragCompleted: onDragCompleted,
      tooltip: FlutterSliderTooltip(
        format: (String value) {
          return '${double.parse(value).round().toString()}ml';
        },
        alwaysShowTooltip: true,
        textStyle:
            GoogleFonts.poppins(fontSize: 23, color: AppColors.primary_bg),
        disableAnimation: true,
        positionOffset: FlutterSliderTooltipPositionOffset(top: 10),
        boxStyle: FlutterSliderTooltipBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      step: FlutterSliderStep(step: 50),
      hatchMark: FlutterSliderHatchMark(
        density: 0.5, // means 50 lines, from 0 to 100 percent
        labels: [
          FlutterSliderHatchMarkLabel(
              percent: 50, label: Text('|', style: TextStyle(fontSize: 12))),
        ],
      ),
    ),
  );
}
