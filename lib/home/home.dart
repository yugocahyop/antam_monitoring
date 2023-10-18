library home;

import 'dart:math';

import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
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
                            Content_home(
                              scSel: scSel,
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
