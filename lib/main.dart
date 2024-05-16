import 'dart:io';
import 'dart:ui';

import 'package:antam_monitoring/firebase_options.dart';
import 'package:antam_monitoring/home/homeMobileMaster.dart'
    if (dart.library.html) 'package:antam_monitoring/home/home.dart';
// import 'package:antam_monitoring/home_mobile/home_mobile.dart';
import 'package:antam_monitoring/login/login.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/tools/certHttpOveride.dart';
import 'package:antam_monitoring/tools/firebaseNotificaton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  HttpOverrides.global = DevHttpOverrides();
  GoogleFonts.config.allowRuntimeFetching = false;

  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // defaultUrl = await getDefaultUrl();

    // await FlutterDownloader.initialize(
    //     debug: true // optional: set false to disable printing logs to console
    //     );

    FirebaseMessaging.onMessage
        .listen((message) => showFlutterNotification(message));

    setupFlutterNotifications();
  }

  initializeDateFormatting('id_ID', null).then((_) => runApp(const MyApp()));

  // runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
        PointerDeviceKind.trackpad
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Antam Monitoring',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: MainStyle.primaryColor, // button text color
            ),
          ),
          colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: MainStyle.secondaryColor,
              onPrimary: MainStyle.primaryColor,
              secondary: MainStyle.primaryColor,
              onSecondary: MainStyle.secondaryColor,
              error: Colors.red,
              onError: Colors.red,
              background: Colors.white,
              onBackground: MainStyle.primaryColor,
              surface: Colors.white,
              onSurface: Colors.black)),
      // home: Login(),
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      initialRoute: "/tv",
      routes: {
        "/login": (context) => Login(),
        "/home": (context) => Home(),
        "/tv": (context) => Home(
              page: "tv",
            ),
      },
    );
  }
}
