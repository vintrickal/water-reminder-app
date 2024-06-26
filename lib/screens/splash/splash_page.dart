import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: buildImage('assets/icons/png/water_happy.png'),
            ),
            sizedBox30(),
            Text(
              'Hi,',
              style: GoogleFonts.poppins(
                color: AppColors.primary_bg,
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'I\'m your personal hydration buddy',
              style: GoogleFonts.poppins(
                color: AppColors.primary_bg,
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            sizedBox20(),
            Text(
              'In order to provide hydration advice. I need to know some basic information. Don\'t worry, I\'m good with secrets',
              style: GoogleFonts.poppins(
                color: AppColors.primarySecondaryElementText,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
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
