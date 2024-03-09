import 'dart:convert';
import 'dart:math';

import 'package:antam_monitoring/home/widget/account_alarm.dart';
import 'package:antam_monitoring/home/widget/content_diagnostic/widget/panelNode.dart';
import 'package:antam_monitoring/home/widget/filterTangki.dart';
import 'package:antam_monitoring/home/widget/filterTgl.dart';
import 'package:antam_monitoring/home/widget/myDropDown.dart';
import 'package:antam_monitoring/home/widget/up.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/tools/mqtt/mqtt.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../../style/mainStyle.dart';
import '../../../style/textStyle.dart';
import '../../../widget/barChart.dart';
import '../../../widget/linechart.dart';
// import '../../home.dart';
// import '../account_alarm.dart';
// import '../filterTangki.dart';
// import '../filterTgl.dart';
// import '../myDropDown.dart';
// import '../up.dart';

class DiagnosticMobile extends StatefulWidget {
  DiagnosticMobile(
      {super.key,
      required this.changePage,
      required this.isAdmin,
      required this.mqtt,
      required this.selData,
      required this.scSel,
      required this.menuItem});

  final bool isAdmin;

  List<dynamic> selData;

  MyMqtt mqtt;

  Function(int index, {int? dari, int? hingga}) changePage;

  ScrollController scSel;
  List<Map<String, dynamic>> menuItem;

  @override
  State<DiagnosticMobile> createState() => _DiagnosticMobileState();
}

class _DiagnosticMobileState extends State<DiagnosticMobile> {
  // final MyTextStyle MyTextStyle = const MyTextStyle();

  var alarm = [
    {
      "title": "Status",
      "isActive": true,
    },
    {
      "title": "Alarm Arus",
      "isActive": false,
    },
    {
      "title": "Alarm Tegangan",
      "isActive": false,
    }
  ];

  late FilterTangki filterTangki;

  late FilterTgl filterTglHingga;

  late FilterTgl filterTglDari;

  filterChange() {
    widget.changePage(1,
        dari: filterTglDari.today, hingga: filterTglHingga.today);
  }

  late MyMqtt mqtt, mqtt2;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    mqtt.disconnect();
  }

  initMqtt() {
    mqtt.onUpdate = (data, topic) {
      if (topic == "antam/statusNode" || topic == "antam/statusnode") {
        int tangki = data["tangki"] as int;
        int sel = data["node"] as int;
        String status = data["status"] as String;
        int timeStamp = (data["timeStamp"] as int) * 1000;

        // DateFormat df = DateFormat("dd MMMM yyyy");

        // DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);

        diagnosticData[tangki - 1][sel - 1]["status"] = status;
        diagnosticData[tangki - 1][sel - 1]["lastUpdated"] = timeStamp;
      } else if (topic == "antam/device/node") {
        // final int tangki = data["tangki"] as int;

        // final sData = Map.from(data["selData"]);

        // if (kDebugMode) {
        //   print((sData));
        // }

        // for (var i = 2; i < titleData.length; i++) {
        //   final title = titleData[i].toLowerCase();

        //   selData[tangki][(data["sel"] as int) - 1][title] = sData[title];
        // }

        // getMax2();

        // getData(currTangki);

        // sortSelData();
      } else if (topic == "antam/status") {
        // print(data["alarmTegangang"]);

        var temp = [
          {
            "title": "Status",
            "isActive": (data["status"] == null
                ? alarm
                    .where((element) => element["title"] == "Status")
                    .first["isActive"]!
                : (data["status"] as bool)),
          },
          {
            "title": "Alarm Arus",
            "isActive": data["alarmArus"] == null
                ? alarm
                    .where((element) => element["title"] == "Alarm Arus")
                    .first["isActive"]!
                : data["alarmArus"] as bool,
          },
          {
            "title": "Alarm Tegangan",
            "isActive": data["alarmTegangan"] == null
                ? alarm
                    .where((element) => element["title"] == "Alarm Tegangan")
                    .first["isActive"]!
                : data["alarmTegangan"] as bool,
          }
        ];

        account_alarm.setState!();

        alarm.clear();
        alarm.addAll(temp);

        temp.clear();
      } else if (topic == "antam/statistic") {
        // totalData.firstWhere(
        //         (element) => element["title"] == "Total Waktu")["value"] =
        //     data["totalWaktu"] == null
        //         ? totalData
        //             .where((element) => element["title"] == "Total Waktu")
        //             .first["value"]!
        //         : (data["totalWaktu"] is double
        //             ? (data["totalWaktu"] as double)
        //             : (data["totalWaktu"] as int).toDouble());

        // totalData.firstWhere(
        //         (element) => element["title"] == "Tegangan Total")["value"] =
        //     data["teganganTotal"] == null
        //         ? totalData
        //             .where((element) => element["title"] == "Tegangan Total")
        //             .first["value"]!
        //         : (data["teganganTotal"] is double
        //             ? (data["teganganTotal"] as double)
        //             : (data["teganganTotal"] as int).toDouble());

        // totalData.firstWhere(
        //         (element) => element["title"] == "Arus Total")["value"] =
        //     data["arusTotal"] == null
        //         ? totalData
        //             .where((element) => element["title"] == "Arus Total")
        //             .first["value"]!
        //         : (data["arusTotal"] is double
        //             ? (data["arusTotal"] as double)
        //             : (data["arusTotal"] as int).toDouble());

        // totalData
        //         .firstWhere((element) => element["title"] == "Power")["value"] =
        //     data["power"] == null
        //         ? totalData
        //             .where((element) => element["title"] == "Power")
        //             .first["value"]!
        //         : (data["power"] is double
        //             ? (data["power"] as double)
        //             : (data["power"] as int).toDouble());

        // totalData.firstWhere(
        //         (element) => element["title"] == "Energi")["value"] =
        //     data["energi"] == null
        //         ? totalData
        //             .where((element) => element["title"] == "Energi")
        //             .first["value"]!
        //         : (data["energi"] is double
        //             ? (data["energi"] as double)
        //             : (data["energi"] as int).toDouble());

        // var temp = [
        //   {
        //     "title": "Total Waktu",
        //     "value": data["totalWaktu"] == null
        //         ? totalData
        //             .where((element) => element["title"] == "Total Waktu")
        //             .first["value"]!
        //         : (data["totalWaktu"] is double
        //             ? (data["totalWaktu"] as double)
        //             : (data["totalWaktu"] as int).toDouble()),
        //     "unit": "Jam"
        //   },
        //   {
        //     "title": "Tegangan Total",
        //     "value": data["teganganTotal"] == null
        //         ? totalData
        //             .where((element) => element["title"] == "Tegangan Total")
        //             .first["value"]!
        //         : (data["teganganTotal"] is double
        //             ? (data["teganganTotal"] as double)
        //             : (data["teganganTotal"] as int).toDouble()),
        //     "unit": "Volt"
        //   },
        //   {
        //     "title": "Arus Total",
        //     "value": data["arusTotal"] == null
        //         ? totalData
        //             .where((element) => element["title"] == "Arus Total")
        //             .first["value"]!
        //         : (data["arusTotal"] is double
        //             ? (data["arusTotal"] as double)
        //             : (data["arusTotal"] as int).toDouble()),
        //     "unit": "Ampere"
        //   },
        //   {
        //     "title": "Power",
        //     "value": data["power"] == null
        //         ? totalData
        //             .where((element) => element["title"] == "Power")
        //             .first["value"]!
        //         : (data["power"] is double
        //             ? (data["power"] as double)
        //             : (data["power"] as int).toDouble()),
        //     "unit": "Watt"
        //   },
        //   {
        //     "title": "Energi",
        //     "value": data["energi"] == null
        //         ? totalData
        //             .where((element) => element["title"] == "Energi")
        //             .first["value"]!
        //         : (data["energi"] is double
        //             ? (data["energi"] as double)
        //             : (data["energi"] as int).toDouble()),
        //     "unit": "Watt_Jam"
        //   },
        // ];

        // totalData.clear();
        // totalData.addAll(temp);
      }

      data.clear();

      if (mounted) {
        setState(() {});
      }

      // Future.delayed(Duration(milliseconds: 500), () {

      // });
    };
  }

  late Account_alarm account_alarm;

  List<dynamic> diagnosticData = [
    [
      {"sel": 1, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 2, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 3, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 4, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 5, "status": "inactive", "lastUpdated": 1706561733680},
    ],
    [
      {"sel": 1, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 2, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 3, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 4, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 5, "status": "inactive", "lastUpdated": 1706561733680},
    ],
    [
      {"sel": 1, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 2, "status": "active", "lastUpdated": 1706561733680},
      {"sel": 3, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 4, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 5, "status": "inactive", "lastUpdated": 1706561733680},
    ],
    [
      {"sel": 1, "status": "active", "lastUpdated": 1706561733680},
      {"sel": 2, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 3, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 4, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 5, "status": "inactive", "lastUpdated": 1706561733680},
    ],
    [
      {"sel": 1, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 2, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 3, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 4, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 5, "status": "inactive", "lastUpdated": 1706561733680},
    ],
    [
      {"sel": 1, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 2, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 3, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 4, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 5, "status": "inactive", "lastUpdated": 1706561733680},
    ],
    [
      {"sel": 1, "status": "inactive", "lastUpdated": 1706561733680},
    ],
  ];

  initDiagData() async {
    final api = ApiHelper();

    while (ApiHelper.tokenMain.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
    }

    final r = await api.callAPI("/diagnostic/find/last", "POST", "", true);

    if (kDebugMode) {
      print("backend data: $r");
    }

    if (r["error"] == null) {
      diagnosticData.clear();

      diagnosticData.addAll(r["data"][0]["diagnosticData"] ?? []);
    }

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    filterTglHingga = FilterTgl(
      title: "Hingga",
      lastValue: true,
      changePage: () => filterChange(),
    );

    filterTglDari = FilterTgl(
      title: "Dari",
      lastValue: false,
      changePage: () => filterChange(),
    );

    account_alarm = Account_alarm(alarm: alarm, isAdmin: widget.isAdmin);

    mqtt = widget.mqtt;

    mqtt2 = MyMqtt(onUpdate: (d, t) {});

    // getData(0);

    // if (kDebugMode) {
    //   print("sel length: ${selData.length}");
    // }

    mqtt = MyMqtt(onUpdate: (data, topic) {});

    initDiagData();
    initMqtt();

    // getMax2();
  }

  togglePanelMqtt(int tangki, int sel, bool isActive) {
    // while (!mqtt!.isConnected) {
    //   await Future.delayed(Duration(milliseconds: 500));
    // }

    final api = ApiHelper();

    api.callAPI(
        "/diagnostic/toggle",
        "POST",
        jsonEncode({"tangki": tangki, "node": sel, "isActive": isActive}),
        true);

    try {
      mqtt2.publish({
        "tangki": tangki,
        "node": sel,
        "activate": !isActive,
        // "status": isActive ? false : true
      }, "antam/command");
    } catch (e) {}
  }

  List<Widget> getDiagnostiWidget(double width) {
    List<Widget> rows = [];

    DateFormat df = DateFormat("dd MMM yyyy HH:mm");

    for (var i = 0; i < diagnosticData.length; i++) {
      final sel = diagnosticData[i];
      List<Widget> pn = [];

      // DateFormat df2 = DateFormat("dd MMM yyyy");

      for (var ii = 0; ii < sel.length; ii++) {
        DateTime now = DateTime.now();
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(sel[ii]["lastUpdated"] as int);
        String status = sel[ii]["status"] as String;

        String lastUpdated = "";

        // if (kDebugMode) {
        print("now : ${df.format(now)} date: ${df.format(date)} ");
        // }

        if (now.year == date.year) {
          if (now.month == date.month) {
            if (now.day == (date.day)) {
              if (now.hour == date.hour) {
                if (now.minute == date.minute) {
                  if (now.second == date.second) {
                    lastUpdated = "baru";
                  } else {
                    lastUpdated = "${now.second - date.second} detik lalu";
                  }
                } else {
                  lastUpdated = "${now.minute - date.minute} menit lalu";
                }
              } else {
                lastUpdated = "${now.hour - date.hour} jam lalu";
              }
            } else {
              lastUpdated = "${now.day - date.day} hari lalu";
            }
          } else {
            lastUpdated = "${now.month - date.month} bulan lalu";
          }
        } else {
          lastUpdated = "${now.year - date.year} tahun lalu";
        }
        pn.add(PanelNode(
          tapFunction: () => togglePanelMqtt(i + 1, ii + 1,
              status == "active" || status.contains("alarm") ? true : false),
          isSensor: i == 6,
          width: width,
          tangki: i + 1,
          sel: ii + 1,
          status: status,
          lastUpdated: lastUpdated,
          // lastUpdated:  df.format(date)
        ));
      }

      rows.add(SizedBox(
        height: width,
        child: Stack(
          children: [
            Center(
              child: Visibility(
                visible: (i != 6),
                child: const SizedBox(
                  width: 400,
                  child: Divider(
                    thickness: 2,
                    color: MainStyle.thirdColor,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: pn,
            ),
          ],
        ),
      ));

      rows.add(const SizedBox(
        height: 7,
      ));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Visibility(visible: lheight > 400, child: Up()),
        Container(
          // height: ,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 20, child: account_alarm),
              // const SizedBox(
              //   height: 5,
              // ),
              MainStyle.sizedBoxH5,

              // const SizedBox(
              //   height: 10,
              // ),
              MainStyle.sizedBoxH10,
              SizedBox(
                  width: lWidth,
                  child: const Divider(
                    thickness: 1,
                  ))
            ],
          ),
        ),
        // const SizedBox(
        //   height: 20,
        // ),
        Expanded(
          child: Scrollbar(
            controller: widget.scSel,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: widget.scSel,
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      width: lWidth,
                      height: 620,
                      decoration: BoxDecoration(
                        // color: MainStyle.secondaryColor,

                        borderRadius: BorderRadius.circular(30),
                        // boxShadow: [
                        //   BoxShadow(
                        //       offset: Offset(4, 4),
                        //       color: MainStyle.primaryColor
                        //           .withAlpha((255 * 0.05).toInt()),
                        //       blurRadius: 10,
                        //       spreadRadius: 0),
                        //   BoxShadow(
                        //       offset: Offset(-4, -4),
                        //       color: Colors.white
                        //           .withAlpha((255 * 0.5).toInt()),
                        //       blurRadius: 13,
                        //       spreadRadius: 0),
                        //   BoxShadow(
                        //       offset: Offset(6, 6),
                        //       color: MainStyle.primaryColor
                        //           .withAlpha((255 * 0.10).toInt()),
                        //       blurRadius: 20,
                        //       spreadRadius: 0),
                        // ]
                      ),
                      child: Column(
                        children: getDiagnostiWidget(lWidth <= 400 ? 60 : 70),
                      )),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
