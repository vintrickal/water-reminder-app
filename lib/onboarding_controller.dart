import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingControllerGetX extends GetxController {
  RxInt _activeStep = 0.obs;
  RxString _gender = '_ _'.obs;
  final RxInt _skipAttempt = 0.obs;
  RxInt _weight = 45.obs;
  RxString _unit = ''.obs;
  RxBool _isDefaultWeight = false.obs;
  RxBool _isDefaultWakeUpTime = false.obs;
  RxBool _isDefaultSleepTime = false.obs;
  RxString _wakeUpTimeString = '_ _'.obs;
  RxString _sleepTimeString = '_ _'.obs;

  get activeStep => _activeStep.value;
  get gender => _gender.value;
  get weight => _weight.value;
  get unit => _unit.value;
  get isDefaultWeight => _isDefaultWeight.value;
  get isDefaultWakeUpTime => _isDefaultWakeUpTime.value;
  get isDefaultSleepTime => _isDefaultSleepTime.value;
  get wakeUpTimeString => _wakeUpTimeString.value;
  get sleepTimeString => _sleepTimeString.value;

  void setDefaultStep() {
    _activeStep.value = 0;
  }

  void setActiveStep(int index) {
    if (_gender.value != '_ _') {
      if (index > _activeStep.value) {
        if (_activeStep.value + 1 == index) {
          _activeStep = RxInt(index);
        } else {
          _activeStep = RxInt(_activeStep.value + 1);
        }
      } else if (index < _activeStep.value) {
        if (_activeStep.value - 1 == index) {
          _activeStep = RxInt(_activeStep.value - 1);
        } else {
          _activeStep = RxInt(_activeStep.value - 1);
        }
      } else {
        _activeStep;
      }
    } else {
      _skipAttempt.value++;
      if (_skipAttempt.value > 2) {
        _skipAttemptSnackBar();
        _skipAttempt.value = 0;
      } else {
        _snackBar();
      }
    }

    if (_gender.value != '_ _') {
      if (_weight.value == 45) {
        _isDefaultWeight.value = true;
      }
    }
  }

  void increaseActiveStep() {
    if (_gender.value != '_ _') {
      if (_activeStep.value < 3) {
        _activeStep.value++;
      } else {
        _appreciationSnackBar();
      }
    } else {
      _skipAttempt.value++;
      if (_skipAttempt.value > 2) {
        _skipAttemptSnackBar();
        _skipAttempt.value = 0;
      } else {
        _snackBar();
      }
    }

    if (_gender.value != '_ _') {
      if (_weight.value == 45) {
        _isDefaultWeight.value = true;
      }
    }
  }

  void decreaseActiveStep() {
    if (_activeStep.value > 0) {
      _activeStep.value--;
    }
  }

  void setGender(String key) {
    if (key == 'Male') {
      _gender = RxString('Male');
    } else {
      _gender = RxString('Female');
    }
  }

  void setWeight(int data) {
    _weight = RxInt(data);
  }

  void setUnit(String data) {
    _unit = RxString(data);
  }

  void increaseWeight() {
    _weight.value++;
  }

  void steadyWeight() {
    _weight.value;
  }

  void setWakeUpTime(String data) {
    _wakeUpTimeString = RxString(data);
  }

  void setSleepTime(String data) {
    _sleepTimeString = RxString(data);
  }

  SnackbarController _snackBar() {
    return Get.snackbar("You don't have a gender?", "I need the information",
        icon: Image.asset(
          'assets/icons/png/confuse.png',
        ),
        isDismissible: true,
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2));
  }

  SnackbarController _skipAttemptSnackBar() {
    return Get.snackbar("Why are you skipping?", "I'm sad now",
        icon: Container(
          margin: EdgeInsets.only(left: 10),
          child: Image.asset(
            'assets/icons/png/sad.png',
          ),
        ),
        isDismissible: true,
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2));
  }

  SnackbarController _appreciationSnackBar() {
    return Get.snackbar("Thank you!", "It's still a work in progress!",
        icon: Container(
          margin: EdgeInsets.only(left: 10),
          child: Image.asset(
            'assets/icons/png/heart.png',
          ),
        ),
        isDismissible: true,
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2));
  }
}
