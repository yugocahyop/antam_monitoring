import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  // message.data["title"];

  // if (kDebugMode) {
  //   print(message.data);
  // }
  // final eMsg = MyNotification.msgs.where(
  //   (element) => element == message.notification!.body,
  // );

  // if (eMsg.isEmpty) {
  //   MyNotification.msgs.add(message.notification!.body!);
  showFlutterNotification(message);
  // }

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications

class MyNotification {
  static Function(String TECHIDENTNO, int datetime)? showNotif;
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  static AndroidNotificationChannel? channel;
  static BuildContext? iosContext;
  static List<String> msgs = [];

  static bool isFlutterLocalNotificationsInitialized = false;
}

@pragma('vm:entry-point')
Future<void> notificationTapForeground(
    NotificationResponse notificationResponse) async {
  // handle action
  if (kDebugMode) {
    print("tapped");
  }
  if (notificationResponse.payload != null) {
    if (kDebugMode) {
      print("tapped ${notificationResponse.payload}");
    }

    try {
      if (notificationResponse.payload!.contains("/")) {
        while (MyNotification.iosContext == null) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
        // String? path = await FilesystemPicker.open(
        //     fileTileSelectMode: FileTileSelectMode.wholeTile,
        //     fsType: FilesystemType.file,
        //     context: MyNotification.iosContext!,
        //     rootDirectory: Directory(notificationResponse.payload!));
        // OpenFile.open(path ?? "");

        return;
      }
    } catch (err) {
      if (kDebugMode) {
        print(" ${err}");
      }
    }

    try {
      Map<String, dynamic> data = jsonDecode(notificationResponse.payload!);

      while (MyNotification.showNotif == null) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (kDebugMode) {
        print("tapped show notif");
      }
      MyNotification.showNotif!(
          data["TECHIDENTNO"], int.tryParse(data["dateTime"]) ?? 0);
    } catch (e) {
      if (kDebugMode) {
        print(" ${e}");
      }
    }
  }
}

void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  showDialog(
    context: MyNotification.iosContext!,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title ?? ""),
      content: Text(body ?? ""),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: () async {
            if (payload != null) {
              // OpenFile.open(payload);
            }
          },
        )
      ],
    ),
  );
}

Future<void> setupFlutterNotifications() async {
  if (MyNotification.isFlutterLocalNotificationsInitialized) {
    return;
  }

  MyNotification.channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  MyNotification.flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await MyNotification.flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(MyNotification.channel!);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'Open notification');
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux);

  MyNotification.flutterLocalNotificationsPlugin!.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: notificationTapForeground,
    onDidReceiveBackgroundNotificationResponse: notificationTapForeground,
  );

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  MyNotification.isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  // savePayload(message.data.toString());
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    MyNotification.flutterLocalNotificationsPlugin!.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            MyNotification.channel!.id,
            MyNotification.channel!.name,
            channelDescription: MyNotification.channel!.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            // icon: 'launch_background',
          ),
        ),
        payload: jsonEncode(message.data));
  }
}
