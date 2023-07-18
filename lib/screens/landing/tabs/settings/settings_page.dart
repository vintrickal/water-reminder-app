import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/landing/tabs/settings/controller/settings_page_controller.dart';
import 'package:water_reminder_app/screens/landing/tabs/settings/widgets/settings_page_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final settingsController = Get.put(SettingsController());

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  _initializeData() {
    settingsController.initializedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBG,
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(left: 16, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBox20(),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  reusableText(
                    text: 'Reminder settings',
                    textColor: AppColors.primarySecondaryElementText,
                    fontSize: 14,
                  ),
                  reusableText(
                      text: '*All changes are auto saved',
                      textColor: Colors.red,
                      fontSize: 10)
                ],
              ),
            ),
            sizedBox10(),
            Container(
              width: 150,
              child: Divider(
                height: 1,
              ),
            ),
            sizedBox30(),
            reusableText(
              text: 'Reminder schedule',
              textColor: Colors.black,
              fontSize: 12,
            ),
            sizedBox30(),
            reusableText(
              text: 'Reminder sound',
              textColor: Colors.black,
              fontSize: 12,
            ),
            sizedBox30(),
            reusableText(
              text: 'General',
              textColor: AppColors.primarySecondaryElementText,
              fontSize: 14,
            ),
            sizedBox10(),
            Container(
              width: 150,
              child: Divider(
                height: 1,
              ),
            ),
            sizedBox30(),
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  reusableText(
                    text: 'Light or Dark mode',
                    textColor: Colors.black,
                    fontSize: 12,
                  ),
                  reusableText(
                      text: 'Default',
                      textColor: Colors.blue[400]!,
                      fontWeight: FontWeight.bold)
                ],
              ),
            ),
            sizedBox30(),
            InkWell(
              onTap: () {
                showPopupDialogIntakeGoalSlider(context,
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                  settingsController.setGoalIntake(lowerValue);
                }, onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                  settingsController.updateIntakeGoal();
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    reusableText(
                      text: 'Intake goal',
                      textColor: Colors.black,
                      fontSize: 12,
                    ),
                    Obx(
                      () => reusableText(
                          text:
                              '${settingsController.rating.round().toString()}ml',
                          textColor: Colors.blue[400]!,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            sizedBox30(),
            reusableText(
              text: 'Personal Information',
              textColor: AppColors.primarySecondaryElementText,
              fontSize: 14,
            ),
            sizedBox10(),
            Container(
              width: 150,
              child: Divider(
                height: 1,
              ),
            ),
            sizedBox30(),
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  reusableText(
                    text: 'Gender',
                    textColor: Colors.black,
                    fontSize: 12,
                  ),
                  reusableText(
                      text: 'Male',
                      textColor: Colors.blue[400]!,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ),
            sizedBox30(),
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  reusableText(
                    text: 'Weight',
                    textColor: Colors.black,
                    fontSize: 12,
                  ),
                  reusableText(
                      text: '45 kg',
                      textColor: Colors.blue[400]!,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ),
            sizedBox30(),
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  reusableText(
                    text: 'Wake-up time',
                    textColor: Colors.black,
                    fontSize: 12,
                  ),
                  reusableText(
                      text: '06:00 AM',
                      textColor: Colors.blue[400]!,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ),
            sizedBox30(),
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  reusableText(
                    text: 'Bedtime',
                    textColor: Colors.black,
                    fontSize: 12,
                  ),
                  reusableText(
                      text: '10:00 PM',
                      textColor: Colors.blue[400]!,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ),
            sizedBox30(),
            reusableText(
              text: 'Other',
              textColor: AppColors.primarySecondaryElementText,
              fontSize: 14,
            ),
            sizedBox10(),
            Container(
              width: 150,
              child: Divider(
                height: 1,
              ),
            ),
            sizedBox30(),
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  reusableText(
                    text: 'Hide tips',
                    textColor: Colors.black,
                    fontSize: 12,
                  ),
                  ToggleSwitch(
                    minWidth: 50.0,
                    cornerRadius: 10.0,
                    activeBgColors: [
                      [Colors.cyan],
                      [Colors.redAccent]
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    initialLabelIndex: 1,
                    totalSwitches: 2,
                    labels: ['Yes', 'No'],
                    radiusStyle: true,
                    onToggle: (index) {
                      print('switched to: $index');
                    },
                  ),
                ],
              ),
            ),
            sizedBox30(),
            reusableText(
              text: 'Reset Data',
              textColor: Colors.black,
              fontSize: 12,
            ),
            sizedBox30(),
            reusableText(
              text: 'Feedback',
              textColor: Colors.black,
              fontSize: 12,
            ),
            sizedBox30(),
            reusableText(
              text: 'Privacy Policy',
              textColor: Colors.black,
              fontSize: 12,
            ),
          ],
        ),
      )),
    );
  }
}
