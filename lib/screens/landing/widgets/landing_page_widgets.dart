import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/landing/controller/landing_controller.dart';

final LandingController landingController = Get.find();

Widget buildAppBarTabBar(
    {required List<Widget> tabs,
    void Function(int)? onTap,
    TabController? controller}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.blue,
    bottom: TabBar(
      controller: controller,
      indicator: BubbleTabIndicator(
        indicatorRadius: 5,
        indicatorHeight: 30.0,
        indicatorColor: Colors.blue[700]!,
      ),
      tabs: tabs,
    ),
  );
}

Widget tabPlaceholder({
  required String assetName,
  required String text,
  required int position,
  // required Color iconColor,
  // required Color textColor
}) {
  return Tab(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: Image.asset(
            assetName,
            color: Colors.white,
          ),
        ),
        reusableText(
            text: text, textColor: Colors.white, fontWeight: FontWeight.bold),
      ],
    ),
  );
}
