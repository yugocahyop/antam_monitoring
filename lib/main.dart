import 'dart:io';
import 'dart:ui';

import 'package:antam_monitoring/home/home.dart';
// import 'package:antam_monitoring/home_mobile/home_mobile.dart';
import 'package:antam_monitoring/login/login.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/tools/certHttpOveride.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  HttpOverrides.global = DevHttpOverrides();
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());
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
          colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: MainStyle.secondaryColor,
              onPrimary: MainStyle.secondaryColor,
              secondary: MainStyle.secondaryColor,
              onSecondary: MainStyle.secondaryColor,
              error: Colors.red,
              onError: Colors.red,
              background: MainStyle.secondaryColor,
              onBackground: MainStyle.secondaryColor,
              surface: Colors.white,
              onSurface: Colors.black)),
      // home: Login(),
      initialRoute: "/login",
      routes: {
        "/login": (context) => Login(),
        "/home": (context) => Home(),
      },
    );
  }
}
