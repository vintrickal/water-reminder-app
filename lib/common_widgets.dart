import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:water_reminder_app/common/values/colors.dart';

Widget reusableText({
  String? text,
  Color textColor = AppColors.primary_bg,
  double fontSize = 12,
  FontWeight? fontWeight = FontWeight.normal,
}) {
  return Text(text!,
      style: GoogleFonts.poppins(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ));
}

// SizedBox
Widget sizedBox10() {
  return SizedBox(
    height: 10,
  );
}

Widget sizedBox20() {
  return SizedBox(
    height: 20,
  );
}

Widget sizedBox30() {
  return SizedBox(
    height: 30,
  );
}

var fourRotatingDots = LoadingAnimationWidget.fourRotatingDots(
    color: AppColors.primaryElement, size: 50);

var progressiveDots = LoadingAnimationWidget.prograssiveDots(
    color: AppColors.primaryElement, size: 50);

var staggeredDotsWave = LoadingAnimationWidget.staggeredDotsWave(
    color: AppColors.primaryElement, size: 50);

var loadingfourRotatingDots = Container(
  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
  child: Align(
    alignment: Alignment.center,
    child: fourRotatingDots,
  ),
);

var loadingprogressiveDots = Container(
  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
  child: Align(
    alignment: Alignment.center,
    child: progressiveDots,
  ),
);

var loadingStaggeredDots = Container(
  // padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
  child: Align(
    alignment: Alignment.center,
    child: staggeredDotsWave,
  ),
);
