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
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            // sizedBox10(),
            Text(
              'Onboarding Complete.',
              style: GoogleFonts.poppins(
                color: AppColors.primary_bg,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            sizedBox20(),
            Obx(
              () => reusableText(
                  text: onboardingController.recommendedWaterIntake == 0
                      ? 'Calculating the water goal intake...'
                      : 'Your water goal intake is ${onboardingController.recommendedWaterIntake.toString()}ml',
                  fontSize: 16),
            ),
            sizedBox20(),
            Obx(
              () => buildButton(
                onboardingController.recommendedWaterIntake == 0
                    ? 'Processing'
                    : 'Proceed',
                () {
                  if (onboardingController.recommendedWaterIntake != 0) {
                    Future.delayed(Duration(seconds: 5));
                    Get.to(() => LandingPage());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
