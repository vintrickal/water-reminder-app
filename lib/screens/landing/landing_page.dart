import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/screens/landing/controller/landing_controller.dart';
import 'package:water_reminder_app/screens/landing/tabs/history/history_page.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/home_page.dart';
import 'package:water_reminder_app/screens/landing/tabs/settings/settings_page.dart';
import 'package:water_reminder_app/screens/landing/widgets/landing_page_widgets.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final landingController = Get.put(LandingController());
  var tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> data =
        (ModalRoute.of(context)!.settings.arguments ?? {}) as Map;

    if (data.isEmpty) {
      tabIndex = 0;
    } else {
      tabIndex = data['index'];
    }

    return DefaultTabController(
      length: 3,
      initialIndex: tabIndex,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: buildAppBarLandingPage(
            tabs: [
              tabPlaceholder(
                assetName: 'assets/icons/png/home.png',
                text: 'Home',
                position: 0,
              ),
              tabPlaceholder(
                assetName: 'assets/icons/png/history.png',
                text: 'History',
                position: 1,
              ),
              tabPlaceholder(
                assetName: 'assets/icons/png/settings.png',
                text: 'Settings',
                position: 2,
              ),
            ],
            onTap: (value) async {
              landingController.setTabPosition(value);
            },
          ),
        ),
        body: TabBarView(children: [
          HomePage(),
          HistoryPage(),
          SettingsPage(),
        ]),
      ),
    );
  }
}
