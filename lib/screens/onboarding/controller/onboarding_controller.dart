import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_reminder_app/common/models/user_model.dart';
import 'package:water_reminder_app/global.dart';
import 'package:water_reminder_app/screens/landing/landing_page.dart';

class OnboardingController extends GetxController {
  RxInt _activeStep = 0.obs;
  RxString _gender = '_ _'.obs;
  final RxInt _skipAttempt = 0.obs;
  RxInt _weight = 45.obs;
  RxString _unit = ''.obs;
  RxBool _isDefaultWeight = false.obs;
  RxBool _isDefaultWakeUpTime = false.obs;
  RxBool _isDefaultSleepTime = false.obs;
  RxString _wakeUpTimeString = '_ _'.obs;
  RxString _setSleepTime = '_ _'.obs;
  RxString _userId = ''.obs;
  RxString _deviceToken = ''.obs;

  get activeStep => _activeStep.value;
  get gender => _gender.value;
  get weight => _weight.value;
  get unit => _unit.value;
  get isDefaultWeight => _isDefaultWeight.value;
  get isDefaultWakeUpTime => _isDefaultWakeUpTime.value;
  get isDefaultSleepTime => _isDefaultSleepTime.value;
  get wakeUpTimeString => _wakeUpTimeString.value;
  get sleepTimeString => _setSleepTime.value;
  get userId => _userId.value;
  get deviceToken => _deviceToken.value;

  void setDefaultStep() {
    _activeStep.value = 0;
  }

  void setActiveStep(int index) {
    if (_gender.value != '_ _') {
      if (index > _activeStep.value) {
        if (_activeStep.value + 1 == index) {
          _activeStep.update((val) {
            _activeStep = RxInt(index);
          });
        } else {
          _activeStep.update((val) {
            _activeStep = RxInt(_activeStep.value + 1);
          });
        }
      } else if (index < _activeStep.value) {
        if (_activeStep.value - 1 == index) {
          _activeStep.update((val) {
            _activeStep = RxInt(_activeStep.value - 1);
          });
        } else {
          _activeStep.update((val) {
            _activeStep = RxInt(_activeStep.value - 1);
          });
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
        _activeStep.update((val) {
          _activeStep.value++;
        });
      } else {
        _anonymousRegistered();
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
      _activeStep.update((val) {
        _activeStep.value--;
      });
    }
  }

  void setGender(String key) {
    if (key == 'Male') {
      _gender.update((val) {
        _gender = RxString('Male');
      });
    } else {
      _gender.update((val) {
        _gender = RxString('Female');
      });
    }
  }

  void setWeight(int data) {
    _weight.update((val) {
      _weight = RxInt(data);
    });
  }

  void setUnit(String data) {
    _unit.update((val) {
      _unit = RxString(data);
    });
  }

  void increaseWeight() {
    _weight.value++;
  }

  void steadyWeight() {
    _weight.value;
  }

  void setWakeUpTime(String data) {
    _wakeUpTimeString.update((val) {
      _wakeUpTimeString = RxString(data);
    });
  }

  void setSleepTime(String data) {
    _setSleepTime.update((val) {
      _setSleepTime = RxString(data);
    });
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
          margin: EdgeInsets.only(left: 10.w),
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
          margin: EdgeInsets.only(left: 10.w),
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

  void _anonymousRegistered() async {
    // Create anonymous user in firebase sign-in
    String userId = await Global.storageService.anonymousSignIn();
    // Get Firebase Device Token
    final fCMToken = await Global.storageService.generateToken();

    // Convert data to user model
    if (userId.isNotEmpty) {
      UserModel model = UserModel();
      model.id = userId;
      model.device_token = fCMToken;
      model.user_id = userId;
      model.status = 'guest';
      model.gender = _gender.value;
      model.weight = _weight.value;
      model.wake_up_time = _wakeUpTimeString.value;
      model.sleep_time = _setSleepTime.value;

      // Call the function to register anonymous user to Firebase
      Global.storageService.registerAnonymousUser(model);

      // Save the unique anonymous id to sharedPref
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Stored it in a variable
      _userId.update((val) {
        _userId.value = userId;
      });
      _deviceToken.update((val) {
        _deviceToken.value = fCMToken;
      });

      // Stored it in shared pref
      await prefs.setString('user_id', userId);
      await prefs.setString('device_token', fCMToken);

      // Navigate to Landing Page
      Get.to(() => LandingPage());
    }
  }
}
