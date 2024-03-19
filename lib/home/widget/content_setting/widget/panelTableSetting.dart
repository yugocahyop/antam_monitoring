// import 'dart:convert';

// import 'package:antam_monitoring/home/widget/content_dataLogger/widget/panelTableItem.dart';

import 'package:antam_monitoring/home/widget/content_setting/widget/page/account.dart';
import 'package:antam_monitoring/home/widget/content_setting/widget/page/call.dart';
import 'package:antam_monitoring/home/widget/content_setting/widget/page/monitoring.dart';
import 'package:antam_monitoring/home/widget/content_setting/widget/page/userRole.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
// import 'package:antam_monitoring/tools/apiHelper.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PanelTableSetting extends StatefulWidget {
  PanelTableSetting(
      {super.key,
      required this.dataLog,
      required this.onTap,
      required this.email,
      required this.isAdmin});

  List<Map<String, dynamic>> dataLog;
  final String email;
  final bool isAdmin;

  Function(int index) onTap;

  @override
  State<PanelTableSetting> createState() => _PanelTableSettingState();
}

class _PanelTableSettingState extends State<PanelTableSetting> {
  late List<Map<String, dynamic>> tabItems;
  List<Map<String, dynamic>> dataLog = [{}];

  late Widget mainWidget;
  changeMain(Widget? m) {
    setState(() {
      mainWidget = m ??
          AccountSetting(
            email: widget.email,
            isAdmin: widget.isAdmin,
          );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mainWidget = AccountSetting(
      email: widget.email,
      isAdmin: widget.isAdmin,
    );

    tabItems = [
      {
        "title": "Account",
        "icon": Icons.person,
        "shown": true,
        "widget": AccountSetting(
          email: widget.email,
          isAdmin: widget.isAdmin,
        )
      },
      {
        "title": "User role",
        "icon": Icons.manage_accounts,
        "shown": false,
        "widget": const UserRole()
      },
      {
        "title": "Monitoring",
        "icon": Icons.bar_chart,
        "shown": false,
        "widget": const MonitoringSetting()
      },
      {
        "title": "Call",
        "icon": Icons.phone,
        "shown": false,
        "widget": const CallSetting()
      },
    ];

    if (!widget.isAdmin) {
      tabItems =
          tabItems.where((element) => element["title"] == "Account").toList();
    }

    dataLog.clear();

    dataLog = widget.dataLog;
  }

  @override
  Widget build(BuildContext context) {
    final lwidth = MediaQuery.of(context).size.width;
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
                          width: lwidth <= 500 ? 90 : 120,
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
                                        MainStyle.primaryColor,
                                        lwidth <= 500 ? 12 : 18),
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
              child: mainWidget,
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

                            changeMain(e["widget"]);
                          },
                          child: Container(
                            width: lwidth <= 500 ? 90 : 120,
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
                                      Colors.white, lwidth <= 500 ? 12 : 18),
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
