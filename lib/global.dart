import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder_app/common/services/firebase_api.dart';
import 'package:water_reminder_app/common/services/storage_service.dart';

class Global {
  static late StorageService storageService;

  // initialize the storage service along with the firebase
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: 'AIzaSyBCLOPxei9u2hN12x9mk2hG5xpdrMfj0WM',
      appId: '1:1043700851167:android:df5ed83bf3f1bfb92c646a',
      messagingSenderId: 'sendid',
      projectId: 'water-reminder-app-9f72e',
      storageBucket: 'water-reminder-app-9f72e.appspot.com',
    ));
    await FirebaseApi().initNotifications();
    // make it globally accessible
    storageService = await StorageService();
  }
}
