import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:antam_monitoring/home/widget/account_alarm.dart';
import 'package:antam_monitoring/home/widget/content_dataLogger/content_dataLogger2.dart';
import 'package:antam_monitoring/home/widget/content_dataLogger/widget/panelTable.dart';
import 'package:antam_monitoring/home/widget/filterInterval.dart';
import 'package:antam_monitoring/home/widget/filterTangki.dart';
import 'package:antam_monitoring/home/widget/filterTgl.dart';
import 'package:antam_monitoring/home/widget/myDropDown.dart';
import 'package:antam_monitoring/home/widget/up.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/tools/excel.dart';
import 'package:antam_monitoring/tools/mqtt/mqtt.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:excel/excel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:antam_monitoring/home/widget/content_dataLogger/tools/downloadFile.dart' if (dart.library.html)'package:antam_monitoring/home/widget/content_dataLogger/tools/downloadFileWeb.dart';

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

class DataLogger extends StatefulWidget {
  DataLogger(
      {super.key,
      required this.dari,
      required this.hingga,
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

  int dari, hingga;

  ScrollController scSel;
  List<Map<String, dynamic>> menuItem;

  @override
  State<DataLogger> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<DataLogger> {
  // final MyTextStyle MyTextStyle = const MyTextStyle();

  String sortBy = "Pilih", ascDesc = "Desc";
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

  // var titleData = ["#Sel", "Celcius", "Volt", "Ampere"];

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
  final pc = PageController(
    initialPage: 0,
    viewportFraction: 0.85,
  );

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
    {"title": "Total Waktu", "value": 0.0, "unit": "Jam"},
    {"title": "Tegangan Total", "value": 0.0, "unit": "Volt"},
    {"title": "Arus Total", "value": 0.0, "unit": "Ampere"},
    {"title": "Power", "value": 0.0, "unit": "Watt"},
    {"title": "Energi", "value": 0.0, "unit": "Watt_Jam"},
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

  int currPage = 0;

  late FilterTangki filterTangki;

  late FilterTgl filterTglHingga;

  late FilterTgl filterTglDari;

  late FilterInterval filterInterval;

  filterChange() {
    dataLog.clear();

    //  if (offsetNum == 0) {
    offset = 0;
    // dataLog.clear();
    getDataLog(0);
  }

  getTotal(int value, int tangki) {
    currPage = value;
    // final d = (selData[tangki] as List<dynamic>)
    //     .where((d) =>
    //         ((d["sel"] is double)
    //             ? (d["sel"] as double).toInt()
    //             : (d["sel"] as int)) ==
    //         (value + 1))
    //     .first;

    // totalData
    //         .where((element) => element["title"] == "Tegangan Total")
    //         .first["value"] =
    //     d["volt"] is double
    //         ? d["volt"] as double
    //         : (d["volt"] as int).toDouble();
    // totalData
    //         .where((element) => element["title"] == "Arus Total")
    //         .first["value"] =
    //     d["ampere"] is double
    //         ? d["ampere"] as double
    //         : (d["ampere"] as int).toDouble();
    setState(() {});
  }

  getData(int tangki) {
    currTangki = tangki;
    pc.jumpTo(0);
    teganganData = [];

    arusData = [];

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

    // if (pc.page != null) {
    getTotal(currPage, tangki);
    sortSelData();
    // }

    if (mounted) setState(() {});
  }

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

  getMax2() {
    // selData[0].clear();
    for (var x = 0; x < maxData.length; x++) {
      for (var i = 2; i < titleData.length; i++) {
        final title = titleData[i].toLowerCase();

        maxData[x][title] = 0.0;
      }
    }

    for (var i = 1; i < selData.length - 1; i++) {
      final v = selData[i];

      // int count = 1;

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

        final sel = (selData[0] as List<dynamic>);

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

        if (index < 5) {
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

  getMax() {
    for (var i = 1; i < selData.length; i++) {
      final v = selData[i];
      for (var e in v) {
        final c = (e["suhu"] ?? e["celcius"]) as double;
        final vv = (e["tegangan"] ?? e["volt"]) as double;
        final a = (e["arus"] ?? e["ampere"]) as double;
        final w = (e["daya"] ?? e["watt"] ?? 0) as double;
        final en = (e["energi"] ?? e["kwh"] ?? 0) as double;
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
      }

      // if (kDebugMode) {
      //   print("sel data 0 : ${selData[0][0].toString()}");
      // }
    }
  }

  late MyMqtt mqtt;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    mqtt.disconnect();

    widget.scSel.dispose();
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

    if (mounted) setState(() {});

    getMax2();

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (mounted) setState(() {});
      getData(0);

      Future.delayed(const Duration(milliseconds: 300), () {
        setSetting("tegangan", 3);
        setSetting("arus", 100);
        initMqtt();
      });
    });
  }

  initMqtt() {
    mqtt.onUpdate = (data, topic) {
      bool refresh = false;
      if (topic == "antam/device") {
        selData.clear();
        // final firstData = List.of(maxDdata);
        selData.add([
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
        ]);
        selData.addAll(data["tangkiData"]);

        getMax2();

        // List<String> items = [];

        // items.add("Semua");

        // for (var i = 0; i < data["tangkiData"].length; i++) {
        //   items.add((i + 1).toString());
        // }

        // filterTangki = FilterTangki(
        //   tangkiValue: currTangki.toString(),
        //   items: items,
        //   onChange: (value) => getData(int.tryParse(value) ?? 0),
        // );

        getData(currTangki);

        // getTotal(currPage, currTangki);
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

        account_alarm.setState!();

        // alarm.clear();
        // alarm.addAll(temp);

        // temp.clear();
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

      if (mounted && refresh) {
        setState(() {});
      }

      // Future.delayed(Duration(milliseconds: 500), () {

      // });
    };
  }

  late Account_alarm account_alarm;

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
          "unit": "Jam"
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
          "unit": "Volt"
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
          "unit": "Ampere"
        },
        {
          "title": "Power",
          "value": data["power"] == null
              ? totalData
                  .where((element) => element["title"] == "Power")
                  .first["value"]!
              : (data["power"] is double
                  ? (data["power"] as double)
                  : (data["power"] as int).toDouble()),
          "unit": "Watt"
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
          "unit": "Watt_Jam"
        },
      ];

      totalData.clear();
      totalData.addAll(temp);

      if (mounted) setState(() {});
    }
  }

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

    filterTglHingga = FilterTgl(
      title: "Hingga",
      lastValue: true,
      today: widget.hingga,
      changePage: () => filterChange(),
    );

    filterTglDari = FilterTgl(
      title: "Dari",
      lastValue: false,
      today: widget.dari,
      changePage: () => filterChange(),
    );

    filterInterval = FilterInterval(
      onChange: ()=> filterChange(),
    );

    account_alarm = Account_alarm(alarm: alarm, isAdmin: widget.isAdmin);

    mqtt = widget.mqtt;

    selData = widget.selData;

    // getData(0);

    filterTangki = FilterTangki(
      tangkiValue: "Semua",
      items: ["Semua", "1", "2", "3", "4", "5", "6"],
      onChange: (value) => getData(int.tryParse(value) ?? 0),
    );

    // if (kDebugMode) {
    //   print("sel length: ${selData.length}");
    // }

    mqtt = MyMqtt(onUpdate: (data, topic) {});

    isLoading = true;

    offset = 0;

    // print("change isAlarm");

    dataLog.clear();

    setState(() {});

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        initStatus();
        // initSelData();

        // initTotalDataStatistic();
        if (kDebugMode) {
          print("timed ");
        }
        getDataLog(0);
      }
    });

    // getMax2();
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

  resetSelDataSort() {
    (selData[int.tryParse(filterTangki.tangkiValue) ?? 0] as List<dynamic>)
        .sort((dynamic a, dynamic b) {
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
    if (sortBy == "Pilih") return;
    resetSelDataSort();
    (selData[int.tryParse(filterTangki.tangkiValue) ?? 0] as List<dynamic>)
        .sort((dynamic a, dynamic b) {
      final aVal = (a[sortBy.toLowerCase()] ?? 0) is int
          ? (a[sortBy.toLowerCase()] ?? 0) as int
          : (a[sortBy.toLowerCase()] ?? 0) as double;
      final bVal = (b[sortBy.toLowerCase()] ?? 0) is int
          ? (b[sortBy.toLowerCase()] ?? 0) as int
          : (b[sortBy.toLowerCase()] ?? 0) as double;

      // print("aVal: $aVal bBal: $bVal");

      if (a["tangki"] == 7 || b["tangki"] == 7) {
        return 0;
      }

      int r = ascDesc == "Desc" ? bVal.compareTo(aVal) : aVal.compareTo(bVal);

      return r;
    });
    if (mounted && isSetState) setState(() {});
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

  bool isAlarm = false, isTapped = false;

  int maxDataNum = 20, offset = 0;

  Future<void> changeIsAlarm(bool isAlarm2) async {
    isAlarm = isAlarm2;

    offset = 0;

    // print("change isAlarm");

    dataLog.clear();

    await getDataLog(0);

    setState(() {
      isTapped = false;
    });
  }

  bool isLoading = true, isFirstLoading = true;
  int dataNum = 20;

  var progress = 0.0;

  int fileNum = 0;

  Future<void> downloadBackend()async{

    
    final api = ApiHelper();

    PanelTable.maxDataNumDownload = 1;
    Content_dataLogger2.fileNum =1;
    Content_dataLogger2.progress = 0.001;

    setState(() {
      
    });

    final r = await api.callAPINoTimeout(
        "/monitoring/prepare",
        "POST",
        jsonEncode({"from": filterTglDari.today, "to": filterTglHingga.today, "sel": currTangki, "intervalT": filterInterval.interval}),
        true);

    if(r["file"] != null){
      // final Uri url = Uri.parse('http://${ApiHelper.url}:7003/monitoring/download?file=${r["file"]}');
      // final Uri url = Uri.parse('http://${ApiHelper.url}:7003/static/${r["file"]}');
      // launchUrl(url);

      if(kIsWeb){
        final data = await api.callAPIBytes("/monitoring/download?file=${r["file"]}", "GET", "",true);
         
        // downloadFile('http://${ApiHelper.url}:7003/static/${r["file"]}', r["file"]);
        downloadFile(data, r["file"]);
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

    // await changeIsAlarm(false);

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

        if (sheetObject.rows.length > Content_dataLogger2.maxRowExcel) {
          await ex.save(excel, "antam_monitoring");

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
            "tangkiData": val["tangkiData"] as List<dynamic>
          });
        }
      }

      // await Future.delayed(const Duration(microseconds: 1));
      // if (kDebugMode) {
      //   print("dataLog: ${dataLog.length}");
      // }
    }

    dataNum = 20;

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

  Future<bool> loadMore() async {
    if (isFirstLoading) return false;
    offset += dataNum;

    await getDataLog(offset);

    return true;
  }

  Future<void> getDataLog(int offsetNum, {bool setFilter = false}) async {
    // if (!setFilter) {
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

    if (kDebugMode) {
      print(
          "hingga: ${filterTglHingga.today} now: ${DateTime.now().millisecondsSinceEpoch < filterTglHingga.today}");
    }

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
      if (mounted) setState(() {});

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
           "isStart": val["isStart"],
          "tangkiData": isAlarm ? null : val["tangkiData"] as List<dynamic>
        });
      }

      if (mounted) setState(() {});
    } else {
      if (kDebugMode) {
        print("error : ${r["error"]}");
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
        isFirstLoading = false;
      });
    }
  }

  int indexData = 0;
  String dataDate = "";

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
              FittedBox(
                // width: 100,
                // height: 50,
                fit: BoxFit.fitHeight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
              //   height: 10,
              // ),
              MainStyle.sizedBoxH10,
              SizedBox(
                  width: lWidth,
                  child: const Divider(
                    color: Colors.black26,
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
              child: SizedBox(
                height: lheight * 0.65,
                child: Stack(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        width: lWidth,
                        height: lheight * 0.65,
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
                        child: Center(
                          child: isFirstLoading
                              ? SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator(
                                    color: MainStyle.primaryColor,
                                  ))
                              : PanelTable(
                                  fileNum: Content_dataLogger2.fileNum,
                                  progress: Content_dataLogger2.progress,
                                  download: () => downloadBackend(),
                                  isLoading: isLoading,
                                  changeIsAlarm: changeIsAlarm,
                                  loadmore: loadMore,
                                  dataLog: dataLog,
                                  onTap: ((index) {
                                    changeData(index);
                                  }),
                                  max: maxDataNum),
                        )),
                    // const SizedBox(
                    //   width: 30,
                    // ),
                    AnimatedPositioned(
                      top: isTapped
                          ? (lheight <= 830 ? 0 : lheight * 0.22)
                          : lheight * 0.67,
                      duration: const Duration(milliseconds: 120),
                      child: Container(
                        // padding: EdgeInsets.all(10),
                        width: lWidth,
                        height: lheight * 0.67,
                        clipBehavior: Clip.none,
                        decoration: BoxDecoration(
                            color: MainStyle.thirdColor,
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(4, 4),
                                  color: MainStyle.primaryColor
                                      .withAlpha((255 * 0.05).toInt()),
                                  blurRadius: 10,
                                  spreadRadius: 0),
                              BoxShadow(
                                  offset: Offset(-4, -4),
                                  color: Colors.white
                                      .withAlpha((255 * 0.5).toInt()),
                                  blurRadius: 13,
                                  spreadRadius: 0),
                              BoxShadow(
                                  offset: Offset(6, 6),
                                  color: MainStyle.primaryColor
                                      .withAlpha((255 * 0.10).toInt()),
                                  blurRadius: 20,
                                  spreadRadius: 0),
                            ]),
                        child: Column(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MainStyle.sizedBoxH20,
                              Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: 100,
                                  child: MyButton(
                                      color: MainStyle.primaryColor,
                                      text: "Close",
                                      onPressed: () {
                                        setState(() {
                                          isTapped = false;
                                        });
                                      },
                                      textColor: Colors.white),
                                ),
                              ),
                              MainStyle.sizedBoxH10,
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/dataNyata.svg",
                                            width: 30,
                                            color: MainStyle.primaryColor,
                                          ),
                                          // const SizedBox(
                                          //   width: 10,
                                          // ),
                                          MainStyle.sizedBoxW10,
                                          Text(
                                            "Data Nyata",
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
                                              "pH: ${(((selData[7][0]["pH"] ?? 0) / 1.0) as double).toStringAsFixed(2)}   Suhu: ${(((selData[7][0]["suhu"] ?? 0) / 1.0) as double).toStringAsFixed(2)} \u00B0 C",
                                              style: MainStyle
                                                  .textStyleDefault14Black,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  MainStyle.sizedBoxH5,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Sort by: "),
                                      MyDropDown(
                                          items: [
                                            "Pilih",
                                            "Suhu",
                                            "Tegangan",
                                            "Arus",
                                            "Daya",
                                            "Energi"
                                          ],
                                          value: sortBy,
                                          onChange: (s) {
                                            setState(() {
                                              sortBy = s ?? "";
                                            });
                                            sortSelData();
                                          }),
                                      MainStyle.sizedBoxW5,
                                      MyDropDown(
                                          items: [
                                            "Desc",
                                            "Asc",
                                          ],
                                          value: ascDesc,
                                          onChange: (s) {
                                            setState(() {
                                              ascDesc = s ?? "";
                                            });
                                            sortSelData();
                                          }),
                                      MainStyle.sizedBoxW5
                                    ],
                                  )
                                ],
                              ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              MainStyle.sizedBoxH20,
                              SizedBox(
                                  width: lWidth,
                                  height: 120,
                                  child: PageView(
                                    clipBehavior: Clip.none,
                                    controller: pc,
                                    onPageChanged: (V) => getTotal(
                                        V,
                                        int.tryParse(
                                                filterTangki.tangkiValue) ??
                                            0),
                                    // scrollDirection: Axis.horizontal,
                                    children:
                                        (selData[int.tryParse(
                                                    filterTangki.tangkiValue) ??
                                                0] as List<dynamic>)
                                            .getRange(
                                                0, currTangki == 0 ? 30 : 5)
                                            .map((e) => Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 70),
                                                  clipBehavior: Clip.none,
                                                  width: lWidth,
                                                  // height: 100,
                                                  decoration: BoxDecoration(
                                                      color: MainStyle
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32)),
                                                  child: Transform.scale(
                                                    scale: 1.4,
                                                    origin:
                                                        const Offset(-170, -70),
                                                    child: Stack(
                                                      children: [
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Transform
                                                                  .translate(
                                                                offset:
                                                                    const Offset(
                                                                        0, -30),
                                                                child: Text(
                                                                  "#",
                                                                  style: MyTextStyle
                                                                      .defaultFontCustom(
                                                                          Colors
                                                                              .white30,
                                                                          90),
                                                                ),
                                                              ),
                                                              Transform
                                                                  .translate(
                                                                offset:
                                                                    const Offset(
                                                                        0, 0),
                                                                child: Column(
                                                                  children: [
                                                                    Visibility(
                                                                      visible:
                                                                          currTangki ==
                                                                              0,
                                                                      child:
                                                                          Text(
                                                                        "  Sel ${e["tangki"]}",
                                                                        style: MyTextStyle.defaultFontCustom(
                                                                            Colors.white,
                                                                            20),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "  Crossbar ${e["sel"]}",
                                                                      style: MyTextStyle.defaultFontCustom(
                                                                          Colors
                                                                              .white,
                                                                          18),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ]),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Transform
                                                              .translate(
                                                            offset:
                                                                const Offset(
                                                                    0, 55),
                                                            child: SizedBox(
                                                              width: 200,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            3),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                MainStyle.secondaryColor,
                                                                            borderRadius: BorderRadius.circular(5)),
                                                                        child:
                                                                            Text(
                                                                          "S: ${(e["suhu"] / 1 as double).toStringAsFixed(2)} \u00B0 C",
                                                                          style: MyTextStyle.defaultFontCustom(
                                                                              MainStyle.primaryColor,
                                                                              8,
                                                                              weight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            3),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                MainStyle.secondaryColor,
                                                                            borderRadius: BorderRadius.circular(5)),
                                                                        child:
                                                                            Text(
                                                                          "T: ${(e["tegangan"] / 1 as double).toStringAsFixed(2)}  V",
                                                                          style: MyTextStyle.defaultFontCustom(
                                                                              MainStyle.primaryColor,
                                                                              8,
                                                                              weight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            3),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                MainStyle.secondaryColor,
                                                                            borderRadius: BorderRadius.circular(5)),
                                                                        child:
                                                                            Text(
                                                                          "Ars: ${(e["arus"] / 1 as double).toStringAsFixed(2)}  A",
                                                                          style: MyTextStyle.defaultFontCustom(
                                                                              MainStyle.primaryColor,
                                                                              8,
                                                                              weight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // MainStyle.sizedBoxH5,
                                                                  const SizedBox(
                                                                    height: 3,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            3),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                MainStyle.secondaryColor,
                                                                            borderRadius: BorderRadius.circular(5)),
                                                                        child:
                                                                            Text(
                                                                          "D: ${(e["daya"] / 1 as double).toStringAsFixed(2)}  watt",
                                                                          style: MyTextStyle.defaultFontCustom(
                                                                              MainStyle.primaryColor,
                                                                              8,
                                                                              weight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            3),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                MainStyle.secondaryColor,
                                                                            borderRadius: BorderRadius.circular(5)),
                                                                        child:
                                                                            Text(
                                                                          "E: ${(e["energi"] / 1 as double).toStringAsFixed(2)}  kwh",
                                                                          style: MyTextStyle.defaultFontCustom(
                                                                              MainStyle.primaryColor,
                                                                              8,
                                                                              weight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                      Opacity(
                                                                        opacity:
                                                                            0,
                                                                        child:
                                                                            Container(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              3),
                                                                          decoration: BoxDecoration(
                                                                              color: MainStyle.secondaryColor,
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          child:
                                                                              Text(
                                                                            "E: 0  kwh",
                                                                            style: MyTextStyle.defaultFontCustom(MainStyle.primaryColor,
                                                                                8,
                                                                                weight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                  )),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              MainStyle.sizedBoxH20,
                              PageViewDotIndicator(
                                  onItemClicked: (index) => pc.animateToPage(
                                      index,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.ease),
                                  alignment: Alignment.centerLeft,
                                  currentItem: currPage,
                                  count: selData[int.tryParse(
                                              filterTangki.tangkiValue) ??
                                          0]
                                      .length,
                                  unselectedColor: Colors.grey,
                                  selectedColor: MainStyle.primaryColor)
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    // FittedBox(
                    //   fit: BoxFit.fitHeight,
                    //   child: Container(
                    //     clipBehavior: Clip.none,
                    //     padding: const EdgeInsets.all(10),
                    //     width: 530,
                    //     height: 250,
                    //     decoration: BoxDecoration(
                    //       color: MainStyle.secondaryColor,
                    //       borderRadius: BorderRadius.circular(30),
                    //       // boxShadow: [
                    //       //   BoxShadow(
                    //       //       offset: Offset(4, 4),
                    //       //       color: MainStyle.primaryColor
                    //       //           .withAlpha((255 * 0.05).toInt()),
                    //       //       blurRadius: 10,
                    //       //       spreadRadius: 0),
                    //       //   BoxShadow(
                    //       //       offset: Offset(-4, -4),
                    //       //       color: Colors.white
                    //       //           .withAlpha((255 * 0.5).toInt()),
                    //       //       blurRadius: 13,
                    //       //       spreadRadius: 0),
                    //       //   BoxShadow(
                    //       //       offset: Offset(6, 6),
                    //       //       color: MainStyle.primaryColor
                    //       //           .withAlpha((255 * 0.10).toInt()),
                    //       //       blurRadius: 20,
                    //       //       spreadRadius: 0),
                    //       // ]
                    //     ),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: totalData
                    //           .map((e) => Container(
                    //                 clipBehavior: Clip.none,
                    //                 decoration: const BoxDecoration(),
                    //                 child: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     SizedBox(
                    //                       width: 200,
                    //                       child: Text(
                    //                         e["title"] as String,
                    //                         style: MyTextStyle.defaultFontCustom(
                    //                             Colors.black, 15,
                    //                             weight: FontWeight.bold),
                    //                       ),
                    //                     ),
                    //                     Container(
                    //                       margin:
                    //                           const EdgeInsets.only(bottom: 10),
                    //                       clipBehavior: Clip.none,
                    //                       // width: 300,
                    //                       height: 35,
                    //                       padding: const EdgeInsets.all(3),
                    //                       decoration: BoxDecoration(
                    //                         gradient: LinearGradient(
                    //                             colors: grad_colors,
                    //                             stops: [0, 0.6, 1],
                    //                             begin: Alignment.topLeft,
                    //                             end: Alignment.bottomRight),
                    //                         borderRadius:
                    //                             BorderRadius.circular(4),
                    //                         // boxShadow: [
                    //                         //   BoxShadow(
                    //                         //       color: MainStyle
                    //                         //           .primaryColor
                    //                         //           .withAlpha(
                    //                         //               (255 * 0.15)
                    //                         //                   .toInt()),
                    //                         //       offset: Offset(0, 3),
                    //                         //       blurRadius: 5,
                    //                         //       spreadRadius: 0),
                    //                         //   BoxShadow(
                    //                         //       color: MainStyle
                    //                         //           .primaryColor
                    //                         //           .withAlpha(
                    //                         //               (255 * 0.15)
                    //                         //                   .toInt()),
                    //                         //       offset: Offset(0, 3),
                    //                         //       blurRadius: 30,
                    //                         //       spreadRadius: 0)
                    //                         // ]
                    //                       ),
                    //                       child: Row(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.center,
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.spaceBetween,
                    //                         children: [
                    //                           Container(
                    //                             height: 30,
                    //                             clipBehavior: Clip.none,
                    //                             decoration: const BoxDecoration(),
                    //                             width: 200,
                    //                             child: Text(
                    //                               (e["value"] as double)
                    //                                   .toStringAsFixed(2),
                    //                               style: MyTextStyle
                    //                                   .defaultFontCustom(
                    //                                       MainStyle.primaryColor,
                    //                                       25),
                    //                             ),
                    //                           ),
                    //                           SizedBox(
                    //                             width: 100,
                    //                             child: Text(
                    //                               e["unit"] as String,
                    //                               textAlign: TextAlign.right,
                    //                               style: MyTextStyle
                    //                                   .defaultFontCustom(
                    //                                       Colors.black, 15,
                    //                                       weight:
                    //                                           FontWeight.bold),
                    //                             ),
                    //                           )
                    //                         ],
                    //                       ),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ))
                    //           .toList(),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
