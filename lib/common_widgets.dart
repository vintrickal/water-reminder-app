import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:water_reminder_app/common/values/colors.dart';

Widget reusableText({
  String? text,
  Color textColor = AppColors.primary_bg,
  double fontSize = 12,
  FontWeight? fontWeight = FontWeight.normal,
}) {
  return Text(
    text!,
    style:
        TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight),
  );
}

// SizedBox
Widget sizedBox10() {
  return SizedBox(
    height: 10.h,
  );
}

Widget sizedBox20() {
  return SizedBox(
    height: 20.h,
  );
}

Widget sizedBox30() {
  return SizedBox(
    height: 30.h,
  );
}

var fourRotatingDots = LoadingAnimationWidget.fourRotatingDots(
    color: AppColors.primaryElement, size: 50);

var progressiveDots = LoadingAnimationWidget.prograssiveDots(
    color: AppColors.primaryElement, size: 50);

var loadingfourRotatingDots = Container(
  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
  child: Align(
    alignment: Alignment.center,
    child: progressiveDots,
  ),
);

var loadingprogressiveDots = Container(
  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
  child: Align(
    alignment: Alignment.center,
    child: progressiveDots,
  ),
);
