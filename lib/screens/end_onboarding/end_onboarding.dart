import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_reminder_app/common/values/colors.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/landing/landing_page.dart';
import 'package:water_reminder_app/screens/onboarding/controller/onboarding_controller.dart';
import 'package:water_reminder_app/screens/splash/widgets/splash_page_widgets.dart';

class EndOnboardingScreen extends StatefulWidget {
  const EndOnboardingScreen({super.key});

  static const route = '/end_onboarding_screen';

  @override
  State<EndOnboardingScreen> createState() => _EndOnboardingScreenState();
}

class _EndOnboardingScreenState extends State<EndOnboardingScreen> {
  final onboardingController = Get.put(OnboardingController());

  bool isShown = false;
  @override
  void initState() {
    _processOnboarding();
    super.initState();
  }

  _processOnboarding() async {
    await onboardingController.anonymousRegistered();
    Get.to(() => LandingPage());
  }

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
              child: buildImage('assets/icons/png/heart.png'),
            ),
            sizedBox30(),
            Text(
              'Thank you!',
              style: GoogleFonts.poppins(
                color: AppColors.primary_bg,
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Processing information...',
              style: GoogleFonts.poppins(
                color: AppColors.primary_bg,
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            sizedBox20(),
            Text(
              'Hold-on while I setup your profile.',
              style: GoogleFonts.poppins(
                color: AppColors.primarySecondaryElementText,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            sizedBox20(),
            // isShown
            //     ? buildButton('GO TO DASHBOARD', () {

            //       })
            //     : Container(),
          ],
        ),
      ),
    );
  }
}
