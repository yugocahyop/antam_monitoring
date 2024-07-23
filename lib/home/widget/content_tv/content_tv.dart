import 'dart:convert';
// import 'dart:ffi';
// import 'dart:js_interop';
import 'dart:math';
import 'dart:async';

import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/home/widget/account_alarm.dart';
// import 'package:antam_monitoring/home/widget/content_diagnostic/widget/panelNode.dart';
import 'package:antam_monitoring/home/widget/filterTangki.dart';
import 'package:antam_monitoring/home/widget/filterTgl.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/tools/mqtt/mqtt.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'widget/panelNode.dart';

class Content_tv extends StatefulWidget {
  Content_tv(
      {super.key,
      required this.changePage,
      required this.isAdmin,
      required this.scSel,
      required this.selData,
      required this.mqtt});

  final bool isAdmin;

  List<dynamic> selData;

  MyMqtt mqtt;

  ScrollController scSel;

  Function(int index, {int? dari, int? hingga}) changePage;

  @override
  State<Content_tv> createState() => _Content_diagnosticState();
}

class _Content_diagnosticState extends State<Content_tv> {
  var alarm = [
    {
      "title": "Status",
      "isActive": true,
      "isLower": false,
    },
    {"title": "Alarm Arus", "isActive": false, "isLower": false, "list": []},
    {
      "title": "Alarm Tegangan",
      "isActive": false,
      "isLower": false,
      "list": []
    },
    {"title": "Alarm Suhu", "isActive": false, "isLower": false, "list": []},
    {"title": "Alarm pH", "isActive": false, "isLower": false, "list": []},
  ];

  var titleData = ["#Crossbar", "Suhu", "Tegangan", "Arus", "Daya", "Energi"];

  // final selScrollController = ScrollController();

  final maxDdata = [
    {"sel": 1, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
    {"sel": 2, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
    {"sel": 3, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
    {"sel": 4, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
    {"sel": 5, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
    {"sel": 6, "celcius": 0.0, "volt": 0.0, "ampere": 0.0},
  ];

  List<dynamic> tangkiMaxData = [
    {"sel": 1, "suhu": 0, "tegangan": 0, "arus": 0, "daya": 0, "energi": 0},
    {"sel": 2, "suhu": 0, "tegangan": 0, "arus": 0, "daya": 0, "energi": 0},
    {"sel": 3, "suhu": 0, "tegangan": 0, "arus": 0, "daya": 0, "energi": 0},
    {"sel": 4, "suhu": 0, "tegangan": 0, "arus": 0, "daya": 0, "energi": 0},
    {"sel": 5, "suhu": 0, "tegangan": 0, "arus": 0, "daya": 0, "energi": 0},
    {"sel": 6, "suhu": 0, "tegangan": 0, "arus": 0, "daya": 0, "energi": 0},
  ];

  List<dynamic> selData = [
    [
      {},
    ],
  ];

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
      {"sel": 2, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 3, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 4, "status": "inactive", "lastUpdated": 1706561733680},
      {"sel": 5, "status": "inactive", "lastUpdated": 1706561733680},
    ],
    [
      {"sel": 1, "status": "inactive", "lastUpdated": 1706561733680},
    ],
  ];

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

  resetEnergi() {
    // while (!mqtt!.isConnected) {
    //   await Future.delayed(Duration(milliseconds: 500));
    // }

    final api = ApiHelper();

    api.callAPI("/diagnostic/reset", "POST", jsonEncode({}), true);

    try {
      mqtt2.publish({
        "tangki": 15,
        "node": 15,
        // "activate": !isActive,
        "command": "resetEnergi"
        // "status": isActive ? false : true
      }, "antam/command");
    } catch (e) {}
  }

  promptToggle(int tangki, int sel, bool isActive,
      {bool isResetEnergi = false}) {
    if (tangki == 7 && sel == 1) {
      return;
    }

    final c = Controller();
    c.goToDialog(
        context,
        AlertDialog(
          title: Text(isResetEnergi
              ? "Reset energi ?"
              : "${isActive ? "Matikan" : "Aktifkan"} ${tangki == 15 && sel == 15 ? "semua" : "sel $tangki - $sel"} ?"),
          actions: [
            SizedBox(
              width: 80,
              child: MyButton(
                  color: MainStyle.primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "No"),
            ),
            MainStyle.sizedBoxW10,
            SizedBox(
              width: 80,
              child: MyButton(
                  color: MainStyle.primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);

                    if (isResetEnergi) {
                      resetEnergi();
                    } else {
                      togglePanelMqtt(
                        tangki,
                        sel,
                        isActive,
                      );
                    }
                  },
                  text: ("Yes")),
            ),
          ],
        ));
  }

  String lastUpdateElektrolit(){
     DateTime now = DateTime.now();
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(diagnosticData[6][0]["lastUpdated"] as int);
        // String status = sel[ii]["status"] as String;

        String lastUpdated = "";


        if (now.year == date.year) {
          if (now.month == date.month) {
            if (now.day == date.day) {
              if (now.hour == date.hour) {
                if (now.minute == date.minute) {
                  if (now.second <= date.second) {
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

        return lastUpdated;
  }

  List<Widget> getDiagnostiWidget(double width) {
    List<Widget> rows = [];

    for (var i = 0; i < 6; i++) {
      final sel = diagnosticData[i];
      List<Widget> pn = [];

      // DateFormat df2 = DateFormat("dd MMM yyyy");

      for (var ii = 0; ii < sel.length; ii++) {
        DateTime now = DateTime.now();
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(sel[ii]["lastUpdated"] as int);
        String status = sel[ii]["status"] as String;

        String lastUpdated = "";

        if (kDebugMode && i == 3 && ii == 0) {
          DateFormat df = DateFormat("dd MMM yyyy HH:mm");
          print("now : ${df.format(now)} date: ${df.format(date)} ");
        }

        if (now.year == date.year) {
          if (now.month == date.month) {
            if (now.day == date.day) {
              if (now.hour == date.hour) {
                if (now.minute == date.minute) {
                  if (now.second <= date.second) {
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

        if (kDebugMode) {
          print("sel data get: $selData");
        }
        pn.add(PanelNode(
          tapFunction: (() {}),
          // tapFunction: () => promptToggle(i + 1, ii + 1,
          //     status == "active" || status.contains("alarm") ? true : false),
          isSensor: i == 6,
          width: width,
          tangki: i + 1,
          sel: ii + 1,
          status: status,
          lastUpdated: lastUpdated,
          dateDiff: now.millisecondsSinceEpoch - date.millisecondsSinceEpoch,
          isLoading: isLoading,
          // daya: 0,
          // arus: 0,
          // tegangan: 0,
          // suhu: 0,
          // energi: 0,
          daya: selData.length <= 1.0
              ? 0.0
              : (selData[i + 1][ii]["daya"] ?? 0.0) / 1,
          arus: selData.length <= 1
              ? 0
              : (selData[i + 1][ii]["arus"] ?? 0) / 1,
          tegangan: selData.length <= 1
              ? 0.0
              : (selData[i + 1][ii]["tegangan"] ?? 0.00) / 1,
          suhu: selData.length <= 1
              ? 0.0
              : (selData[i + 1][ii]["suhu"] ?? 0.00) / 1,
          energi: selData.length <= 1
              ? 0.0
              : (selData[i + 1][ii]["energi"] ?? 0.00) / 1,
          // lastUpdated:  df.format(date)
        ));
      }

      rows.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 7),
        height: 77,
        decoration: BoxDecoration(
            color: MainStyle.secondaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Center(
              child: Visibility(
                visible: (i != 6),
                child: const SizedBox(
                  width: 900,
                  child: Divider(
                    thickness: 2,
                    color: MainStyle.thirdColor,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  child: Text(
                    "Sel ${i + 1}",
                    style: MyTextStyle.defaultFontCustom(
                        MainStyle.primaryColor, 22),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: pn,
                  ),
                ),
              ],
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

  var totalData = [
    {"id": 0,"title": "Total Waktu", "value": 0.0, "unit": "Jam", "subUnit": "Menit"},
    {"id": 1,"title": "Tegangan Total", "value": 0.0, "unit": "V", "subUnit": ""},
    {"id": 2,"title": "Arus Total", "value": 0, "unit": "A", "subUnit": ""},
    {"id": 3,"title": "Daya", "value": 0.0, "unit": "W", "subUnit": ""},
    {"id": 4,"title": "Energi", "value": 0, "unit": "kWh", "subUnit": ""},
  ];

  var idData = [
    {"id": 0},
    {"id": 1},
    {"id": 2},
    {"id": 3},
    {"id": 4},
  ];

  var teganganSetting = [const FlSpot(0, 1), const FlSpot(6, 1)];

  var teganganData = [
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 0),
    const FlSpot(4, 0),
    const FlSpot(5, 0),
    const FlSpot(6, 0)
  ];

  var arusData = [
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 0),
    const FlSpot(4, 0),
    const FlSpot(5, 0),
    const FlSpot(6, 0)
  ];

  var arusSetting = [const FlSpot(0, 1), const FlSpot(6, 1)];

  final grad_colors = [
    MainStyle.primaryColor.withAlpha(((255 * 0.4) * 0.3).toInt()),
    MainStyle.primaryColor.withAlpha(((255 * 0.3) * 0.3).toInt()),
    MainStyle.primaryColor.withAlpha(((255 * 0.1) * 0.3).toInt()),
  ];


  String generateValueData(Map<String, dynamic> data) {
    String result = "0";
    int id = (data["id"] as int).toInt();
    double value = data['value'] as double;
    switch(id) {
      case 0: {
        result = value.toStringAsFixed(2);
        int index = result.indexOf('.');
        String text_1 = result.substring(0, index);
        String text_2 = result.substring(index+1);
        result = "$text_1 jam $text_2 menit";
        break;
      }
      case 1: 
        result = "${value.toStringAsFixed(2)} ${data['unit']}";
        break;
      case 2: 
        result = "${value.toStringAsFixed(0)} ${data['unit']}";
        break;
      case 3: 
        result = "${value.toStringAsFixed(0)} ${data['unit']}";
        break;
      case 4: 
        result = "${value.toStringAsFixed(2)} ${data['unit']}";
        break;
      default:
        break;
    }
    return result;
  }

  String warningMsg = "Message";

  double msgOpacity = 0;

  bool isMsgVisible = false;

  final double wide = 16 / 9;

  late FilterTgl filterTglHingga;

  late FilterTgl filterTglDari;

  filterChange() {
    widget.changePage(1,
        dari: filterTglDari.today, hingga: filterTglHingga.today);
  }

  getTotal(int tangki) {
    // final d = selData[tangki];

    // int totalArus = 0;
    // int totalTegangan = 0;

    // for (var element in d) {
    //   totalArus += (element["ampere"] ?? element["arus"]) is double
    //       ? ((element["ampere"] ?? element["arus"]) as double).toInt()
    //       : (element["ampere"] ?? element["arus"]) as int;
    //   totalTegangan += (element["volt"] ?? element["tegangan"]) is double
    //       ? ((element["volt"] ?? element["tegangan"]) as double).toInt()
    //       : (element["volt"] ?? element["tegangan"]) as int;
    // }

    // totalData
    //     .where((element) => element["title"] == "Tegangan Total")
    //     .first["value"] = totalTegangan;
    // totalData
    //     .where((element) => element["title"] == "Arus Total")
    //     .first["value"] = totalArus;

    // setState(() {});
  }

  // getMax() {
  //   teganganData = [];

  //   arusData = [];

  //   final max = [];
  // }

  getData(int tangki, {bool isSetState = true}) {
    // if (tangki == 0) {
    //   return;
    // }

    if (currTangki != tangki) {
      currTangki = tangki;
    }

    // teganganData = [];

    // arusData = [];

    teganganData.clear();
    arusData.clear();

    if (tangki >= selData.length) return;

    for (var e in selData[tangki]) {
      teganganData.add(FlSpot(
          (e["sel"] as int).toDouble(),
          (e["tegangan"] ?? e["volt"]) is double
              ? (e["tegangan"] ?? e["volt"]) as double
              : ((e["tegangan"] ?? e["volt"]) as int).toDouble()));

      arusData.add(FlSpot(
          (e["sel"] as int).toDouble(),
          (e["arus"] ?? e["ampere"]) is double
              ? (e["arus"] ?? e["ampere"]) as double
              : ((e["arus"] ?? e["ampere"]) as int).toDouble()));
    }

    // getTotal(tangki);

    if (mounted && isSetState) setState(() {});
  }

  late FilterTangki filterTangki;

  setSetting(String data, double value) {
    switch (data) {
      case "tegangan":
        teganganSetting = [FlSpot(0, value), FlSpot(6, value)];

        break;
      case "arus":
        arusSetting = [FlSpot(0, value), FlSpot(6, value)];

        break;
      default:
    }

    if (mounted) setState(() {});
  }

  getMax({bool isSetState = true}) {
    // selData[0].clear();

    // selData[0] = ([
    //   {
    //     "sel": 1,
    //     "suhu": 0.0,
    //     "tegangan": 0.0,
    //     "arus": 0.0,
    //     "daya": 0.0,
    //     "energi": 0.0
    //   },
    //   {
    //     "sel": 2,
    //     "suhu": 0.0,
    //     "tegangan": 0.0,
    //     "arus": 0.0,
    //     "daya": 0.0,
    //     "energi": 0.0
    //   },
    //   {
    //     "sel": 3,
    //     "suhu": 0.0,
    //     "tegangan": 0.0,
    //     "arus": 0.0,
    //     "daya": 0.0,
    //     "energi": 0.0
    //   },
    //   {
    //     "sel": 4,
    //     "suhu": 0.0,
    //     "tegangan": 0.0,
    //     "arus": 0.0,
    //     "daya": 0.0,
    //     "energi": 0.0
    //   },
    //   {
    //     "sel": 5,
    //     "suhu": 0.0,
    //     "tegangan": 0.0,
    //     "arus": 0.0,
    //     "daya": 0.0,
    //     "energi": 0.0
    //   },
    // ]);

    for (var x = 0; x < selData[0].length; x++) {
      for (var i = 1; i < titleData.length; i++) {
        final title = titleData[i].toLowerCase();

        selData[0][x][title] = 0;
      }
    }

    for (var i = 1; i < selData.length - 1; i++) {
      final v = selData[i];

      // int count = 1;
      for (var e in v) {
        final c = (e["suhu"] ?? e["celcius"]) is int
            ? ((e["suhu"] ?? e["celcius"]) as int).toDouble()
            : (e["suhu"] ?? e["celcius"]) as double;
        final vv = (e["tegangan"] ?? e["volt"]) is int
            ? ((e["tegangan"] ?? e["volt"]) as int).toDouble()
            : (e["tegangan"] ?? e["volt"]) as double;
        final a = (e["arus"] ?? e["ampere"]) is int
            ? ((e["arus"] ?? e["ampere"]) as int).toDouble()
            : (e["arus"] ?? e["ampere"]) as double;
        final w = (e["daya"] ?? e["watt"] ?? 0) is int
            ? ((e["daya"] ?? e["watt"] ?? 0) as int).toDouble()
            : (e["daya"] ?? e["watt"] ?? 0) as double;
        final en = (e["energi"] ?? e["kwh"] ?? 0) is int
            ? ((e["energi"] ?? e["kwh"] ?? 0) as int).toDouble()
            : (e["energi"] ?? e["kwh"] ?? 0) as double;
        //  e["celcius"] = (e["celcius"] as int) + 1;
        final index2 = v.indexOf(e) + 1;
        final index = i - 1;

        if (index < 6 && tangkiMaxData.isNotEmpty) {
          selData[0][index]["suhu"] = max(
              selData[0][index]["suhu"] is int
                  ? (selData[0][index]["suhu"] as int).toDouble()
                  : selData[0][index]["suhu"] as double,
              c);
          selData[0][index]["tegangan"] = max(
              selData[0][index]["tegangan"] is int
                  ? (selData[0][index]["tegangan"] as int).toDouble()
                  : selData[0][index]["tegangan"] as double,
              vv);
          selData[0][index]["arus"] = max(
              selData[0][index]["arus"] is int
                  ? (selData[0][index]["arus"] as int).toDouble()
                  : selData[0][index]["arus"] as double,
              a);
          selData[0][index]["daya"] = max(
              selData[0][index]["daya"] is int
                  ? (selData[0][index]["daya"] as int).toDouble()
                  : selData[0][index]["daya"] as double,
              w);
          selData[0][index]["energi"] = max(
              selData[0][index]["energi"] is int
                  ? (selData[0][index]["energi"] as int).toDouble()
                  : selData[0][index]["energi"] as double,
              en);

          tangkiMaxData[index]["suhu"] = selData[0][index]["suhu"] == c
              ? index2
              : tangkiMaxData[index]["suhu"];

          tangkiMaxData[index]["tegangan"] = selData[0][index]["tegangan"] == vv
              ? index2
              : tangkiMaxData[index]["tegangan"];

          tangkiMaxData[index]["arus"] = selData[0][index]["arus"] == a
              ? index2
              : tangkiMaxData[index]["arus"];

          tangkiMaxData[index]["daya"] = selData[0][index]["daya"] == w
              ? index2
              : tangkiMaxData[index]["daya"];

          tangkiMaxData[index]["energi"] = selData[0][index]["energi"] == en
              ? index2
              : tangkiMaxData[index]["energi"];
        }

        // count++;
      }

      // if (kDebugMode) {
      //   print("sel data 0 : ${selData[0][0].toString()}");
      // }
    }
  }

  late MyMqtt mqtt;
  late MyMqtt mqtt2;

  Map<String, bool> dataNyataSortOrder = {};
  List<String> dataNyataSortOrderList = [];

  resetSelDataSort() {
    (selData[int.tryParse(filterTangki.tangkiValue) ?? 0] as List<dynamic>)
        .sort((dynamic a, dynamic b) {
      // final aVal = currTangki == 0 ? a["tangki"] as double : a["sel"] as double;
      // final bVal = currTangki == 0 ? b["tangki"] as double : b["sel"] as double;
      // final aVal2 = a["sel"] as double;
      // final bVal2 = b["sel"] as double;

      final aVal = currTangki == 0
          ? (a["tangki"] is int ? a["tangki"] as int : a["tangki"] as double)
          : (a["sel"] is int ? a["sel"] as int : a["sel"] as double);
      final bVal = currTangki == 0
          ? (b["tangki"] is int ? b["tangki"] as int : b["tangki"] as double)
          : (b["sel"] is int ? b["sel"] as int : b["sel"] as double);
      final aVal2 = (a["sel"] is int ? a["sel"] as int : a["sel"] as double);
      final bVal2 = (b["sel"] is int ? b["sel"] as int : b["sel"] as double);

      // print(
      //     "sel");
      int r = aVal.compareTo(bVal);

      if (r == 0) {
        r = aVal2.compareTo(bVal2);
      }

      return r;
    });
  }

  sortSelData({bool isSetState = true}) {
    if (dataNyataSortOrderList.isEmpty || dataNyataSortOrder.isEmpty) return;
    resetSelDataSort();
    (selData[int.tryParse(filterTangki.tangkiValue) ?? 0] as List<dynamic>)
        .sort((dynamic a, dynamic b) {
      final aVal = (a[dataNyataSortOrderList[0]
                  .toLowerCase()
                  .replaceAll("#", "")
                  .replaceAll("sel", "tangki")
                  .replaceAll("crossbar", "sel")] ??
              0) is int
          ? (a[dataNyataSortOrderList[0]
                  .toLowerCase()
                  .replaceAll("#", "")
                  .replaceAll("sel", "tangki")
                  .replaceAll("crossbar", "sel")] ??
              0) as int
          : (a[dataNyataSortOrderList[0]
                  .toLowerCase()
                  .replaceAll("#", "")
                  .replaceAll("sel", "tangki")
                  .replaceAll("crossbar", "sel")] ??
              0) as double;
      final bVal = (b[dataNyataSortOrderList[0]
                  .toLowerCase()
                  .replaceAll("#", "")
                  .replaceAll("sel", "tangki")
                  .replaceAll("crossbar", "sel")] ??
              0) is int
          ? (b[dataNyataSortOrderList[0]
                  .toLowerCase()
                  .replaceAll("#", "")
                  .replaceAll("sel", "tangki")
                  .replaceAll("crossbar", "sel")] ??
              0) as int
          : (b[dataNyataSortOrderList[0]
                  .toLowerCase()
                  .replaceAll("#", "")
                  .replaceAll("sel", "tangki")
                  .replaceAll("crossbar", "sel")] ??
              0) as double;

      // print("aVal: $aVal");

      int r = dataNyataSortOrder[dataNyataSortOrderList[0]]!
          ? bVal.compareTo(aVal)
          : aVal.compareTo(bVal);

      int i = 1;

      while (r == 0 &&
          dataNyataSortOrderList.length > 1 &&
          i < dataNyataSortOrderList.length) {
        if (i < dataNyataSortOrderList.length) {
          // final aVal = a[dataNyataSortOrderList[i]
          //         .toLowerCase()
          //         .replaceAll("#", "")
          //         .replaceAll("sel", "tangki")
          //         .replaceAll("crossbar", "sel")] ??
          //     0 as double;
          // final bVal = b[dataNyataSortOrderList[i]
          //         .toLowerCase()
          //         .replaceAll("#", "")
          //         .replaceAll("sel", "tangki")
          //         .replaceAll("crossbar", "sel")] ??
          //     0 as double;

          final aVal = (a[dataNyataSortOrderList[i]
                      .toLowerCase()
                      .replaceAll("#", "")
                      .replaceAll("sel", "tangki")
                      .replaceAll("crossbar", "sel")] ??
                  0) is int
              ? (a[dataNyataSortOrderList[i]
                      .toLowerCase()
                      .replaceAll("#", "")
                      .replaceAll("sel", "tangki")
                      .replaceAll("crossbar", "sel")] ??
                  0) as int
              : (a[dataNyataSortOrderList[i]
                      .toLowerCase()
                      .replaceAll("#", "")
                      .replaceAll("sel", "tangki")
                      .replaceAll("crossbar", "sel")] ??
                  0) as double;
          final bVal = (b[dataNyataSortOrderList[i]
                      .toLowerCase()
                      .replaceAll("#", "")
                      .replaceAll("sel", "tangki")
                      .replaceAll("crossbar", "sel")] ??
                  0) is int
              ? (b[dataNyataSortOrderList[i]
                      .toLowerCase()
                      .replaceAll("#", "")
                      .replaceAll("sel", "tangki")
                      .replaceAll("crossbar", "sel")] ??
                  0) as int
              : (b[dataNyataSortOrderList[i]
                      .toLowerCase()
                      .replaceAll("#", "")
                      .replaceAll("sel", "tangki")
                      .replaceAll("crossbar", "sel")] ??
                  0) as double;

          // print("aVal: $aVal");

          r = dataNyataSortOrder[dataNyataSortOrderList[i]]!
              ? bVal.compareTo(aVal)
              : aVal.compareTo(bVal);
        }

        i++;
      }

      return r;
    });
    if (mounted && isSetState) setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // mqtt!.onUpdate = (t, d) {};
    mqtt2.disconnect();
    mqtt2.dispose();
    timerRefreshDiagnostic.cancel();

    widget.scSel.dispose();

    // diagnosticData.clear();
    maxDdata.clear();
    tangkiMaxData.clear();

    // if (mqtt != null) {
    //   mqtt!.disconnect();
    // }
  }

  int currTangki = 0;

  initDiagnosticData() async {}

  initSelData() async {
    final api = ApiHelper();

    final r = await api.callAPI("/monitoring/find/last", "POST", "", true);

    if (kDebugMode) {
      print("backend data: $r");
    }

    if (r["error"] == null) {
      selData.clear();

      selData.add([
        {
          "tangki": 1,
          "sel": 1,
          "suhu": 0.0,
          "tegangan": 0.0,
          "arus": 0.0,
          "daya": 0.0,
          "energi": 0.0
        },
        {
          "tangki": 1,
          "sel": 2,
          "suhu": 0.0,
          "tegangan": 0.0,
          "arus": 0.0,
          "daya": 0.0,
          "energi": 0.0
        },
        {
          "tangki": 1,
          "sel": 3,
          "suhu": 0.0,
          "tegangan": 0.0,
          "arus": 0.0,
          "daya": 0.0,
          "energi": 0.0
        },
        {
          "tangki": 1,
          "sel": 4,
          "suhu": 0.0,
          "tegangan": 0.0,
          "arus": 0.0,
          "daya": 0.0,
          "energi": 0.0
        },
        {
          "tangki": 1,
          "sel": 5,
          "suhu": 0.0,
          "tegangan": 0.0,
          "arus": 0.0,
          "daya": 0.0,
          "energi": 0.0
        },
        {
          "tangki": 1,
          "sel": 6,
          "suhu": 0.0,
          "tegangan": 0.0,
          "arus": 0.0,
          "daya": 0.0,
          "energi": 0.0
        },
      ]);

      selData.addAll(r["data"][0]["tangkiData"] ?? []);
    }

    if (mounted) {
      setState(() {});
    }

    getMax();

    // getDiagnostiWidget(200);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {});
      getData(0);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        // setSetting("tegangan", 3);
        // setSetting("arus", 100);

        initMqtt();
      });
    });

    if (mounted) setState(() {});
  }

  bool isLoading = true;

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

      final data = r["data"][0] as Map<String, dynamic>;

      final listAlarmArus = data["listAlarmArus"] as List<dynamic>;
      final listAlarmTegangan = data["listAlarmTegangan"] as List<dynamic>;
      final listAlarmSuhu = (data["listAlarmSuhu"] ?? []) as List<dynamic>;
      final listAlarmPh = (data["listAlarmPh"] ?? []) as List<dynamic>;

      if (listAlarmArus.isNotEmpty) {
        alarm.firstWhere(
            (element) => element["title"] == "Alarm Arus")["isActive"] = true;
      }

      if (listAlarmTegangan.isNotEmpty) {
        alarm.firstWhere(
                (element) => element["title"] == "Alarm Tegangan")["isActive"] =
            true;
      }

      if (listAlarmSuhu.isNotEmpty) {
        alarm.firstWhere(
            (element) => element["title"] == "Alarm Suhu")["isActive"] = true;
      }

      if (listAlarmPh.isNotEmpty) {
        alarm.firstWhere(
            (element) => element["title"] == "Alarm pH")["isActive"] = true;
      }

      account_alarm.setState!();

      if (diagnosticData.length < 7) {
        diagnosticData.add(
          [
            {"sel": 1, "status": "inactive", "lastUpdated": 1706561733680},
          ],
        );
      }
    }

    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  initMqtt() {
    mqtt.onUpdate = (data, topic) {
      bool refresh = false;

      if (kDebugMode) {
        print("mqtt topic $topic");
      }

      if (topic == "antam/statusNode" || topic == "antam/statusnode") {
        int tangki = data["tangki"] as int;
        int sel = data["node"] as int;
        String status = data["status"] as String;
        int timeStamp = (data["timeStamp"] as int) * 1000;

        // DateFormat df = DateFormat("dd MMMM yyyy");

        // DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);

        diagnosticData[tangki - 1][sel - 1]["lastUpdated"] = timeStamp;

        if (diagnosticData[tangki - 1][sel - 1]["status"] != status
            // ||
            //     diagnosticData[tangki - 1][sel - 1]["lastUpdated"] != timeStamp
            ) {
          refresh = true;
          diagnosticData[tangki - 1][sel - 1]["status"] = status;
        }
      } else if (topic == "antam/device") {
        selData.clear();
        selData.add([
          {
            "tangki": 1,
            "sel": 1,
            "suhu": 0.0,
            "tegangan": 0.0,
            "arus": 0.0,
            "daya": 0.0,
            "energi": 0.0
          },
          {
            "tangki": 1,
            "sel": 2,
            "suhu": 0.0,
            "tegangan": 0.0,
            "arus": 0.0,
            "daya": 0.0,
            "energi": 0.0
          },
          {
            "tangki": 1,
            "sel": 3,
            "suhu": 0.0,
            "tegangan": 0.0,
            "arus": 0.0,
            "daya": 0.0,
            "energi": 0.0
          },
          {
            "tangki": 1,
            "sel": 4,
            "suhu": 0.0,
            "tegangan": 0.0,
            "arus": 0.0,
            "daya": 0.0,
            "energi": 0.0
          },
          {
            "tangki": 1,
            "sel": 5,
            "suhu": 0.0,
            "tegangan": 0.0,
            "arus": 0.0,
            "daya": 0.0,
            "energi": 0.0
          },
        ]);
        selData.addAll(data["tangkiData"]);

        getMax();

        // List<String> items = [];

        // items.add("Semua");

        // for (var i = 0; i < data["tangkiData"].length; i++) {
        //   items.add((i + 1).toString());
        // }

        // filterTangki = FilterTangki(
        //   tangkiValue: "Semua",
        //   items: items,
        //   onChange: (value) => getData(int.tryParse(value) ?? 0),
        // );

        getData(currTangki);
      } else if (topic == "antam/device/node") {
        final int tangki = data["tangki"] as int;

        final sData = Map.from(data["selData"] ?? {});

        resetSelDataSort();

        if (kDebugMode) {
          print((sData));
        }

        for (var i = 1; i < titleData.length; i++) {
          final title = titleData[i].toLowerCase();

          if (sData[title] != null &&
              selData[tangki][(data["sel"] as int) - 1][title] !=
                  sData[title]) {
            if (kDebugMode) {
              print(("data changed"));
            }
            refresh = true;
            selData[tangki][(data["sel"] as int) - 1][title] = sData[title];
          }
        }

        if (sData["pH"] != null) {
          refresh = true;
          selData[tangki][(data["sel"] as int) - 1]["pH"] =
              (sData["pH"] ?? 0.0);
        }

        getMax(isSetState: false);

        getData(currTangki, isSetState: false);
        sortSelData(isSetState: false);
      } else if (topic == "antam/status") {
        // print(data["alarmTegangang"]);

        alarm.firstWhere(
                (element) => element["title"] == "Status")["isActive"] =
            (data["status"] == null
                ? alarm
                    .where((element) => element["title"] == "Status")
                    .first["isActive"]!
                : (data["status"] as bool));

        alarm.firstWhere(
                (element) => element["title"] == "Alarm Arus")["isActive"] =
            (data["alarmArus"] == null
                ? alarm
                    .where((element) => element["title"] == "Alarm Arus")
                    .first["isActive"]!
                : (data["alarmArus"] as bool));

        alarm.firstWhere(
                (element) => element["title"] == "Alarm Tegangan")["isActive"] =
            (data["alarmTegangan"] == null
                ? alarm
                    .where((element) => element["title"] == "Alarm Tegangan")
                    .first["isActive"]!
                : (data["alarmTegangan"] as bool));
        alarm.firstWhere(
                (element) => element["title"] == "Alarm Suhu")["isActive"] =
            (data["alarmSuhu"] == null
                ? alarm
                    .where((element) => element["title"] == "Alarm Suhu")
                    .first["isActive"]!
                : (data["alarmSuhu"] as bool));
        alarm.firstWhere(
                (element) => element["title"] == "Alarm pH")["isActive"] =
            (data["alarmPh"] == null
                ? alarm
                    .where((element) => element["title"] == "Alarm pH")
                    .first["isActive"]!
                : (data["alarmPh"] as bool));

        // var temp = [
        //   {
        //     "title": "Status",
        //     "isActive": (data["status"] == null
        //         ? alarm
        //             .where((element) => element["title"] == "Status")
        //             .first["isActive"]!
        //         : (data["status"] as bool)),
        //   },
        //   {
        //     "title": "Alarm Arus",
        //     "isActive": data["alarmArus"] == null
        //         ? alarm
        //             .where((element) => element["title"] == "Alarm Arus")
        //             .first["isActive"]!
        //         : data["alarmArus"] as bool,
        //   },
        //   {
        //     "title": "Alarm Tegangan",
        //     "isActive": data["alarmTegangan"] == null
        //         ? alarm
        //             .where((element) => element["title"] == "Alarm Tegangan")
        //             .first["isActive"]!
        //         : data["alarmTegangan"] as bool,
        //   }
        // ];

        // alarm.clear();
        // alarm.addAll(temp);

        account_alarm.setState!();

        // temp.clear();
      } else if (topic == "antam/statistic") {
        if (totalData.firstWhere(
                    (element) => element["title"] == "Total Waktu")["value"] !=
                (data["totalWaktu"] ?? 0.0) ||
            totalData.firstWhere((element) =>
                    element["title"] == "Tegangan Total")["value"] !=
                (data["teganganTotal"] ?? 0.0) ||
            totalData.firstWhere(
                    (element) => element["title"] == "Arus Total")["value"] !=
                (data["arusTotal"] ?? 0) ||
            totalData.firstWhere(
                    (element) => element["title"] == "Power")["value"] !=
                (data["power"] ?? 0.0) ||
            totalData.firstWhere(
                    (element) => element["title"] == "Energi")["value"] !=
                (data["energi"] ?? 0.0)) {
          refresh = true;
        }

        totalData.firstWhere(
                (element) => element["title"] == "Total Waktu")["value"] =
            data["totalWaktu"] == null
                ? totalData
                    .where((element) => element["title"] == "Total Waktu")
                    .first["value"]!
                : (data["totalWaktu"] is double
                    ? (data["totalWaktu"] as double)
                    : (data["totalWaktu"] as int).toDouble());

        totalData.firstWhere(
                (element) => element["title"] == "Tegangan Total")["value"] =
            data["teganganTotal"] == null
                ? totalData
                    .where((element) => element["title"] == "Tegangan Total")
                    .first["value"]!
                : (data["teganganTotal"] is double
                    ? (data["teganganTotal"] as double)
                    : (data["teganganTotal"] as int).toDouble());

        totalData.firstWhere(
                (element) => element["title"] == "Arus Total")["value"] =
            data["arusTotal"] == null
                ? totalData
                    .where((element) => element["title"] == "Arus Total")
                    .first["value"]!
                : (data["arusTotal"] is double
                    ? (data["arusTotal"] as double)
                    : (data["arusTotal"] as int).toDouble());

        totalData
                .firstWhere((element) => element["title"] == "Power")["value"] =
            data["power"] == null
                ? totalData
                    .where((element) => element["title"] == "Power")
                    .first["value"]!
                : (data["power"] is double
                    ? (data["power"] as double)
                    : (data["power"] as int).toDouble());

        totalData.firstWhere(
                (element) => element["title"] == "Energi")["value"] =
            data["energi"] == null
                ? totalData
                    .where((element) => element["title"] == "Energi")
                    .first["value"]!
                : (data["energi"] is double
                    ? (data["energi"] as double)
                    : (data["energi"] as int).toDouble());

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

      // getTotal(currTangki);

      if (mounted && refresh) {
        setState(() {});
      }
    };
  }

  initTotalDataStatistic() async {
    ApiHelper api = ApiHelper();

    final r = await api.callAPI("/statistic/find/last", "POST", "", true);

    if (r["error"] == null) {
      final data = r["data"][0];

      if (kDebugMode) {
        print(data);
      }

      var temp = [
        {
          "id": 0,
          "title": "Total Waktu",
          "value": data["totalWaktu"] == null
              ? totalData
                  .where((element) => element["title"] == "Total Waktu")
                  .first["value"]!
              : (data["totalWaktu"] is double
                  ? (data["totalWaktu"] as double)
                  : (data["totalWaktu"] as int).toDouble()),
          "unit": "Jam"
        },
        {
          "id": 1,
          "title": "Tegangan Total",
          "value": data["teganganTotal"] == null
              ? totalData
                  .where((element) => element["title"] == "Tegangan Total")
                  .first["value"]!
              : (data["teganganTotal"] is double
                  ? (data["teganganTotal"] as double)
                  : (data["teganganTotal"] as int).toDouble()),
          "unit": "V"
        },
        {
          "id": 2,
          "title": "Arus Total",
          "value": data["arusTotal"] == null
              ? totalData
                  .where((element) => element["title"] == "Arus Total")
                  .first["value"]!
              : (data["arusTotal"] is double
                  ? (data["arusTotal"] as double)
                  : (data["arusTotal"] as int).toDouble()),
          "unit": "A"
        },
        {
          "id": 3,
          "title": "Daya",
          "value": data["power"] == null
              ? totalData
                  .where((element) => element["title"] == "Power")
                  .first["value"]!
              : (data["power"] is double
                  ? (data["power"] as double)
                  : (data["power"] as int).toDouble()),
          "unit": "W"
        },
        {
          "id": 4,
          "title": "Energi",
          "value": data["energi"] == null
              ? totalData
                  .where((element) => element["title"] == "Energi")
                  .first["value"]!
              : (data["energi"] is double
                  ? (data["energi"] as double)
                  : (data["energi"] as int).toDouble()),
          "unit": "kWh"
        },
      ];

      totalData.clear();
      totalData.addAll(temp);

      if (mounted) setState(() {});
    }
  }

  late Account_alarm account_alarm;
  late Timer timerRefreshDiagnostic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    timerRefreshDiagnostic = Timer(const Duration(minutes: 1), () {
      // getDiagnostiWidget(220);
      if (mounted) {
        setState(() {});
      }
    });

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

    account_alarm = Account_alarm(
      alarm: alarm,
      isAdmin: widget.isAdmin,
      isTv: true,
    );

    mqtt = widget.mqtt;
    mqtt2 = MyMqtt(onUpdate: (data, topic) {});

    selData = widget.selData;

    // getData(0);

    filterTangki = FilterTangki(
      tangkiValue: "Max",
      items: const ["Max", "1", "2", "3", "4", "5", "6"],
      onChange: (value) => getData(int.tryParse(value) ?? 0),
    );

    // getMax();
    initDiagData();
    initSelData();
    initTotalDataStatistic();
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;

    // if (kDebugMode) {
    //   print("width: $lWidth");
    // }

    return SizedBox(
      width: lWidth,
      height: lheight,
      child: Stack(
        children: [
          Container(
              clipBehavior: Clip.none,
              decoration: BoxDecoration(),
              padding: const EdgeInsets.fromLTRB(45, 30, 30, 10),
              width: lWidth,
              height: lheight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.scale(
                      scale: (lWidth / lheight) < wide ? 1.2 : 1,
                      origin: Offset((lWidth / lheight) < wide ? -610 : 0, 0),
                      child: account_alarm),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  MainStyle.sizedBoxH20,
                  // Transform.scale(
                  //   scale: (lWidth / lheight) < wide ? 1.2 : 1,
                  //   origin: Offset((lWidth / lheight) < wide ? -800 : 0,
                  //       (lWidth / lheight) < wide ? -50 : 0),
                  //   child: SizedBox(
                  //     width: (lWidth / lheight) < wide
                  //         ? 2200
                  //         : lWidth >= 1920
                  //             ? lWidth
                  //             : 1270,
                  //     child: Row(
                  //       // mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         filterTglDari,
                  //         // const SizedBox(
                  //         //   width: 10,
                  //         // ),
                  //         MainStyle.sizedBoxW10,
                  //         filterTglHingga,
                  //         // const SizedBox(
                  //         //   width: 10,
                  //         // ),
                  //         MainStyle.sizedBoxW10,
                  //         filterTangki
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // // const SizedBox(
                  // //   height: 20,
                  // // ),
                  // MainStyle.sizedBoxH20,
                  Expanded(
                    child: SizedBox(
                      width: lWidth,
                      child: Transform.scale(
                        scaleY: (lWidth / lheight) < wide
                            ? 1.2
                            : lWidth >= 1920
                                ? 1.13
                                : 1.11,
                        scaleX: (lWidth / lheight) < wide
                            ? 1.2
                            : lWidth >= 1920
                                ? 1.18
                                : 1.16, //set scale here
                        origin: Offset(
                            (lWidth / lheight) < wide
                                ? -1010
                                : lWidth >= 1920
                                    ? -1010
                                    : -600,
                            (lWidth / lheight) < wide ? -50 : 0),
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: (lWidth / lheight) < wide ? 1.25 : 1,
                              origin: Offset(
                                  (lWidth / lheight) < wide ? -500 : 0, 0),
                              child: Transform.translate(
                                offset: Offset(
                                    -20,
                                    lWidth >= 1920
                                        ? (lheight >= 1080 ? -45 : -15)
                                        : 0),
                                child: Container(
                                  clipBehavior: Clip.none,
                                  padding: const EdgeInsets.all(10),
                                  width: lheight / lWidth < wide
                                      ? 1280
                                      : lWidth <= 1920
                                          ? lWidth
                                          : lWidth - 300,
                                  height: 680,
                                  decoration: BoxDecoration(
                                      color: MainStyle.secondaryColor,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(4, 4),
                                            color: MainStyle.primaryColor
                                                .withAlpha(
                                                    (255 * 0.05).toInt()),
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
                                                .withAlpha(
                                                    (255 * 0.10).toInt()),
                                            blurRadius: 20,
                                            spreadRadius: 0),
                                      ]),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            // SvgPicture.asset(
                                            //   "assets/monitoring.svg",
                                            //   width: 30,
                                            //   color: MainStyle.primaryColor,
                                            // ),
                                            const Icon(
                                              Icons.lan,
                                              size: 30,
                                              color: MainStyle.primaryColor,
                                            ),
                                            // const SizedBox(
                                            //   width: 10,
                                            // ),
                                            MainStyle.sizedBoxW10,
                                            Text(
                                              "Diagnostic",
                                              style: MainStyle
                                                  .textStyleDefault20Primary,
                                            ),
                                            MainStyle.sizedBoxW20,
                                            Container(
                                              // width: 225,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                 border: Border.all(),
                                                  color:
                                                      MainStyle.secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      "Elektrolit",
                                                      style: MyTextStyle
                                                          .defaultFontCustom(
                                                              MainStyle
                                                                  .primaryColor,
                                                              14,
                                                              weight: FontWeight
                                                                  .w900),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: (diagnosticData[6][0]["status"]
                                                                          as String)
                                                                      .toLowerCase() ==
                                                                  "active"
                                                              ? MainStyle
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      (DateTime.now().millisecondsSinceEpoch -(diagnosticData[6][0]["lastUpdated"] as int)) > (60000 * 5)
                                                                          ? 0.5
                                                                          : 1)
                                                              : (diagnosticData[6][0]["status"]
                                                                          as String)
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          "alarm")
                                                                  ? (diagnosticData[6][0]["status"] as String).toLowerCase().contains("tegangan") ||
                                                                          (diagnosticData[6][0]["status"] as String).toLowerCase().contains("rendah")
                                                                      ? Colors.orange.withOpacity((DateTime.now().millisecondsSinceEpoch - (diagnosticData[6][0]["lastUpdated"] as int)) > (60000 * 5) ? 0.5 : 1)
                                                                      : Colors.red.withOpacity((DateTime.now().millisecondsSinceEpoch -(diagnosticData[6][0]["lastUpdated"] as int)) > (60000 * 5) ? 0.5 : 1)
                                                                  : MainStyle.thirdColor.withOpacity((DateTime.now().millisecondsSinceEpoch -(diagnosticData[6][0]["lastUpdated"] as int) )> (60000 * 5) ? 0.5 : 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Text(
                                                            "pH: ${(((selData[7][0]["pH"] ?? 0) / 1.0) as double).toStringAsFixed(2)} ",
                                                            style: MyTextStyle.defaultFontCustom(
                                                                (diagnosticData[6][0]["status"]
                                                                                as String)
                                                                            .toLowerCase() !=
                                                                        "inactive"
                                                                    ? Colors
                                                                        .white
                                                                    : MainStyle
                                                                        .primaryColor,
                                                                16)),
                                                      ),
                                                      MainStyle.sizedBoxW20,
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: (diagnosticData[6][0]["status"]
                                                                          as String)
                                                                      .toLowerCase() ==
                                                                  "active"
                                                              ? MainStyle
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      (DateTime.now().millisecondsSinceEpoch -(diagnosticData[6][0]["lastUpdated"] as int)) > (60000 * 5)
                                                                          ? 0.5
                                                                          : 1)
                                                              : (diagnosticData[6][0]["status"]
                                                                          as String)
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          "alarm")
                                                                  ? (diagnosticData[6][0]["status"] as String).toLowerCase().contains("tegangan") ||
                                                                          (diagnosticData[6][0]["status"] as String).toLowerCase().contains("rendah")
                                                                      ? Colors.orange.withOpacity((DateTime.now().millisecondsSinceEpoch -(diagnosticData[6][0]["lastUpdated"] as int)) > (60000 * 5) ? 0.5 : 1)
                                                                      : Colors.red.withOpacity((DateTime.now().millisecondsSinceEpoch -(diagnosticData[6][0]["lastUpdated"] as int)) > (60000 * 5) ? 0.5 : 1)
                                                                  : MainStyle.thirdColor.withOpacity((DateTime.now().millisecondsSinceEpoch -(diagnosticData[6][0]["lastUpdated"] as int)) > (60000 * 5) ? 0.5 : 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Text(
                                                          " Suhu: ${(((selData[7][0]["suhu"] ?? 0) / 1.0) as double).toStringAsFixed(0)} \u00B0C",
                                                          style: MyTextStyle.defaultFontCustom(
                                                              (diagnosticData[6][0]["status"]
                                                                              as String)
                                                                          .toLowerCase() !=
                                                                      "inactive"
                                                                  ? Colors.white
                                                                  : MainStyle
                                                                      .primaryColor,
                                                              16),
                                                        ),
                                                      ),
                                                      MainStyle.sizedBoxW5,
                                                      Text(lastUpdateElektrolit(), style: MyTextStyle.defaultFontCustom(MainStyle.primaryColor, 12),)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            // MyButton(
                                            //     color: MainStyle.primaryColor,
                                            //     text: "Matikan semua",
                                            //     onPressed: () =>
                                            //         promptToggle(15, 15, true),
                                            //     textColor: Colors.white),
                                            // MainStyle.sizedBoxW5,
                                            // MyButton(
                                            //     color: MainStyle.primaryColor,
                                            //     text: "Nyalakan semua",
                                            //     onPressed: () =>
                                            //         promptToggle(15, 15, false),
                                            //     textColor: Colors.white),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 510,
                                      child: Stack(
                                        children: [
                                          Column(
                                              children:
                                                  getDiagnostiWidget(220)),
                                          // Align(
                                          //   alignment: Alignment.bottomRight,
                                          //   child: SizedBox(
                                          //     width: 120,
                                          //     child: MyButton(
                                          //         color: MainStyle.primaryColor,
                                          //         text: "Reset energi",
                                          //         onPressed: () => promptToggle(
                                          //             15, 15, false,
                                          //             isResetEnergi: true),
                                          //         textColor: Colors.white),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),

                                    //Footer name
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: totalData
                                          .map((e) => Container(
                                                clipBehavior: Clip.none,
                                                decoration:
                                                    const BoxDecoration(),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      // width: 120,
                                                      child: Text(
                                                        e["title"] as String,
                                                        style: MyTextStyle
                                                            .defaultFontCustom(
                                                                Colors.black,
                                                                13,
                                                                weight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                    MainStyle.sizedBoxW10,
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      clipBehavior: Clip.none,
                                                      // width: 300,
                                                      height: 35,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            colors: grad_colors,
                                                            stops: [0, 0.6, 1],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        // boxShadow: [
                                                        //   BoxShadow(
                                                        //       color: MainStyle
                                                        //           .primaryColor
                                                        //           .withAlpha(
                                                        //               (255 * 0.15)
                                                        //                   .toInt()),
                                                        //       offset: Offset(0, 3),
                                                        //       blurRadius: 5,
                                                        //       spreadRadius: 0),
                                                        //   BoxShadow(
                                                        //       color: MainStyle
                                                        //           .primaryColor
                                                        //           .withAlpha(
                                                        //               (255 * 0.15)
                                                        //                   .toInt()),
                                                        //       offset: Offset(0, 3),
                                                        //       blurRadius: 30,
                                                        //       spreadRadius: 0)
                                                        // ]
                                                      ),

                                                      child: SizedBox(
                                                        width: 125,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          // mainAxisAlignment:
                                                          //     MainAxisAlignment
                                                          //         .spaceBetween,
                                                          children: [
                                                            Container(
                                                              // height: 30,
                                                              clipBehavior:
                                                                  Clip.none,
                                                              decoration:
                                                                  const BoxDecoration(),
                                                              width: 115,
                                                              child: Text(
                                                                // (e["id"] as int).toStringAsFixed(2)
                                                                generateValueData(e)
                                                                ,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: e['id'] as int == 0? MyTextStyle.defaultFontLight(MainStyle.primaryColor, 12.5) :  MyTextStyle
                                                                    .defaultFontCustomMono(
                                                                        MainStyle
                                                                            .primaryColor, 14),
                                                              ),
                                                            ),
                                                            // SizedBox(
                                                            //   width: 60,
                                                            //   child: Text(
                                                            //     e["unit"]
                                                            //         as String,
                                                            //     textAlign:
                                                            //         TextAlign
                                                            //             .right,
                                                            //     style: MyTextStyle
                                                            //         .defaultFontCustom(
                                                            //             Colors
                                                            //                 .black,
                                                            //             14,
                                                            //             weight:
                                                            //                 FontWeight.bold),
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    MainStyle.sizedBoxW20,
                                                    MainStyle.sizedBoxW10
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                    // PanelNode(
                                    //     tangki: 1,
                                    //     sel: 1,
                                    //     status: "active",
                                    //     lastUpdated: "12 dec")
                                  ]),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
