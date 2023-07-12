import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/common_widgets.dart';
import 'package:water_reminder_app/screens/landing/controller/landing_controller.dart';

final LandingController landingController = Get.find();

Widget buildAppBarLandingPage(
    {required List<Widget> tabs,
    void Function(int)? onTap,
    TabController? controller}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.blue,
    bottom: TabBar(
      controller: controller,
      labelColor: Colors.white,
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      unselectedLabelColor: Colors.grey,
      tabs: tabs,
      onTap: onTap,
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
          width: 18.w,
          height: 18.h,
          child: Obx(
            () => Image.asset(
              assetName,
              color: landingController.tabPosition == position
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
        Obx(
          () => reusableText(
              text: text,
              textColor: landingController.tabPosition == position
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}
