library home;

import 'dart:math';
import 'dart:ui_web';

import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/mqtt/mqtt.dart';
import 'package:antam_monitoring/widget/barChart.dart';
import 'package:antam_monitoring/widget/linechart.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:antam_monitoring/widget/myTextField.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../controller/controller.dart';

part 'widget/menu.dart';
part 'widget/content_home.dart';
part 'widget/account_alarm.dart';
part 'widget/filterTgl.dart';
part 'widget/myDropDown.dart';
part 'widget/filterTangki.dart';
part 'widget/content_home_mobile.dart';
part 'widget/up.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var alarm = [
    {
      "title": "Status",
      "isActive": true,
    },
    {
      "title": "Alarm Arus",
      "isActive": true,
    },
    {
      "title": "Alarm Tegangan",
      "isActive": false,
    }
  ];

  List<dynamic> selData = [
    [
      {"sel": 1, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
      {"sel": 2, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
      {"sel": 3, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
      {"sel": 4, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
      {"sel": 5, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
      {"sel": 6, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
    ],
    [
      {"sel": 1, "celcius": 32.0, "volt": 60.0, "ampere": 30.0},
      {"sel": 2, "celcius": 50.0, "volt": 50.0, "ampere": 31.0},
      {"sel": 3, "celcius": 43.0, "volt": 20.0, "ampere": 33.0},
      {"sel": 4, "celcius": 36.0, "volt": 35.0, "ampere": 35.0},
      {"sel": 5, "celcius": 37.0, "volt": 65.0, "ampere": 36.0},
      {"sel": 6, "celcius": 60.0, "volt": 55.0, "ampere": 37.0},
    ],
    [
      {"sel": 1, "celcius": 32.0, "volt": 60.0, "ampere": 30.0},
      {"sel": 2, "celcius": 50.0, "volt": 50.0, "ampere": 31.0},
      {"sel": 3, "celcius": 43.0, "volt": 20.0, "ampere": 33.0},
      {"sel": 4, "celcius": 36.0, "volt": 35.0, "ampere": 35.0},
      {"sel": 5, "celcius": 37.0, "volt": 65.0, "ampere": 36.0},
      {"sel": 6, "celcius": 60.0, "volt": 55.0, "ampere": 37.0},
    ],
    [
      {"sel": 1, "celcius": 32.0, "volt": 60.0, "ampere": 30.0},
      {"sel": 2, "celcius": 50.0, "volt": 50.0, "ampere": 31.0},
      {"sel": 3, "celcius": 43.0, "volt": 20.0, "ampere": 33.0},
      {"sel": 4, "celcius": 36.0, "volt": 35.0, "ampere": 35.0},
      {"sel": 5, "celcius": 37.0, "volt": 65.0, "ampere": 36.0},
      {"sel": 6, "celcius": 60.0, "volt": 55.0, "ampere": 37.0},
    ],
    [
      {"sel": 1, "celcius": 32.0, "volt": 60.0, "ampere": 30.0},
      {"sel": 2, "celcius": 50.0, "volt": 50.0, "ampere": 31.0},
      {"sel": 3, "celcius": 43.0, "volt": 20.0, "ampere": 33.0},
      {"sel": 4, "celcius": 36.0, "volt": 35.0, "ampere": 35.0},
      {"sel": 5, "celcius": 37.0, "volt": 65.0, "ampere": 36.0},
      {"sel": 6, "celcius": 60.0, "volt": 55.0, "ampere": 37.0},
    ],
    [
      {"sel": 1, "celcius": 32.0, "volt": 60.0, "ampere": 30.0},
      {"sel": 2, "celcius": 50.0, "volt": 50.0, "ampere": 31.0},
      {"sel": 3, "celcius": 43.0, "volt": 20.0, "ampere": 33.0},
      {"sel": 4, "celcius": 36.0, "volt": 35.0, "ampere": 35.0},
      {"sel": 5, "celcius": 37.0, "volt": 65.0, "ampere": 36.0},
      {"sel": 6, "celcius": 60.0, "volt": 55.0, "ampere": 37.0},
    ],
    [
      {"sel": 1, "celcius": 32.0, "volt": 60.0, "ampere": 30.0},
      {"sel": 2, "celcius": 50.0, "volt": 50.0, "ampere": 31.0},
      {"sel": 3, "celcius": 43.0, "volt": 20.0, "ampere": 33.0},
      {"sel": 4, "celcius": 36.0, "volt": 35.0, "ampere": 35.0},
      {"sel": 5, "celcius": 37.0, "volt": 65.0, "ampere": 36.0},
      {"sel": 6, "celcius": 60.0, "volt": 55.0, "ampere": 37.0},
    ],
  ];

  final menuItems = [
    {"title": "Home", "icon": Icons.home_outlined, "isActive": true},
    {
      "title": "Data Logger",
      "icon": Icons.description_outlined,
      "isActive": false
    },
    {"title": "Emergency Call", "icon": Icons.call_outlined, "isActive": false},
    {"title": "Settings", "icon": Icons.settings_outlined, "isActive": false},
  ];

  var scMain = ScrollController();
  var scSel = ScrollController();

  final double wide = 16 / 9;

  late MyMqtt mqtt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final r = Random(70);

    mqtt = MyMqtt(onUpdate: (data) {});

    for (var i = 1; i < selData.length; i++) {
      final v = selData[i];
      for (var e in v) {
        final c = e["celcius"] = r.nextDouble() * 70;
        final vv = e["volt"] = r.nextDouble() * 70;
        final a = e["ampere"] = r.nextDouble() * 70;
        //  e["celcius"] = (e["celcius"] as int) + 1;
        // final index = v.indexOf(e);
        // selData[0][index]["celcius"] = max(
        //     selData[0][index]["celcius"] is int
        //         ? (selData[0][index]["celcius"] as int).toDouble()
        //         : selData[0][index]["celcius"] as double,
        //     c);
        // selData[0][index]["volt"] = max(
        //     selData[0][index]["volt"] is int
        //         ? (selData[0][index]["volt"] as int).toDouble()
        //         : selData[0][index]["volt"] as double,
        //     vv);
        // selData[0][index]["ampere"] = max(
        //     selData[0][index]["ampere"] is int
        //         ? (selData[0][index]["ampere"] as int).toDouble()
        //         : selData[0][index]["ampere"] as double,
        //     a);
      }

      // if (kDebugMode) {
      //   print("sel data 0 : ${selData[0][0].toString()}");
      // }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scSel.dispose();
    mqtt.disconnect();
  }

  // double currSelOffset = 0;
  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    // print(lheight);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: lWidth < 900
          ? Scrollbar(
              controller: scMain,
              thumbVisibility: true,
              child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  controller: scMain,
                  child: SizedBox(
                      width: lWidth,
                      height: lheight,
                      child: Content_home_mobile(
                        mqtt: mqtt,
                        selData: selData,
                        scSel: scSel,
                        menuItem: menuItems,
                      ))),
            )
          : FittedBox(
              fit: lWidth < 1000 ? BoxFit.fitWidth : BoxFit.fitHeight,
              // scaleY: lheight / ,
              child: Container(
                // clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                // width: lWidth,
                // height: lheight,
                child: SizedBox(
                  width: (lWidth / lheight) < wide
                      ? 2200
                      : lWidth < 900
                          ? 450
                          : 1520,
                  child: Listener(
                    onPointerSignal: (pointerSignal) {
                      // if (pointerSignal is PointerScrollEvent) {
                      //   scMain.animateTo(scMain.offset + pointerSignal.scrollDelta.dy,
                      //       duration: const Duration(milliseconds: 100),
                      //       curve: Curves.ease);
                      // }
                    },
                    child: Scrollbar(
                      // hoverThickness: 10,
                      thickness: 10,
                      thumbVisibility: true,
                      controller: scMain,
                      child: SingleChildScrollView(
                        controller: scMain,
                        scrollDirection:
                            lWidth < 900 ? Axis.vertical : Axis.horizontal,
                        child: Row(
                          children: [
                            Visibility(
                              visible: lWidth >= 900,
                              child: SizedBox(
                                width: (lWidth / lheight) < wide ? 400 : 250,
                                child: Menu(
                                  menuItem: menuItems,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Visibility(
                                  visible: false,
                                  child: Transform.scale(
                                      scale:
                                          (lWidth / lheight) < wide ? 1.2 : 1,
                                      origin: Offset(
                                          (lWidth / lheight) < wide ? -610 : 0,
                                          0),
                                      child: Account_alarm(alarm: alarm)),
                                ),
                                Content_home(
                                  mqtt: mqtt,
                                  scSel: scSel,
                                  selData: selData,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
