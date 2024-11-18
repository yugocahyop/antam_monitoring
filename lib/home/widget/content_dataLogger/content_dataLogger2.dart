import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:antam_monitoring/home/widget/account_alarm.dart';
import 'package:antam_monitoring/home/widget/content_dataLogger/tools/downloadFile.dart' if (dart.library.html)'package:antam_monitoring/home/widget/content_dataLogger/tools/downloadFileWeb.dart';
import 'package:antam_monitoring/home/widget/content_dataLogger/widget/panelTable.dart';
import 'package:antam_monitoring/home/widget/filterInterval.dart';
import 'package:antam_monitoring/home/widget/filterTangki.dart';
import 'package:antam_monitoring/home/widget/filterTgl.dart';
import 'package:antam_monitoring/home/widget/mobilePage/dataloggerMobile.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/tools/excel.dart';
import 'package:antam_monitoring/tools/mqtt/mqtt.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Content_dataLogger2 extends StatefulWidget {
  Content_dataLogger2(
      {super.key,
      this.dari,
      this.hingga,
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

  int? dari, hingga;

  static double progress = 0.0;

  static int fileNum = 0;
  static bool isCancel = false;
  static const int maxRowExcel = 1;

  @override
  State<Content_dataLogger2> createState() => _Content_dataLogger2State();
}

class _Content_dataLogger2State extends State<Content_dataLogger2> {
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

  var titleData = [
    "Sel",
    "#Crossbar",
    "Suhu",
    "Tegangan",
    "Arus",
    "Daya",
    "Energi"
  ];

  // final selScrollController = ScrollController();

  final List<dynamic> maxData = [
    {
      "sel": 1,
      "suhu": 0.0,
      "tegangan": 0.0,
      "arus": 0.0,
      "daya": 0.0,
      "energi": 0.0
    },
    {
      "sel": 2,
      "suhu": 0.0,
      "tegangan": 0.0,
      "arus": 0.0,
      "daya": 0.0,
      "energi": 0.0
    },
    {
      "sel": 3,
      "suhu": 0.0,
      "tegangan": 0.0,
      "arus": 0.0,
      "daya": 0.0,
      "energi": 0.0
    },
    {
      "sel": 4,
      "suhu": 0.0,
      "tegangan": 0.0,
      "arus": 0.0,
      "daya": 0.0,
      "energi": 0.0
    },
    {
      "sel": 5,
      "suhu": 0.0,
      "tegangan": 0.0,
      "arus": 0.0,
      "daya": 0.0,
      "energi": 0.0
    },
  ];

  List<dynamic> tangkiMaxData = [
    {"sel": 1, "suhu": 0, "tegangan": 0, "arus": 0, "daya": 0, "energi": 0},
    {"sel": 2, "suhu": 0, "tegangan": 0, "arus": 0, "daya": 0, "energi": 0},
    {"sel": 3, "suhu": 0, "tegangan": 0, "arus": 0, "daya": 0, "energi": 0},
    {"sel": 4, "suhu": 0, "tegangan": 0, "arus": 0, "daya": 0, "energi": 0},
    {"sel": 5, "suhu": 0, "tegangan": 0, "arus": 0, "daya": 0, "energi": 0},
  ];

  List<dynamic> selData = [
    [
      {},
    ],
  ];

  var totalData = [
    {"title": "Total Waktu", "value": 0.0, "unit": "jam"},
    {"title": "Tegangan Total", "value": 0.0, "unit": "volt"},
    {"title": "Arus Total", "value": 0.0, "unit": "ampere"},
    {"title": "Daya Total", "value": 0.0, "unit": "watt"},
    {"title": "Energi", "value": 0.0, "unit": "kWh"},
  ];

  var teganganSetting = [const FlSpot(0, 1), const FlSpot(6, 1)];

  var teganganData = [
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 0),
    const FlSpot(4, 0),
    const FlSpot(5, 0),
  ];

  var arusData = [
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 0),
    const FlSpot(4, 0),
    const FlSpot(5, 0),
  ];

  var arusSetting = [const FlSpot(0, 1), const FlSpot(6, 1)];

  final grad_colors = [
    MainStyle.primaryColor.withAlpha(((255 * 0.4) * 0.3).toInt()),
    MainStyle.primaryColor.withAlpha(((255 * 0.3) * 0.3).toInt()),
    MainStyle.primaryColor.withAlpha(((255 * 0.1) * 0.3).toInt()),
  ];

  String warningMsg = "Message";

  double msgOpacity = 0;

  bool isMsgVisible = false;

  final double wide = 16 / 9;

  late FilterTgl filterTglHingga;

  late FilterTgl filterTglDari;

  late FilterInterval filterInterval;

  filterChange() {
    // widget.changePage(1,
    //     dari: filterTglDari.today, hingga: filterTglHingga.today);
    dataLog.clear();

    //  if (offsetNum == 0) {
    offset = 0;
    // }
    getDataLog(0);

    // if (mounted) {
    //   setState(() {});
    // }
    // ;
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

  getData(int tangki) {
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

    for (var e in (tangki == 0 ? maxData : selData[tangki])) {
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

    if (mounted) setState(() {});
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

    if (mounted) {
      setState(() {});
    }
  }

  getMax() {
    for (var i = 1; i < selData.length; i++) {
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
        final index = v.indexOf(e);

        if (index < 5) {
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

          tangkiMaxData[index]["suhu"] =
              selData[0][index]["suhu"] == c ? i : tangkiMaxData[index]["suhu"];

          tangkiMaxData[index]["tegangan"] = selData[0][index]["tegangan"] == vv
              ? i
              : tangkiMaxData[index]["tegangan"];

          tangkiMaxData[index]["arus"] =
              selData[0][index]["arus"] == a ? i : tangkiMaxData[index]["arus"];

          tangkiMaxData[index]["daya"] =
              selData[0][index]["daya"] == w ? i : tangkiMaxData[index]["daya"];

          tangkiMaxData[index]["energi"] = selData[0][index]["energi"] == en
              ? i
              : tangkiMaxData[index]["energi"];
        }

        // count++;
      }

      // if (kDebugMode) {
      //   print("sel data 0 : ${selData[0][0].toString()}");
      // }
    }
  }

  getMax2() {
    // selData[0].clear();

    for (var x = 0; x < maxData.length; x++) {
      for (var i = 2; i < titleData.length; i++) {
        final title = titleData[i].toLowerCase();

        maxData[x][title] = 0;
      }
    }

    for (var i = 1; i < selData.length - 1; i++) {
      final v = selData[i];

      // int count = 1;

      final sel = (selData[0] as List<dynamic>);

      for (Map<String, dynamic> e in v) {
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

        // selData[0].add({
        //   "tangki": i.toDouble(),
        //   "sel": e["sel"] as double,
        //   "suhu": c,
        //   "tegangan": vv,
        //   "arus": a,
        //   "daya": w,
        //   "energi": en,
        // });

        (sel).firstWhere((element) =>
            element["tangki"] == i.toDouble() &&
            element["sel"] ==
                (e["sel"] is int
                    ? e["sel"] as int
                    : e["sel"] as double))["suhu"] = c;
        // }

        sel.firstWhere((element) =>
            element["tangki"] == i.toDouble() &&
            element["sel"] ==
                (e["sel"] is int
                    ? e["sel"] as int
                    : e["sel"] as double))["tegangan"] = vv;

        sel.firstWhere((element) =>
            element["tangki"] == i.toDouble() &&
            element["sel"] ==
                (e["sel"] is int
                    ? e["sel"] as int
                    : e["sel"] as double))["arus"] = a;

        sel.firstWhere((element) =>
            element["tangki"] == i.toDouble() &&
            element["sel"] ==
                (e["sel"] is int
                    ? e["sel"] as int
                    : e["sel"] as double))["daya"] = w;
        sel.firstWhere((element) =>
            element["tangki"] == i.toDouble() &&
            element["sel"] ==
                (e["sel"] is int
                    ? e["sel"] as int
                    : e["sel"] as double))["energi"] = en;

        //  e["celcius"] = (e["celcius"] as int) + 1;
        final index = v.indexOf(e);

        if (index < 5 && maxData.isNotEmpty) {
          maxData[index]["suhu"] = max(
              maxData[index]["suhu"] is int
                  ? (maxData[index]["suhu"] as int).toDouble()
                  : maxData[index]["suhu"] as double,
              c);
          maxData[index]["tegangan"] = max(
              maxData[index]["tegangan"] is int
                  ? (maxData[index]["tegangan"] as int).toDouble()
                  : maxData[index]["tegangan"] as double,
              vv);
          maxData[index]["arus"] = max(
              maxData[index]["arus"] is int
                  ? (maxData[index]["arus"] as int).toDouble()
                  : maxData[index]["arus"] as double,
              a);
          maxData[index]["daya"] = max(
              maxData[index]["daya"] is int
                  ? (maxData[index]["daya"] as int).toDouble()
                  : maxData[index]["daya"] as double,
              w);
          maxData[index]["energi"] = max(
              maxData[index]["energi"] is int
                  ? (maxData[index]["energi"] as int).toDouble()
                  : maxData[index]["energi"] as double,
              en);

          tangkiMaxData[index]["suhu"] =
              maxData[index]["suhu"] == c ? i : tangkiMaxData[index]["suhu"];

          tangkiMaxData[index]["tegangan"] = maxData[index]["tegangan"] == vv
              ? i
              : tangkiMaxData[index]["tegangan"];

          tangkiMaxData[index]["arus"] =
              maxData[index]["arus"] == a ? i : tangkiMaxData[index]["arus"];

          tangkiMaxData[index]["daya"] =
              maxData[index]["daya"] == w ? i : tangkiMaxData[index]["daya"];

          tangkiMaxData[index]["energi"] = maxData[index]["energi"] == en
              ? i
              : tangkiMaxData[index]["energi"];
        }

        // count++;
      }

      // if (kDebugMode) {
      //   print("sel data 0 : ${selData[0][0].toString()}");
      // }
    }

    if (mounted) setState(() {});
  }

  MyMqtt? mqtt;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // mqtt!.onUpdate = (json, topic) {};

    dataLog.clear();

    maxData.clear();
    tangkiMaxData.clear();

    widget.scSel.dispose();

    // if (mqtt != null) {
    //   mqtt!.disconnect();
    // }
  }

  int currTangki = 0;

  initSelData() async {
    final api = ApiHelper();

    while (ApiHelper.tokenMain.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
    }

    final r = await api.callAPI("/monitoring/find/last", "POST", "", true);

    if (kDebugMode) {
      print("backend data: $r");
    }

    if (r["error"] == null) {
      selData.clear();

      // selData.add([
      //   {
      //     "tangki": 1,
      //     "sel": 1,
      //     "suhu": 0.0,
      //     "tegangan": 0.0,
      //     "arus": 0.0,
      //     "daya": 0.0,
      //     "energi": 0.0
      //   },
      //   {
      //     "tangki": 1,
      //     "sel": 2,
      //     "suhu": 0.0,
      //     "tegangan": 0.0,
      //     "arus": 0.0,
      //     "daya": 0.0,
      //     "energi": 0.0
      //   },
      //   {
      //     "tangki": 1,
      //     "sel": 3,
      //     "suhu": 0.0,
      //     "tegangan": 0.0,
      //     "arus": 0.0,
      //     "daya": 0.0,
      //     "energi": 0.0
      //   },
      //   {
      //     "tangki": 1,
      //     "sel": 4,
      //     "suhu": 0.0,
      //     "tegangan": 0.0,
      //     "arus": 0.0,
      //     "daya": 0.0,
      //     "energi": 0.0
      //   },
      //   {
      //     "tangki": 1,
      //     "sel": 5,
      //     "suhu": 0.0,
      //     "tegangan": 0.0,
      //     "arus": 0.0,
      //     "daya": 0.0,
      //     "energi": 0.0
      //   },
      // ]);

      List<dynamic> listTangkiZero = [];

      for (var x = 1; x < 8; x++) {
        for (var i = 1; i < 6; i++) {
          listTangkiZero.add({
            "tangki": x,
            "sel": i,
            "suhu": 0.0,
            "tegangan": 0.0,
            "arus": 0.0,
            "daya": 0.0,
            "energi": 0.0
          });
        }
      }

      selData.add(listTangkiZero);

      selData.addAll(r["data"][0]["tangkiData"] ?? []);
    }

    if (mounted) {
      setState(() {});
    }

    getMax2();

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {});
      getData(0);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        setSetting("tegangan", 3);
        setSetting("arus", 100);

        initMqtt();
      });
    });

    if (mounted) {
      setState(() {});
    }
  }

  initStatus() async {
    final api = ApiHelper();

    while (ApiHelper.tokenMain.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
    }

    final r = await api.callAPI("/diagnostic/find/last", "POST", "", true);

    if (kDebugMode) {
      print("backend data: $r");
    }

    if (r["error"] == null) {
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
    }

    if (mounted) setState(() {});
  }

  initMqtt() {
    mqtt!.onUpdate = (data, topic) {
      bool refresh = false;
      if (kDebugMode) {
        print("mqtt topic $topic");
      }
      if (topic == "antam/device/node") {
        // selData.clear();
        // // selData.add([]);
        // selData.add([
        //   {
        //     "tangki": 1,
        //     "sel": 1,
        //     "suhu": 0.0,
        //     "tegangan": 0.0,
        //     "arus": 0.0,
        //     "daya": 0.0,
        //     "energi": 0.0
        //   },
        //   {
        //     "tangki": 1,
        //     "sel": 2,
        //     "suhu": 0.0,
        //     "tegangan": 0.0,
        //     "arus": 0.0,
        //     "daya": 0.0,
        //     "energi": 0.0
        //   },
        //   {
        //     "tangki": 1,
        //     "sel": 3,
        //     "suhu": 0.0,
        //     "tegangan": 0.0,
        //     "arus": 0.0,
        //     "daya": 0.0,
        //     "energi": 0.0
        //   },
        //   {
        //     "tangki": 1,
        //     "sel": 4,
        //     "suhu": 0.0,
        //     "tegangan": 0.0,
        //     "arus": 0.0,
        //     "daya": 0.0,
        //     "energi": 0.0
        //   },
        //   {
        //     "tangki": 1,
        //     "sel": 5,
        //     "suhu": 0.0,
        //     "tegangan": 0.0,
        //     "arus": 0.0,
        //     "daya": 0.0,
        //     "energi": 0.0
        //   },
        // ]);
        // selData.addAll(data["tangkiData"]);

        // getMax2();

        // getData(currTangki);

        // sortSelData();

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
      }
      //  else if (topic == "antam/device/node") {
      //   final int tangki = data["tangki"] as int;

      //   // if(tangki == currTangki || )

      //   final sData = Map.from(data["selData"]);
      //   resetSelDataSort();

      //   if (kDebugMode) {
      //     print((sData));
      //   }

      //   for (var i = 2; i < titleData.length; i++) {
      //     final title = titleData[i].toLowerCase();

      //     selData[tangki][(data["sel"] as int) - 1][title] = sData[title];
      //   }

      //   getMax2();

      //   getData(currTangki);
      //   sortSelData();

      //   // List<String> items = [];

      //   // items.add("Semua");

      //   // for (var i = 0; i < selData.length; i++) {
      //   //   items.add((i + 1).toString());
      //   // }

      //   // filterTangki = FilterTangki(
      //   //   tangkiValue: currTangki.toString(),
      //   //   items: items,
      //   //   onChange: (value) => getData(int.tryParse(value) ?? 0),
      //   // );

      //   // getTotal(currPage, currTangki);
      // }
      else if (topic == "antam/status") {
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
                (data["arusTotal"] ?? 0.0) ||
            totalData.firstWhere(
                    (element) => element["title"] == "Daya Total")["value"] !=
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
                .firstWhere((element) => element["title"] == "Daya Total")["value"] =
            data["power"] == null
                ? totalData
                    .where((element) => element["title"] == "Daya Total")
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
        //     "title": "Daya Total",
        //     "value": data["power"] == null
        //         ? totalData
        //             .where((element) => element["title"] == "Daya Total")
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

  Map<String, bool> dataNyataSortOrder = {};
  List<String> dataNyataSortOrderList = [];

  initTotalDataStatistic() async {
    ApiHelper api = ApiHelper();

    while (ApiHelper.tokenMain.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
    }

    final r = await api.callAPI("/statistic/find/last", "POST", "", true);

    if (r["error"] == null) {
      final data = r["data"][0];

      if (kDebugMode) {
        print(data);
      }

      var temp = [
        {
          "title": "Total Waktu",
          "value": data["totalWaktu"] == null
              ? totalData
                  .where((element) => element["title"] == "Total Waktu")
                  .first["value"]!
              : (data["totalWaktu"] is double
                  ? (data["totalWaktu"] as double)
                  : (data["totalWaktu"] as int).toDouble()),
          "unit": "jam"
        },
        {
          "title": "Tegangan Total",
          "value": data["teganganTotal"] == null
              ? totalData
                  .where((element) => element["title"] == "Tegangan Total")
                  .first["value"]!
              : (data["teganganTotal"] is double
                  ? (data["teganganTotal"] as double)
                  : (data["teganganTotal"] as int).toDouble()),
          "unit": "volt"
        },
        {
          "title": "Arus Total",
          "value": data["arusTotal"] == null
              ? totalData
                  .where((element) => element["title"] == "Arus Total")
                  .first["value"]!
              : (data["arusTotal"] is double
                  ? (data["arusTotal"] as double)
                  : (data["arusTotal"] as int).toDouble()),
          "unit": "ampere"
        },
        {
          "title": "Daya Total",
          "value": data["power"] == null
              ? totalData
                  .where((element) => element["title"] == "Daya Total")
                  .first["value"]!
              : (data["power"] is double
                  ? (data["power"] as double)
                  : (data["power"] as int).toDouble()),
          "unit": "watt"
        },
        {
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

      if (mounted) {
        setState(() {});
      }
    }
  }

  List<Map<String, dynamic>> dataLog = [
    // {
    //   "isClicked": false,
    //   "isHover": false,
    //   "msg": "",
    //   "timeStamp_server": 1706561733680,
    //   "tangkiData": [[]]
    // }
  ];

  // List<dynamic> tempSelData = [
  //   [{}]
  // ];

  String dataDate = "";

  int indexData = -1;

  bool isTapped = false;

  changeData(int index) async {
    // if (index == indexData) return;

    if (isTapped) {
      setState(() {
        isTapped = false;
      });

      await Future.delayed(const Duration(milliseconds: 300));
    }

    setState(() {
      isTapped = true;
    });
    resetSelDataSort();

    indexData = index;
    // tempSelData = selData;
    selData.clear();
    // selData.add([[]]);
    // selData = dataLog[index]["tangkiData"];

    List<dynamic> listTangkiZero = [];

    for (var x = 1; x < 8; x++) {
      for (var i = 1; i < 6; i++) {
        listTangkiZero.add({
          "tangki": x,
          "sel": i,
          "suhu": 0.0,
          "tegangan": 0.0,
          "arus": 0.0,
          "daya": 0.0,
          "energi": 0.0
        });
      }
    }

    selData.add(listTangkiZero);

    selData.addAll(dataLog[index]["tangkiData"] as List<dynamic>);

    // selData.insert(0, [
    //   {
    //     "tangki": 1,
    //     "sel": 1,
    //     "suhu": 0.0,
    //     "tegangan": 0.0,
    //     "arus": 0.0,
    //     "daya": 0.0,
    //     "energi": 0.0
    //   },
    //   {
    //     "tangki": 1,
    //     "sel": 2,
    //     "suhu": 0.0,
    //     "tegangan": 0.0,
    //     "arus": 0.0,
    //     "daya": 0.0,
    //     "energi": 0.0
    //   },
    //   {
    //     "tangki": 1,
    //     "sel": 3,
    //     "suhu": 0.0,
    //     "tegangan": 0.0,
    //     "arus": 0.0,
    //     "daya": 0.0,
    //     "energi": 0.0
    //   },
    //   {
    //     "tangki": 1,
    //     "sel": 4,
    //     "suhu": 0.0,
    //     "tegangan": 0.0,
    //     "arus": 0.0,
    //     "daya": 0.0,
    //     "energi": 0.0
    //   },
    //   {
    //     "tangki": 1,
    //     "sel": 5,
    //     "suhu": 0.0,
    //     "tegangan": 0.0,
    //     "arus": 0.0,
    //     "daya": 0.0,
    //     "energi": 0.0
    //   },
    // ]);

    final df = DateFormat("dd/MM/yyy HH:mm:ss");

    dataDate = df.format(DateTime.fromMillisecondsSinceEpoch(
        dataLog[index]["timeStamp_server"]));

    getMax2();
    getData(currTangki);
    sortSelData();

    if (mounted) {
      setState(() {});
    }
  }

  // bool stopLoadmore = false;
  Future<bool> loadMore() async {
    // if (stopLoadmore) {
    //   return false;
    // }

    // isLoadmore = true;
    // offset += dataNum;

    // if (offset > maxDataNum) {
    offset = dataLog.length;
    // }

    await getDataLog(offset);

    // isLoadmore = false;

    return true;
  }

  int offset = 0;
  int dataNum = 20;
  int maxDataNum = 40;
  bool isAlarm = false;

  changeIsAlarm(bool isAlarm2) async {
    isAlarm = isAlarm2;

    offset = 0;

    // print("change isAlarm");

    dataLog.clear();

    await getDataLog(0);

    setState(() {
      isTapped = false;
    });
  }

  bool isLoading = false;

  Future<void> getDataLog2(int offsetNum) async {
    // if (!setFilter) {
    //   setState(() {
    //     isLoading = true;
    //   });
    // }

    // await Future.delayed(const Duration(milliseconds: 1000));

    final api = ApiHelper();

    // while (ApiHelper.tokenMain == null) {
    //   await Future.delayed(const Duration(seconds: 1));
    // }

    // print("is alarm: $isAlarm");

    final r = await api.callAPI(
        "/${isAlarm ? "alarm" : "monitoring"}/find?limit=$dataNum&offset=$offsetNum",
        "POST",
        jsonEncode({"from": filterTglDari.today, "to": filterTglHingga.today}),
        true);

    if (r["error"] == null) {
      if (isAlarm) {
        if (kDebugMode) {
          print("alarm r: $r");
        }
      }
      List<dynamic> data = r['data'] as List<dynamic>;

      maxDataNum = r["count"];
      // if (mounted) setState(() {});

      if (kDebugMode) {
        print("backend data2:  $data");
      }

      if (offset == 0) dataLog.clear();

      for (var i = 0; i < data.length; i++) {
        final val = data[i];

        String msg = "";

        if (isAlarm) {
          final String status = val["status"];
          if (status == "alarm") {
            msg =
                ("Terjadi masalah pada sel ${val["tangki"]} - ${val["node"]}");
          } else {
            msg =
                ("${status.contains("Rendah") ? "Minimum" : "Maksimum"} ${status.replaceAll("alarm", "").replaceAll("Tinggi", "").replaceAll("Rendah", "")} telah di lewati pada sel ${val["tangki"]} - ${val["node"]}");
          }
        }

        dataLog.add({
          "isClicked": false,
          "isHover": false,
          "timeStamp_server": val["timeStamp_server"],
          "msg": isAlarm ? msg : "",
          "tangkiData": isAlarm ? null : val["tangkiData"] as List<dynamic>
        });
      }

      // if (mounted) setState(() {});
    } else {
      if (kDebugMode) {
        print("error : ${r["error"]}");
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> downloadBackend()async{

    
    final api = ApiHelper();

    PanelTable.maxDataNumDownload = 1;
    Content_dataLogger2.fileNum =1;
    Content_dataLogger2.progress = 0.001;

    setState(() {
      
    });

    final r = await api.callAPI(
        "/monitoring/prepare",
        "POST",
        jsonEncode({"from": filterTglDari.today, "to": filterTglHingga.today, "sel": currTangki, "intervalT": filterInterval.interval}),
        true);

    if(r["file"] != null){
      // final Uri url = Uri.parse('http://${ApiHelper.url}:7003/monitoring/download?file=${r["file"]}');
      // final Uri url = Uri.parse('http://${ApiHelper.url}:7003/static/${r["file"]}');
      // launchUrl(url);

      if(kIsWeb){
        // final data = await api.callAPIBytes("/monitoring/download?file=${r["file"]}", "GET", "",true);
         
        downloadFile('http://${ApiHelper.url}:7003/static/${r["file"]}', r["file"]);
      }else{
        final Uri url = Uri.parse('http://${ApiHelper.url}:7003/static/${r["file"]}');
        launchUrl(url);
      }
    }

PanelTable.maxDataNumDownload = 1;
     Content_dataLogger2.fileNum =1;
    Content_dataLogger2.progress = 0;

    setState(() {
      
    });

    // final dio = Dio();
    // dio.options.headers["authorization"] = "Bearer ${ApiHelper.tokenMain}";

    // final response = await dio.download("http://${ApiHelper.url}:7003/monitoring/download?file=antam-monitoring-2024-08-27_00-00-00_to_2024-08-27_01-00-00-all.xlsx", (await getTemporaryDirectory())!.path + "excel.xlsx" );

    

  }

  Future<void> download() async {
    // if (!setFilter) {

    // if (dataLog.isEmpty) return;

    // stopLoadmore = true;

    // offset = 0;

    // maxDataNum = 40;

    // dataLog.clear();

    if (mounted) {
      setState(() {
        // isLoading = true;
        Content_dataLogger2.progress = 0.000001;
      });
    }

    final dariTgl = filterTglDari.today;

    final hinggaTgl = filterTglHingga.today;

    // isAlarm = false;

    if (dataLog.isEmpty) {
      await getDataLog(0);
    }

    List<String> header = ["Tanggal"];

    final dataLog0 = dataLog[0]["tangkiData"] as List<dynamic>;

    for (var i = (currTangki == 0 ? 0 : currTangki - 1);
        i < (currTangki == 0 ? 6 : currTangki);
        i++) {
      final dataList = dataLog0[i] as List<dynamic>;

      // if (kDebugMode) {
      //   print("dataList: $dataList");
      // }

      for (var ii = 0; ii < dataList.length; ii++) {
        final val = dataList[ii];

        // listTite

        for (var iii = 2; iii < titleData.length; iii++) {
          header.add("Sel ${i + 1} - ${val["sel"]} ${titleData[iii]}");
        }
      }
    }

    header.add("Sel Elektrolit suhu");

    header.add("Sel Elektrolit pH");

    // if (kDebugMode) {
    //   print("header $header");
    // }

    // dataNum = 200;

    MyExcel ex = MyExcel();

    Excel excel = ex.create();

    bool isPopulate = false;

    List<Map<String, dynamic>> dataLog2 = [];

    int offset = 0, offset2 = 0, dataNum = 200, maxDataNum2 = maxDataNum;

    while ((offset + dataLog2.length) < maxDataNum2) {
      if (Content_dataLogger2.isCancel) {
        Content_dataLogger2.isCancel = false;
        Content_dataLogger2.progress = 0;
        if (mounted) {
          setState(() {});
        }

        return;
      }

      if (!isPopulate) {
        isPopulate = true;
        await ex.populate(excel, header, ["data monitoring"], listAny: dataLog);

        Content_dataLogger2.progress = (offset + dataLog.length) / maxDataNum2;

        Content_dataLogger2.fileNum =
            (maxDataNum2 / Content_dataLogger2.maxRowExcel).ceil();

        if (mounted) {
          setState(() {
            // isLoading = true;
            // Content_dataLogger2.progress = 0.1;
          });
        }
      } else {
        if (dataLog2.isEmpty) {
          break;
        }
        Sheet sheetObject = excel["data monitoring"];

        if (sheetObject.rows.length >= Content_dataLogger2.maxRowExcel) {
          final tempExcel = excel;
          await ex.save(tempExcel, "antam_monitoring");

          excel = ex.create();

          offset2 = 0;

          await ex.populate(excel, header, ["data monitoring"],
              listAny: dataLog2);
        } else {
          await ex.append(excel, header, ["data monitoring"], offset2,
              listAny: dataLog2);
        }

        Content_dataLogger2.progress = (offset + dataLog2.length) / maxDataNum2;

        if (mounted) {
          setState(() {
            // isLoading = true;
            // Content_dataLogger2.progress = 0.1;
          });
        }
      }
      // await loadMore();

      offset += (dataLog2.isEmpty ? dataLog.length : dataLog2.length);
      offset2 += (dataLog2.isEmpty ? dataLog.length : dataLog2.length);

      dataLog2.clear();

      final api = ApiHelper();

      final r = await api.callAPI(
          "/${isAlarm ? "alarm" : "monitoring"}/find?offset=$offset&limit=$dataNum",
          "POST",
          jsonEncode({"from": dariTgl, "to": hinggaTgl}),
          true);

      if (r["error"] == null) {
        List<dynamic> data = r['data'] as List<dynamic>;

        maxDataNum2 = r["count"];

        for (var i = 0; i < data.length; i++) {
          final val = data[i];

          dataLog2.add({
            "isClicked": false,
            "isHover": false,
            "timeStamp_server": val["timeStamp_server"],
            "msg": "",
            "tangkiData": (val["tangkiData"] ?? []) as List<dynamic>
          });
        }
      }

      // await Future.delayed(const Duration(microseconds: 1));
      // if (kDebugMode) {
      //   print("dataLog: ${dataLog.length}");
      // }
    }

    // dataNum = 20;

    // offset = dataLog.length;

    await ex.save(excel, "antam_monitoring");

    Content_dataLogger2.progress = 0;

    if (mounted) {
      setState(() {
        // isLoading = false;
        // Content_dataLogger2.progress = 0;
        // stopLoadmore = false;
      });
    }
  }

  Future<void> download2() async {
    // if (!setFilter) {

    // if (dataLog.isEmpty) return;

    // stopLoadmore = true;

    // offset = 0;

    // maxDataNum = 40;

    // dataLog.clear();

    if (mounted) {
      setState(() {
        // isLoading = true;
        Content_dataLogger2.progress = 0.000001;
      });
    }

    final dariTgl = filterTglDari.today;

    final hinggaTgl = filterTglHingga.today;

    // isAlarm = false;

    if (dataLog.isEmpty) {
      await getDataLog(0);
    }

    List<String> header = ["Tanggal"];

    final dataLog0 = dataLog[0]["tangkiData"] as List<dynamic>;

    for (var i = (currTangki == 0 ? 0 : currTangki - 1);
        i < (currTangki == 0 ? 6 : currTangki);
        i++) {
      final dataList = dataLog0[i] as List<dynamic>;

      // if (kDebugMode) {
      //   print("dataList: $dataList");
      // }

      for (var ii = 0; ii < dataList.length; ii++) {
        final val = dataList[ii];

        // listTite

        for (var iii = 2; iii < titleData.length; iii++) {
          header.add("Sel ${i + 1} - ${val["sel"]} ${titleData[iii]}");
        }
      }
    }

    header.add("Sel Elektrolit suhu");

    header.add("Sel Elektrolit pH");

    // if (kDebugMode) {
    //   print("header $header");
    // }

    // dataNum = 200;

    MyExcel ex = MyExcel();

    Excel excel = ex.create();

    bool isPopulate = false;

    List<Map<String, dynamic>> dataLog2 = [], dataFilter = [];

    List<double> fSuhu = [0, 0, 0, 0, 0, 0, 0],
        fArus = [0, 0, 0, 0, 0, 0, 0],
        fTegangan = [0, 0, 0, 0, 0, 0, 0],
        fDaya = [0, 0, 0, 0, 0, 0, 0],
        fEnergi = [0, 0, 0, 0, 0, 0, 0];

    int offset = 0,
        offset2 = 0,
        dataNum = 200,
        maxDataNum2 = maxDataNum,
        timeStampFilter = 0;

    while ((offset + dataLog2.length) < maxDataNum2) {
      if (Content_dataLogger2.isCancel) {
        Content_dataLogger2.isCancel = false;
        Content_dataLogger2.progress = 0;
        if (mounted) {
          setState(() {});
        }

        return;
      }

      if (!isPopulate) {
        isPopulate = true;
        await ex.populate(excel, header, ["data monitoring"], listAny: dataLog);

        Content_dataLogger2.progress = (offset + dataLog.length) / maxDataNum2;

        Content_dataLogger2.fileNum =
            (maxDataNum2 / Content_dataLogger2.maxRowExcel).ceil();

        if (mounted) {
          setState(() {
            // isLoading = true;
            // Content_dataLogger2.progress = 0.1;
          });
        }
      } else {
        if (dataLog2.isEmpty) {
          break;
        }
        Sheet sheetObject = excel["data monitoring"];

        if (sheetObject.rows.length >= Content_dataLogger2.maxRowExcel) {
          final tempExcel = excel;
          await ex.save(tempExcel, "antam_monitoring");

          excel = ex.create();

          offset2 = 0;

          await ex.populate(excel, header, ["data monitoring"],
              listAny: dataLog2);
        } else {
          if (dataLog2.last["timeStamp_server"] >= timeStampFilter) {
            timeStampFilter = 0;

            final data = dataFilter.last["tangkiData"] as List<dynamic>;

            for (var i = 0; i < data.length; i++) {
              final sel = data[i] as List<dynamic>;
              for (var ii = 0; ii < sel.length; ii++) {
                final tangki = sel[ii];

                // tangki["suhu"] = f;
                // tangki["arus"] = (dataLog2.reduce((value, element) =>
                //     value["tangkiData"][i][ii]["arus"] +
                //     element["tangkiData"][i][ii]["arus"]));
                // tangki["tegangan"] = (dataLog2.reduce((value, element) =>
                //     value["tangkiData"][i][ii]["tegangan"] +
                //     element["tangkiData"][i][ii]["tegangan"]));
                // tangki["daya"] = (dataLog2.reduce((value, element) =>
                //     value["tangkiData"][i][ii]["daya"] +
                //     element["tangkiData"][i][ii]["daya"]));
                // tangki["energi"] = (dataLog2.reduce((value, element) =>
                //         value["tangkiData"][i][ii]["energi"] +
                //         element["tangkiData"][i][ii]["energi"])) /
                //     dataLog2.length;
              }
            }

            await ex.append(excel, header, ["data monitoring"], offset2,
                listAny: dataFilter);
          } else {
            final data = dataLog0.last["tangkiData"] as List<dynamic>;

            for (var i = 0; i < data.length; i++) {
              final sel = data[i] as List<dynamic>;
              for (var ii = 0; ii < sel.length; ii++) {
                final tangki = sel[ii];

                // tangki["suhu"] = f;
                // tangki["arus"] = (dataLog2.reduce((value, element) =>
                //     value["tangkiData"][i][ii]["arus"] +
                //     element["tangkiData"][i][ii]["arus"]));
                // tangki["tegangan"] = (dataLog2.reduce((value, element) =>
                //     value["tangkiData"][i][ii]["tegangan"] +
                //     element["tangkiData"][i][ii]["tegangan"]));
                // tangki["daya"] = (dataLog2.reduce((value, element) =>
                //     value["tangkiData"][i][ii]["daya"] +
                //     element["tangkiData"][i][ii]["daya"]));
                // tangki["energi"] = (dataLog2.reduce((value, element) =>
                //         value["tangkiData"][i][ii]["energi"] +
                //         element["tangkiData"][i][ii]["energi"])) /
                //     dataLog2.length;
              }
            }
            for (var i = 0; i < data.length; i++) {
              final sel = data[i] as List<dynamic>;
              for (var ii = 0; ii < sel.length; ii++) {
                final tangki = sel[ii];

                // tangki["suhu"] = f;
                // tangki["arus"] = (dataLog2.reduce((value, element) =>
                //     value["tangkiData"][i][ii]["arus"] +
                //     element["tangkiData"][i][ii]["arus"]));
                // tangki["tegangan"] = (dataLog2.reduce((value, element) =>
                //     value["tangkiData"][i][ii]["tegangan"] +
                //     element["tangkiData"][i][ii]["tegangan"]));
                // tangki["daya"] = (dataLog2.reduce((value, element) =>
                //     value["tangkiData"][i][ii]["daya"] +
                //     element["tangkiData"][i][ii]["daya"]));
                // tangki["energi"] = (dataLog2.reduce((value, element) =>
                //         value["tangkiData"][i][ii]["energi"] +
                //         element["tangkiData"][i][ii]["energi"])) /
                //     dataLog2.length;
              }
            }
          }
        }

        Content_dataLogger2.progress = (offset + dataLog2.length) / maxDataNum2;

        if (mounted) {
          setState(() {
            // isLoading = true;
            // Content_dataLogger2.progress = 0.1;
          });
        }
      }
      // await loadMore();

      offset += (dataLog2.isEmpty ? dataLog.length : dataLog2.length);
      offset2 += (dataLog2.isEmpty ? dataLog.length : dataLog2.length);

      dataLog2.clear();

      final api = ApiHelper();

      final r = await api.callAPI(
          "/${isAlarm ? "alarm" : "monitoring"}/find?offset=$offset&limit=$dataNum",
          "POST",
          jsonEncode({"from": dariTgl, "to": hinggaTgl}),
          true);

      if (r["error"] == null) {
        List<dynamic> data = r['data'] as List<dynamic>;

        maxDataNum2 = r["count"];

        for (var i = 0; i < data.length; i++) {
          final val = data[i];

          dataLog2.add({
            "isClicked": false,
            "isHover": false,
            "timeStamp_server": val["timeStamp_server"],
            "msg": "",
            "tangkiData": (val["tangkiData"] ?? []) as List<dynamic>
          });

          if (i == 0 && timeStampFilter == 0) {
            timeStampFilter =
                dataLog2.last["timeStamp_server"] + (60000 * 60 * 2);
            dataFilter.add({
              "isClicked": false,
              "isHover": false,
              "timeStamp_server": val["timeStamp_server"],
              "msg": "",
              "tangkiData": (val["tangkiData"] ?? []) as List<dynamic>
            });
          }
        }
      }

      // await Future.delayed(const Duration(microseconds: 1));
      // if (kDebugMode) {
      //   print("dataLog: ${dataLog.length}");
      // }
    }

    // dataNum = 20;

    // offset = dataLog.length;

    await ex.save(excel, "antam_monitoring");

    Content_dataLogger2.progress = 0;

    if (mounted) {
      setState(() {
        // isLoading = false;
        // Content_dataLogger2.progress = 0;
        // stopLoadmore = false;
      });
    }
  }

  int offsetTime = 0;

  Future<void> getDataLog(int offsetNum,
      {bool setFilter = false, bool islimit = true}) async {
    // if (!setFilter) {
    if(filterTglDari.today == 0 && filterTglHingga.today == 0){
      return;
    }
    
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    // }

    // await Future.delayed(const Duration(milliseconds: 1000));

    final api = ApiHelper();

    // while (ApiHelper.tokenMain == null) {
    //   await Future.delayed(const Duration(seconds: 1));
    // }

    // print("is alarm: $isAlarm");

    if(offsetNum == 0){
      maxDataNum = 20;
      offsetTime =0 ;
    }

    

    final r = await api.callAPI(
        "/${isAlarm ? "alarm" : "monitoring"}/find${!islimit ? "" : "?offset=$offsetNum&limit=$dataNum"}",
        "POST",
        jsonEncode({"from": filterTglDari.today, "to": filterTglHingga.today, "interval": filterInterval.interval, "offsetTime": offsetTime}),
        true);

    if (r["error"] == null) {
      // if (isAlarm) {
        if (kDebugMode) {
          print("data r: $r");
        }
      // }
      List<dynamic> data = r['data'] as List<dynamic>;

      maxDataNum = r["count"];
      offsetTime = r["intervalOffset"] ?? 0;

      if (mounted) setState(() {});

      // if (kDebugMode) {
      //   print("backend data2:  $data");
      // }

      if (offsetNum == 0){ 
        // offsetTime = 0;
        dataLog.clear();
      }

      for (var i = 0; i < data.length; i++) {
        final val = data[i];

        String msg = "";

        if (isAlarm) {
          final String status = val["status"] ?? "";
          if (status == "alarm") {
            msg =
                ("Terjadi masalah pada sel ${val["tangki"]} - ${val["node"]}");
          } else {
            msg =
                ("${status.contains("Rendah") ? "Minimum" : "Maksimum"} ${status.replaceAll("alarm", "").replaceAll("Tinggi", "").replaceAll("Rendah", "")} telah di lewati pada sel ${val["tangki"]} - ${val["node"]}");
          }
        }

        dataLog.add({
          "isClicked": false,
          "isHover": false,
          "timeStamp_server": val["timeStamp_server"],
          "msg": isAlarm ? msg : "",
          "isStart": val["isStart"],
          "tangkiData":
              isAlarm ? [] : (val["tangkiData"] ?? []) as List<dynamic>
        });
      }

      // offset = dataLog.length;

      if (mounted) setState(() {});
    } else {
      if (kDebugMode) {
        print("error : ${r["error"]}");
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  late Account_alarm account_alarm;

  double progress = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (Content_dataLogger2.progress > 0) {
      progress = Content_dataLogger2.progress;
      Timer.periodic(const Duration(seconds: 1), ((timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (progress != Content_dataLogger2.progress) {
          if (mounted) {
            setState(() {});
          }

          progress = Content_dataLogger2.progress;
        }
        if (Content_dataLogger2.progress == 0) {
          progress = 0;
          timer.cancel();
        }
      }));
    }

    if (kDebugMode) {
      print("dari: ${widget.dari} hingga: ${widget.hingga}");
    }

    filterTglHingga = FilterTgl(
      title: "Hingga",
      lastValue: true,
      today: widget.hingga ?? 0,
      changePage: () => filterChange(),
    );

    filterTglDari = FilterTgl(
      title: "Dari",
      lastValue: false,
      today: widget.dari ?? 0,
      changePage: () => filterChange(),
    );

    filterInterval  = FilterInterval(onChange: ()=> filterChange());

    account_alarm = Account_alarm(alarm: alarm, isAdmin: widget.isAdmin);

    mqtt = widget.mqtt;

    selData = widget.selData;

    selData[0].clear();
    for (var x = 1; x < 8; x++) {
      for (var i = 1; i < 6; i++) {
        selData[0].add({
          "tangki": x,
          "sel": i,
          "suhu": 0.0,
          "tegangan": 0.0,
          "arus": 0.0,
          "daya": 0.0,
          "energi": 0.0
        });
      }
    }

    getMax2();

    // getData(0);

    filterTangki = FilterTangki(
      tangkiValue: "Semua",
      items: ["Semua", "1", "2", "3", "4", "5", "6"],
      onChange: (value) => getData(int.tryParse(value) ?? 0),
    );

    // getMax();

    initStatus();
    initSelData();
    initTotalDataStatistic();

     if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    Future.delayed(const Duration(milliseconds: 1000), (){
      getDataLog(0);
    });
  }

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

      if (a["tangki"] == 7 || b["tangki"] == 7) {
        return 0;
      }

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
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: (lWidth / lheight) < wide
          ? 1800
          : lWidth >= 1920
              ? lWidth - 300
              : 1270,
      height: (lWidth / lheight) < wide
          ? 1400
          : lWidth >= 1920
              ? lheight
              : 750,
      child: Stack(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(45, 30, 30, 10),
              width: (lWidth / lheight) < wide
                  ? 2200
                  : lWidth >= 1920
                      ? lWidth
                      : 1270,
              height: (lWidth / lheight) < wide
                  ? 1400
                  : lWidth >= 1920
                      ? lheight
                      : 750,
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
                  Transform.scale(
                    scale: (lWidth / lheight) < wide ? 1.2 : 1,
                    origin: Offset((lWidth / lheight) < wide ? -800 : 0,
                        (lWidth / lheight) < wide ? -50 : 0),
                    child: SizedBox(
                      width: (lWidth / lheight) < wide
                          ? 2200
                          : lWidth >= 1920
                              ? lWidth
                              : 1270,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          filterTglDari,
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          MainStyle.sizedBoxW10,
                          filterTglHingga,
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          MainStyle.sizedBoxW10,
                          filterInterval,
                          MainStyle.sizedBoxW10,
                          filterTangki
                        ],
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  MainStyle.sizedBoxH20,
                  Expanded(
                    child: SizedBox(
                      width: (lWidth / lheight) < wide
                          ? 2200
                          : lWidth >= 1920
                              ? lWidth + 500
                              : 1270,
                      child: Transform.scale(
                        scale: (lWidth / lheight) < wide
                            ? 1.2
                            : lWidth >= 1920
                                ? 1.1
                                : 1,
                        origin: Offset(
                            (lWidth / lheight) < wide
                                ? -1010
                                : lWidth >= 1920
                                    ? -1010
                                    : 0,
                            (lWidth / lheight) < wide ? -50 : 0),
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: (lWidth / lheight) < wide ? 1.25 : 1,
                              origin: Offset(
                                  (lWidth / lheight) < wide ? -150 : 0, 0),
                              child: Transform.translate(
                                  offset: Offset(
                                      0,
                                      lWidth >= 1920
                                          ? (lheight >= 1080 ? -45 : -15)
                                          : 0),
                                  child: PanelTable(
                                    fileNum: Content_dataLogger2.fileNum,
                                    progress: Content_dataLogger2.progress,
                                    download: () => downloadBackend(),
                                    isLoading: isLoading,
                                    changeIsAlarm: changeIsAlarm,
                                    max: maxDataNum,
                                    loadmore: loadMore,
                                    dataLog: dataLog,
                                    onTap: ((index) => changeData(index)),
                                  )),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Transform.scale(
                              scale: (lWidth / lheight) < wide ? 1.30 : 1,
                              origin: Offset(
                                  (lWidth / lheight) < wide ? -590 : 0,
                                  (lWidth / lheight) < wide ? -1400 : 0),
                              child: Transform.translate(
                                offset: Offset(
                                    0,
                                    lWidth >= 1920
                                        ? (lheight >= 1080 ? 100 : 90)
                                        : 0),
                                child: Column(
                                  children: [
                                    AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      opacity: isTapped ? 1 : 0.4,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        width: 650,
                                        height: 320,
                                        decoration: BoxDecoration(
                                            color: MainStyle.secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(30),
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
                                                  color: Colors.white.withAlpha(
                                                      (255 * 0.5).toInt()),
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
                                          // Row(
                                          //   children: [
                                          //     SvgPicture.asset(
                                          //       "assets/dataNyata.svg",
                                          //       width: 30,
                                          //       color: MainStyle.primaryColor,
                                          //     ),
                                          //     // const SizedBox(
                                          //     //   width: 10,
                                          //     // ),
                                          //     MainStyle.sizedBoxW10,
                                          //     Text(
                                          //       "Data Nyata $dataDate",
                                          //       style: MainStyle
                                          //           .textStyleDefault20Primary,
                                          //     )
                                          //   ],
                                          // ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/dataNyata.svg",
                                                    width: 30,
                                                    color:
                                                        MainStyle.primaryColor,
                                                  ),
                                                  // const SizedBox(
                                                  //   width: 10,
                                                  // ),
                                                  MainStyle.sizedBoxW10,
                                                  Text(
                                                    "Data Nyata $dataDate",
                                                    style: MainStyle
                                                        .textStyleDefault20Primary,
                                                  )
                                                ],
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    bottom: 5,
                                                    left: 8,
                                                    right: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: MainStyle.thirdColor,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Elektrolit",
                                                      style: MainStyle
                                                          .textStyleDefault15BlackBold,
                                                    ),
                                                    Text(
                                                      "pH: ${(((selData[7][0]["pH"] ?? 0) / 1.0) as double).toStringAsFixed(2)}   Suhu: ${(((selData[7][0]["suhu"] ?? 0) / 1.0) as double).toStringAsFixed(0)}\u00B0 C",
                                                      style: MainStyle
                                                          .textStyleDefault14Black,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          // const SizedBox(
                                          //   height: 20,
                                          // ),
                                          MainStyle.sizedBoxH20,
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: MainStyle
                                                          .primaryColor
                                                          .withAlpha(
                                                              (255 * 0.15)
                                                                  .toInt()),
                                                      offset:
                                                          const Offset(0, 3),
                                                      blurRadius: 5,
                                                      spreadRadius: 0),
                                                  BoxShadow(
                                                      color: MainStyle
                                                          .primaryColor
                                                          .withAlpha(
                                                              (255 * 0.15)
                                                                  .toInt()),
                                                      offset:
                                                          const Offset(0, 3),
                                                      blurRadius: 30,
                                                      spreadRadius: 0)
                                                ]),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  width: 600,
                                                  decoration: const BoxDecoration(
                                                      color: MainStyle
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(4),
                                                              topRight: Radius
                                                                  .circular(
                                                                      4))),
                                                  child: Row(
                                                    children: titleData
                                                        .map((e) => Visibility(
                                                              visible: e !=
                                                                      "Sel" ||
                                                                  (e == "Sel" &&
                                                                      currTangki ==
                                                                          0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  if (dataNyataSortOrder
                                                                      .containsKey(
                                                                          e)) {
                                                                    if (dataNyataSortOrder[
                                                                        e]!) {
                                                                      dataNyataSortOrder[
                                                                              e] =
                                                                          !dataNyataSortOrder[
                                                                              e]!;
                                                                    } else {
                                                                      dataNyataSortOrder
                                                                          .remove(
                                                                              e);
                                                                      dataNyataSortOrderList
                                                                          .remove(
                                                                              e);

                                                                      if (dataNyataSortOrder
                                                                          .isEmpty) {
                                                                        resetSelDataSort();

                                                                        if (mounted) {
                                                                          setState(
                                                                              () {});
                                                                        }

                                                                        return;
                                                                      } else {
                                                                        sortSelData();
                                                                      }
                                                                    }
                                                                  } else {
                                                                    dataNyataSortOrderList
                                                                        .add(e);
                                                                    dataNyataSortOrder
                                                                        .putIfAbsent(
                                                                            e,
                                                                            () =>
                                                                                true);
                                                                  }

                                                                  sortSelData();
                                                                  // setState(() {});
                                                                },
                                                                child: SizedBox(
                                                                  width:
                                                                      currTangki ==
                                                                              0
                                                                          ? 82
                                                                          : 90,
                                                                  child: Center(
                                                                    child: Row(
                                                                      // crossAxisAlignment:
                                                                      //     CrossAxisAlignment
                                                                      //         .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          e,
                                                                          style:
                                                                              MainStyle.textStyleDefault15White,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              3,
                                                                        ),
                                                                        Stack(
                                                                          children: [
                                                                            Center(
                                                                              child: Visibility(
                                                                                visible: dataNyataSortOrder.containsKey(e) ? !dataNyataSortOrder[e]! : false,
                                                                                child: Transform.translate(
                                                                                  offset: const Offset(0, -2),
                                                                                  child: const Icon(Icons.arrow_drop_up, size: 13, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Center(
                                                                              child: Visibility(
                                                                                visible: dataNyataSortOrder.containsKey(e) ? dataNyataSortOrder[e]! : false,
                                                                                child: Transform.translate(
                                                                                  offset: const Offset(0, 2),
                                                                                  child: const Icon(Icons.arrow_drop_down, size: 13, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                  ),
                                                ),
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    width: 600,
                                                    height: 200,
                                                    decoration: const BoxDecoration(
                                                        color: MainStyle
                                                            .thirdColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        4),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            4))),
                                                    child: Scrollbar(
                                                      thumbVisibility: true,
                                                      controller: widget.scSel,
                                                      child: ListView.builder(
                                                          controller:
                                                              widget.scSel,
                                                          itemCount: currTangki ==
                                                                  0
                                                              ? 30
                                                              : selData[int.tryParse(
                                                                          filterTangki
                                                                              .tangkiValue) ??
                                                                      0]
                                                                  .length,
                                                          itemBuilder:
                                                              (context, i) {
                                                            final val = selData[
                                                                int.tryParse(
                                                                        filterTangki
                                                                            .tangkiValue) ??
                                                                    0][i];

                                                            List<Widget>
                                                                listSel = [];
                                                            // List<Widget>
                                                            //     listTangki = [];
                                                            val.forEach((key, value) => key ==
                                                                    "sel"
                                                                ? listSel
                                                                    .insert(
                                                                        currTangki ==
                                                                                0
                                                                            ? 1
                                                                            : 0,
                                                                        SizedBox(
                                                                          width: currTangki == 0
                                                                              ? 82
                                                                              : 90,
                                                                          height:
                                                                              35,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              (value / 1 as double).toStringAsFixed((key == "sel") ? 0 : 2) + (key == "suhu" || key == "celcius" ? "\u00B0" : ""),
                                                                              style: MainStyle.textStyleDefault16Black,
                                                                            ),
                                                                          ),
                                                                        ))
                                                                : listSel.add(
                                                                    SizedBox(
                                                                    width:
                                                                        currTangki ==
                                                                                0
                                                                            ? 82
                                                                            : 90,
                                                                    height: 35,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        ((value / 1) as double).toStringAsFixed(key == "tangki" || key == "arus" || key =="suhu"
                                                                                ? 0
                                                                                : 2) +
                                                                            (key == "suhu" || key == "celcius"
                                                                                ? "\u00B0"
                                                                                : ""),
                                                                        style: MainStyle
                                                                            .textStyleDefault16Black,
                                                                      ),
                                                                    ),
                                                                  )));

                                                            // tangkiMaxData[i]
                                                            //     .forEach((key,
                                                            //             value) =>
                                                            //         listTangki.add(
                                                            //             SizedBox(
                                                            //           width: 90,
                                                            //           // height: 35,
                                                            //           child:
                                                            //               Center(
                                                            //             child:
                                                            //                 Visibility(
                                                            //               visible:
                                                            //                   key !=
                                                            //                       "sel",
                                                            //               child:
                                                            //                   Container(
                                                            //                 width:
                                                            //                     80,
                                                            //                 padding:
                                                            //                     EdgeInsets.all(2),
                                                            //                 decoration: BoxDecoration(
                                                            //                     color: MainStyle.secondaryColor,
                                                            //                     borderRadius: BorderRadius.circular(5)),
                                                            //                 child:
                                                            //                     Text(
                                                            //                   "tangki " +
                                                            //                       (value as int).toString(),
                                                            //                   style: MyTextStyle.defaultFontCustom(MainStyle.primaryColor,
                                                            //                       12,
                                                            //                       weight: FontWeight.w600),
                                                            //                   textAlign:
                                                            //                       TextAlign.center,
                                                            //                 ),
                                                            //               ),
                                                            //             ),
                                                            //           ),
                                                            //         )));

                                                            // listSel.add();

                                                            return Column(
                                                              children: [
                                                                Row(
                                                                    children:
                                                                        listSel),
                                                                const SizedBox(
                                                                  width: 600,
                                                                  child: Stack(
                                                                    children: [
                                                                      Divider(
                                                                        color: Color(
                                                                            0xff9ACBC7),
                                                                      ),
                                                                      // Visibility(
                                                                      //   visible:
                                                                      //       currTangki ==
                                                                      //           0,
                                                                      //   child:
                                                                      //       Row(
                                                                      //     children:
                                                                      //         listTangki,
                                                                      //   ),
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          }),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 13,
                                    ),
                                    Container(
                                      clipBehavior: Clip.none,
                                      padding: const EdgeInsets.all(10),
                                      width: 650,
                                      height: 250,
                                      decoration: BoxDecoration(
                                          color: MainStyle.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                                color: Colors.white.withAlpha(
                                                    (255 * 0.5).toInt()),
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
                                      child: Column(
                                        children: totalData
                                            .map((e) => Container(
                                                  clipBehavior: Clip.none,
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 200,
                                                        child: Text(
                                                          e["title"] as String,
                                                          style: MainStyle
                                                              .textStyleDefault15BlackBold,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 10),
                                                        clipBehavior: Clip.none,
                                                        // width: 300,
                                                        height: 35,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors:
                                                                  grad_colors,
                                                              stops: [
                                                                0,
                                                                0.6,
                                                                1
                                                              ],
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
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              height: 30,
                                                              clipBehavior:
                                                                  Clip.none,
                                                              decoration:
                                                                  const BoxDecoration(),
                                                              width: 300,
                                                              child: Transform
                                                                  .translate(
                                                                offset: Offset(
                                                                    0, -3),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Text(
                                                                      (e["value"]
                                                                              as double)
                                                                          .toStringAsFixed(
                                                                            (e["title"] == "Daya Total" || e["title"] == "Arus Total" ) ? 0:  2) ,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      style: MainStyle
                                                                          .textStyleDefault25Primary,
                                                                    ),
                                                                   (e["title"] == "Daya Total" || e["title"] == "Arus Total" ) ? Opacity(
                                                                      opacity: 0,
                                                                      child: Text(
                                                                       "000" ,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .right,
                                                                        style: MainStyle
                                                                            .textStyleDefault25Primary,
                                                                      ),
                                                                    ) : SizedBox(width: 0,),
                                                                  ],
                                                                  
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 15),
                                                              width: 100,
                                                              child: Text(
                                                                e["unit"]
                                                                    as String,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: MainStyle
                                                                    .textStyleDefault15BlackBold,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Center(
            //warning
            child: Transform.scale(
              scale: (lWidth / lheight) < wide ? 1.4 : 1,
              origin: Offset((lWidth / lheight) < wide ? 700 : 0, 0),
              child: Visibility(
                visible: isMsgVisible,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: msgOpacity,
                  onEnd: () {
                    if (msgOpacity == 0) {
                      if (mounted) {
                        setState(() {
                          isMsgVisible = false;
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 30),
                    width: 700,
                    height: 500,
                    decoration: BoxDecoration(
                        color: const Color(0xffFEF7F1),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          const BoxShadow(
                              blurRadius: 30,
                              color: Colors.black26,
                              offset: Offset(0, 20))
                        ]),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 20,
                            height: 400,
                            decoration: const BoxDecoration(
                              color: Color(0xffDF7B00),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  bottomRight: Radius.circular(50)),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.info_rounded,
                                    color: Color(0xffDF7B00),
                                    size: 50,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Warning Message",
                                    style:
                                        MainStyle.textStyleDefault20BlackBold,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 300,
                                width: 600,
                                child: Center(
                                  child: Text(
                                    warningMsg,
                                    textAlign: TextAlign.center,
                                    style:
                                        MainStyle.textStyleDefault40BlackBold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 600,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: MyButton(
                                      width: 100,
                                      color: const Color(0xffFCECDA),
                                      text: "Dismiss",
                                      onPressed: () {
                                        if (mounted) {
                                          setState(() {
                                            msgOpacity = 0;
                                          });
                                        }
                                      },
                                      textColor: const Color(0xffDF7B00)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
