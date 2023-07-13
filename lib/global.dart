import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder_app/common/services/firebase_api.dart';
import 'package:water_reminder_app/common/services/storage_service.dart';

class Global {
  static late StorageService storageService;

  // initialize the storage service along with the firebase
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseApi().initNotifications();
    // make it globally accessible
    storageService = await StorageService();
  }
}
