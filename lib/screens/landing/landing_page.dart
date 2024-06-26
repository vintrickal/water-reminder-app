// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:water_reminder_app/screens/landing/tabs/history/history_page.dart';
import 'package:water_reminder_app/screens/landing/tabs/home/home_page.dart';
import 'package:water_reminder_app/screens/landing/tabs/settings/settings_page.dart';
import 'package:water_reminder_app/screens/landing/widgets/landing_page_widgets.dart';

class LandingPage extends StatelessWidget {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: tabIndex,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: buildAppBarTabBar(
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
