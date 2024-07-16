import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/onboarding/controller/onboarding_controller.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

final onboardingController = Get.put(OnboardingController());

Widget buildNextButton(String buttonName, void Function()? func) {
  return InkWell(
    onTap: func,
    child: Container(
      width: 75,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primaryFourthElementText),
          boxShadow: [
            BoxShadow(
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
                color: Colors.grey.withOpacity(0.1))
          ]),
      child: Center(
          child: Text(
        buttonName,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.primaryBackground),
      )),
    ),
  );
}

EasyStep easyStep({String? svgAsset, String? text}) {
  return EasyStep(
    customStep: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Opacity(
        opacity: 1,
        child: Container(
          width: 40,
          height: 40,
          child: SvgPicture.asset(
            svgAsset!,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    ),
    customTitle: Text(
      text ?? '_ _',
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary_bg,
          fontSize: 16),
      textAlign: TextAlign.center,
    ),
  );
}

Widget easyStepper({
  int activeStep = 0,
  List<EasyStep>? steps,
  void Function(int)? onStepReached,
}) {
  return SizedBox(
    height: 170,
    child: EasyStepper(
      activeStep: activeStep,
      lineStyle: LineStyle(
        lineLength: 30,
        lineSpace: 3,
        defaultLineColor: Colors.blue.shade500,
      ),
      stepShape: StepShape.rRectangle,
      stepBorderRadius: 15,
      borderThickness: 2,
      padding: const EdgeInsets.symmetric(vertical: 50),
      stepRadius: 30,
      unreachedStepBackgroundColor: Colors.grey.shade400,
      finishedStepBorderColor: Colors.blue,
      finishedStepTextColor: Colors.blue,
      finishedStepBackgroundColor: Colors.blue,
      activeStepIconColor: Colors.blue,
      activeStepBackgroundColor: Colors.blue,
      activeStepBorderColor: Colors.yellowAccent,
      showLoadingAnimation: false,
      defaultStepBorderType: BorderType.normal,
      steps: steps!,
      onStepReached: onStepReached,
    ),
  );
}

Widget avatarContainer({String? imageAsset, Color? stateColor}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: stateColor,
    ),
    width: 100,
    height: 100,
    child: Image.asset(imageAsset!),
  );
}

Widget icon({String? imageAsset}) {
  return SizedBox(
    width: 150,
    height: 180,
    child: Image.asset(imageAsset!),
  );
}

Widget iconMoon({String? imageAsset}) {
  return SizedBox(
    width: 120,
    height: 150,
    child: Image.asset(imageAsset!),
  );
}

Widget bottomNavigationOptions(
    {void Function()? onTap, void Function()? func}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.arrow_left_sharp,
                color: Colors.white,
                size: 40,
              )),
        ),
        buildNextButton('NEXT', func),
      ],
    ),
  );
}

Widget buildGenderOption({
  String? gender,
  void Function()? onTapMale,
  void Function()? onTapFemale,
  Color? maleStateColor,
  Color? femaleStateColor,
}) {
  return Column(
    children: [
      reusableText(
          text: 'Your Gender',
          fontSize: 24,
          textColor: AppColors.primaryText,
          fontWeight: FontWeight.bold),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Row(
          children: [
            icon(imageAsset: 'assets/icons/png/gender_sign.png'),
            Column(
              children: [
                GestureDetector(
                  onTap: onTapMale,
                  child: avatarContainer(
                      imageAsset: gender == 'Male'
                          ? 'assets/icons/png/male_avatar_open_eyes.png'
                          : 'assets/icons/png/male_avatar_uwu.png',
                      stateColor: maleStateColor),
                ),
                sizedBox20(),
                GestureDetector(
                  onTap: onTapFemale,
                  child: avatarContainer(
                      imageAsset: gender == 'Female'
                          ? 'assets/icons/png/female_avatar_open_eyes.png'
                          : 'assets/icons/png/female_avatar_uwu.png',
                      stateColor: femaleStateColor),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildWeightOption(
    {dynamic Function(dynamic)? onValueChangedWeight,
    dynamic Function(dynamic)? onValueChangedUnit,
    int? initValue}) {
  return Column(
    children: [
      reusableText(
          text: 'Your Weight',
          fontSize: 24,
          textColor: AppColors.primaryText,
          fontWeight: FontWeight.bold),
      sizedBox30(),
      Container(
          width: 355,
          child: Stack(
            children: [
              Image.asset('assets/icons/png/customize_weighing_scale.png'),
              Positioned(
                top: -22,
                left: 129,
                child: SizedBox(
                  width: 100,
                  height: 200,
                  child: WheelChooser.integer(
                    initValue: initValue,
                    selectTextStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    unSelectTextStyle:
                        TextStyle(fontSize: 15, color: Colors.grey.shade500),
                    onValueChanged: onValueChangedWeight,
                    maxValue: 500,
                    minValue: 30,
                    step: 1,
                    horizontal: true,
                  ),
                ),
              ),
            ],
          ))
    ],
  );
}

Widget buildWakeUpTimeOption(BuildContext context,
    {void Function(DateTime)? onTimeChange}) {
  return Column(
    children: [
      Align(
        alignment: AlignmentDirectional.topCenter,
        child: reusableText(
            text: 'Wake-up time',
            fontSize: 24,
            textColor: AppColors.primaryText,
            fontWeight: FontWeight.bold),
      ),
      sizedBox30(),
      Container(
        width: 320,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image.asset('assets/icons/png/alarm_clock_with_sun.png'),
            Positioned(
              top: 72,
              bottom: 0,
              left: 30,
              right: 10,
              child: TimePickerSpinner(
                time: DateTime.now(),
                is24HourMode: true,
                normalTextStyle:
                    const TextStyle(fontSize: 23, color: Colors.transparent),
                highlightedTextStyle: const TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                spacing: 50,
                itemHeight: 80,
                isForce2Digits: true,
                onTimeChange: onTimeChange,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildBedTimeOption(BuildContext context,
    {void Function(DateTime)? onTimeChange}) {
  return Column(
    children: [
      Align(
        alignment: Alignment.topCenter,
        child: reusableText(
            text: 'Bedtime',
            fontSize: 24,
            textColor: AppColors.primaryText,
            fontWeight: FontWeight.bold),
      ),
      sizedBox30(),
      Container(
        width: 320,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image.asset('assets/icons/png/alarm_clock_with_sleeping_sun.png'),
            Positioned(
              top: 72,
              bottom: 0,
              left: 30,
              right: 10,
              child: TimePickerSpinner(
                time: DateTime.now(),
                is24HourMode: true,
                normalTextStyle:
                    const TextStyle(fontSize: 23, color: Colors.transparent),
                highlightedTextStyle: const TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                spacing: 50,
                itemHeight: 80,
                isForce2Digits: true,
                onTimeChange: onTimeChange,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
