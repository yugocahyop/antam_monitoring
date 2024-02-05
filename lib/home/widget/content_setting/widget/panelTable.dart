import 'dart:convert';

import 'package:antam_monitoring/home/widget/content_dataLogger/widget/panelTableItem.dart';
import 'package:antam_monitoring/home/widget/content_setting/widget/page/account.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PanelTableSetting extends StatefulWidget {
  PanelTableSetting({super.key, required this.dataLog, required this.onTap});

  List<Map<String, dynamic>> dataLog;

  Function(int index) onTap;

  @override
  State<PanelTableSetting> createState() => _PanelTableSettingState();
}

class _PanelTableSettingState extends State<PanelTableSetting> {
  List<Map<String, dynamic>> tabItems = [
    {"title": "Account", "icon": Icons.person, "shown": true},
    {"title": "User role", "icon": Icons.manage_accounts, "shown": false},
    {"title": "Monitoring", "icon": Icons.bar_chart, "shown": false},
    {"title": "Call", "icon": Icons.phone, "shown": false},
  ];
  List<Map<String, dynamic>> dataLog = [{}];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dataLog.clear();

    dataLog = widget.dataLog;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 620,
      child: Stack(
        children: [
          SizedBox(
            height: 60,
            width: 500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: tabItems
                  .map((e) => InkWell(
                        onTap: () {},
                        child: Container(
                          width: 120,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MainStyle.secondaryColor,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(4, 4),
                                    color: MainStyle.primaryColor
                                        .withAlpha((255 * 0.05).toInt()),
                                    blurRadius: 10,
                                    spreadRadius: 0),
                                BoxShadow(
                                    offset: const Offset(-4, -4),
                                    color: Colors.white
                                        .withAlpha((255 * 0.5).toInt()),
                                    blurRadius: 13,
                                    spreadRadius: 0),
                                BoxShadow(
                                    offset: const Offset(6, 6),
                                    color: MainStyle.primaryColor
                                        .withAlpha((255 * 0.10).toInt()),
                                    blurRadius: 20,
                                    spreadRadius: 0),
                              ]),
                          child: Visibility(
                            visible: !e["shown"],
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: MainStyle.secondaryColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(e["icon"],
                                      color: MainStyle.primaryColor, size: 17),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    e["title"],
                                    style: MyTextStyle.defaultFontCustom(
                                        MainStyle.primaryColor, 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 60),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 500,
              height: 540,
              decoration: BoxDecoration(
                  color: MainStyle.secondaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(4, 4),
                        color: MainStyle.primaryColor
                            .withAlpha((255 * 0.05).toInt()),
                        blurRadius: 10,
                        spreadRadius: 0),
                    BoxShadow(
                        offset: const Offset(-4, -4),
                        color: Colors.white.withAlpha((255 * 0.5).toInt()),
                        blurRadius: 13,
                        spreadRadius: 0),
                    BoxShadow(
                        offset: const Offset(6, 6),
                        color: MainStyle.primaryColor
                            .withAlpha((255 * 0.10).toInt()),
                        blurRadius: 20,
                        spreadRadius: 0),
                  ]),
              child: AccountSetting(),
            ),
          ),
          SizedBox(
            height: 60,
            width: 500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: tabItems
                  .map((e) => Opacity(
                        opacity: !e["shown"] ? 0 : 1,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          splashColor: Colors.transparent,
                          onTap: () {
                            tabItems.firstWhere((element) =>
                                element["shown"] == true)["shown"] = false;
                            e["shown"] = true;
                            setState(() {});
                          },
                          child: Container(
                            width: 120,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: MainStyle.primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(4, -4),
                                      color: MainStyle.primaryColor
                                          .withAlpha((255 * 0.05).toInt()),
                                      blurRadius: 10,
                                      spreadRadius: 0),
                                  //   BoxShadow(
                                  //       offset: const Offset(-4, -4),
                                  //       color: Colors.white
                                  //           .withAlpha((255 * 0.5).toInt()),
                                  //       blurRadius: 13,
                                  //       spreadRadius: 0),
                                  //   BoxShadow(
                                  //       offset: const Offset(6, 6),
                                  //       color: MainStyle.primaryColor
                                  //           .withAlpha((255 * 0.10).toInt()),
                                  //       blurRadius: 20,
                                  //       spreadRadius: 0),
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(e["icon"], color: Colors.white, size: 17),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  e["title"],
                                  style: MyTextStyle.defaultFontCustom(
                                      Colors.white, 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
