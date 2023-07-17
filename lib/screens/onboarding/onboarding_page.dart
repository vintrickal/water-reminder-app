import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/main_controller.dart';
import 'package:water_reminder_app/screens/onboarding/controller/onboarding_controller.dart';
import 'package:water_reminder_app/screens/onboarding/widgets/onboarding_page_widgets.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final onboardingController = Get.put(OnboardingController());
  final MainController mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => Column(
          children: [
            easyStepper(
              activeStep: int.parse(onboardingController.activeStep.toString()),
              steps: [
                easyStep(
                    svgAsset: 'assets/icons/svg/gender_vector.svg',
                    text: onboardingController.gender),
                easyStep(
                  svgAsset: 'assets/icons/svg/weighing_scale_vector.svg',
                  text: onboardingController.weight - 1 == 44
                      ? onboardingController.isDefaultWeight
                          ? '${onboardingController.weight.toString()}kg'
                          : '_ _'
                      : '${onboardingController.weight.toString()}kg',
                ),
                easyStep(
                    svgAsset: 'assets/icons/svg/alarm_clock_vector.svg',
                    text: onboardingController.wakeUpTimeString),
                easyStep(
                  svgAsset: 'assets/icons/svg/moon_vector.svg',
                  text: onboardingController.sleepTimeString,
                ),
              ],
              onStepReached: (index) =>
                  onboardingController.setActiveStep(index),
            ),
            int.parse(onboardingController.activeStep.toString()) == 0
                ? buildGenderOption(
                    gender: onboardingController.gender,
                    onTapMale: () => onboardingController.setGender('Male'),
                    onTapFemale: () => onboardingController.setGender('Female'),
                    maleStateColor: onboardingController.gender == 'Male'
                        ? Colors.blue
                        : Colors.grey,
                    femaleStateColor: onboardingController.gender == 'Female'
                        ? Colors.blue
                        : Colors.grey,
                  )
                : Container(), // First
            int.parse(onboardingController.activeStep.toString()) == 1
                ? buildWeightOption(
                    onValueChangedWeight: (weight) {
                      onboardingController.setWeight(weight);
                    },
                    onValueChangedUnit: (unit) {
                      onboardingController.setUnit(unit);
                    },
                    initValue: onboardingController.weight,
                  )
                : Container(), // Second
            int.parse(onboardingController.activeStep.toString()) == 2
                ? buildWakeUpTimeOption(context, onTimeChange: (time) {
                    var dateFormat =
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    onboardingController.setWakeUpTime(dateFormat);
                  })
                : Container(), //Third
            int.parse(onboardingController.activeStep.toString()) == 3
                ? buildBedTimeOption(context, onTimeChange: (time) {
                    var dateFormat =
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    onboardingController.setSleepTime(dateFormat);
                  })
                : Container(), // Fourth
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationOptions(onTap: () {
        onboardingController.decreaseActiveStep();
      }, func: () {
        onboardingController.increaseActiveStep();
      }),
    );
  }
// }
}
