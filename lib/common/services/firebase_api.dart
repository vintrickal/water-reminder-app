import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:water_reminder_app/screens/landing/controller/landing_controller.dart';
import 'package:water_reminder_app/screens/landing/landing_page.dart';
import 'package:timezone/data/latest_all.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('Title: ${message.notification?.title}');
//   print('Body: ${message.notification?.body}');
//   print('Payload: ${message.data}');
// }

class FirebaseApi {
  // Firebase instances
  // final _firebaseMessaging = FirebaseMessaging.instance;

  // GetX Controller
  final landingController = Get.put(LandingController());

  // Local Notifcation Setup
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notification.',
    importance: Importance.defaultImportance,
  );

  // Local Notification Initialization
  final _localNotifications = FlutterLocalNotificationsPlugin();

  // void handleMessage(RemoteMessage? message) {
  //   if (message == null) return;

  //   // landingController.setTabPosition(0);
  //   // Get.to(() => LandingPage(), arguments: {'index': 0});
  //   Get.to(() => LandingPage());
  // }

  // Future initPushNotifications() async {
  //   /// Update the iOS foreground notification presentation options to allow
  //   /// heads up notifications.
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

  //   //Opened from terminated state [Firebase Cloud Messaging notifcation]
  //   FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

  //   //Opened from a background state
  //   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

  //   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  //   // While app is in an opened state
  //   FirebaseMessaging.onMessage.listen((message) {
  //     final notification = message.notification;
  //     if (notification == null) return;

  //     _localNotifications.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           _androidChannel.id,
  //           _androidChannel.name,
  //           channelDescription: _androidChannel.description,
  //           icon: '@mipmap/ic_launcher',
  //         ),
  //       ),
  //       payload: jsonEncode(message.toMap()),
  //     );
  //   });
  // }

  Future initLocalNotifications() async {
    // const iOS = DarwinInitializationSettings();
    // const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // const settings = InitializationSettings(android: android, iOS: iOS);

    // await _localNotifications.initialize(
    //   settings,
    //   onDidReceiveNotificationResponse: (payload) {
    //     final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
    //     handleMessage(message);
    //   },
    // );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  // FIND WAYS TO STORE THE GENERATED DEVICE TOKEN AND STORED IT
  // ALONG WITH THE USER DATA
  // ALSO, CREATE A FUNCTION TO CALL SCHEDULENOTIFICATION WHEN
  // USER INTAKE A WATER
  // PS: FIND A METHOD TO CANCEL THE SCHEDULE NOTIFICATION WHEN
  // USER INTAKE WATER AHEAD OF THE SCHEDULED NOTIFICATION
  scheduleNotification() async {
    timezone.initializeTimeZones();
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notification.',
      importance: Importance.defaultImportance,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _localNotifications.zonedSchedule(
        123,
        "notification title",
        'Message goes here',
        timezone.TZDateTime.now(timezone.local)
            .add(const Duration(seconds: 10)),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  periodicallyShow() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notification.',
      importance: Importance.defaultImportance,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifications.periodicallyShow(
        0,
        'Stay Hydrated!',
        "Don't forget to drink your water!",
        RepeatInterval.hourly,
        platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  Future<void> initNotifications() async {
    // await _firebaseMessaging.requestPermission();
    // final fCMToken = await _firebaseMessaging.getToken();
    // print('Token: $fCMToken');
    // initPushNotifications();
    initLocalNotifications();
    // scheduleNotification();
    periodicallyShow();
  }
}
