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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              await landingController.setTabPosition(value);
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
