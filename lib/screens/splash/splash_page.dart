import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/onboarding/onboarding_page.dart';
import 'package:water_reminder_app/screens/splash/widgets/splash_page_widgets.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const route = '/splash_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: buildImage('assets/icons/png/water_happy.png'),
            ),
            sizedBox30(),
            reusableText(text: 'Hi,', fontSize: 24),
            reusableText(
              text: 'I\'m your personal hydration buddy',
              fontSize: 24,
            ),
            sizedBox20(),
            reusableText(
                text:
                    'In order to provide hydration advice. I need to know some basic information. Don\'t worry, I\'m good with secrets',
                textColor: AppColors.primarySecondaryElementText,
                fontSize: 14),
            sizedBox20(),
            buildButton('START HYDRATING', () {
              Get.to(() => OnboardingPage());
            }),
          ],
        ),
      ),
    );
  }
}
