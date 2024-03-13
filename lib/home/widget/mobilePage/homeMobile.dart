import 'dart:math';

import 'package:antam_monitoring/home/widget/account_alarm.dart';
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

class HomeMobile extends StatefulWidget {
  HomeMobile(
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
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  // final MyTextStyle MyTextStyle = const MyTextStyle();

  String sortBy = "Pilih", ascDesc = "Desc";
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

  var titleData = ["#Sel", "Celcius", "Volt", "Ampere"];

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

  filterChange() {
    widget.changePage(1,
        dari: filterTglDari.today, hingga: filterTglHingga.today);
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

  getData(int tangki, {bool isSetState = true}) {
    currTangki = tangki;
    pc.jumpToPage(0);
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
    // }

    sortSelData();

    if (mounted && isSetState) setState(() {});
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

  getMax2({bool isSetState = true}) {
    // selData[0].clear();
    for (var x = 0; x < maxData.length; x++) {
      for (var i = 2; i < titleData.length; i++) {
        final title = titleData[i].toLowerCase();

        maxData[x][title] = 0;
      }
    }

    for (var i = 1; i < selData.length; i++) {
      final v = selData[i];

      // int count = 1;

      for (Map<String, dynamic> e in v) {
        final c = (e["suhu"] ?? e["celcius"]) as double;
        final vv = (e["tegangan"] ?? e["volt"]) as double;
        final a = (e["arus"] ?? e["ampere"]) as double;
        final w = (e["daya"] ?? e["watt"] ?? 0) as double;
        final en = (e["energi"] ?? e["kwh"] ?? 0) as double;

        // selData[0].add({
        //   "tangki": i.toDouble(),
        //   "sel": e["sel"] as double,
        //   "suhu": c,
        //   "tegangan": vv,
        //   "arus": a,
        //   "daya": w,
        //   "energi": en,
        // });

        final sel = (selData[0] as List<dynamic>);

        (sel).firstWhere((element) =>
            element["tangki"] == i.toDouble() &&
            element["sel"] == (e["sel"] as double))["suhu"] = c;
        // }

        sel.firstWhere((element) =>
            element["tangki"] == i.toDouble() &&
            element["sel"] == (e["sel"] as double))["tegangan"] = vv;

        sel.firstWhere((element) =>
            element["tangki"] == i.toDouble() &&
            element["sel"] == (e["sel"] as double))["arus"] = a;

        sel.firstWhere((element) =>
            element["tangki"] == i.toDouble() &&
            element["sel"] == (e["sel"] as double))["daya"] = w;
        sel.firstWhere((element) =>
            element["tangki"] == i.toDouble() &&
            element["sel"] == (e["sel"] as double))["energi"] = en;

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

    if (mounted && isSetState) setState(() {});
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
      bool refresh = true;
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
        final int tangki = data["tangki"] as int;

        final sData = Map.from(data["selData"]);

        if (kDebugMode) {
          print((sData));
        }

        for (var i = 2; i < titleData.length; i++) {
          final title = titleData[i].toLowerCase();

          if (selData[tangki][(data["sel"] as int) - 1][title] !=
              sData[title]) {
            refresh = true;
            selData[tangki][(data["sel"] as int) - 1][title] = sData[title];
          }

          // selData[tangki][(data["sel"] as int) - 1][title] = sData[title];
        }

        getMax2(isSetState: false);

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

      if (listAlarmArus.isNotEmpty) {
        alarm.firstWhere(
            (element) => element["title"] == "Alarm Arus")["isActive"] = true;
      }

      if (listAlarmTegangan.isNotEmpty) {
        alarm.firstWhere(
                (element) => element["title"] == "Alarm Tegangan")["isActive"] =
            true;
      }

      account_alarm.setState!();
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

    initStatus();
    initSelData();
    initTotalDataStatistic();

    // getMax2();
  }

  resetSelDataSort() {
    (selData[int.tryParse(filterTangki.tangkiValue) ?? 0] as List<dynamic>)
        .sort((dynamic a, dynamic b) {
      final aVal = currTangki == 0 ? a["tangki"] as double : a["sel"] as double;
      final bVal = currTangki == 0 ? b["tangki"] as double : b["sel"] as double;
      final aVal2 = a["sel"] as double;
      final bVal2 = b["sel"] as double;

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
      final aVal = (a[sortBy.toLowerCase()] ?? 0) as double;
      final bVal = (b[sortBy.toLowerCase()] ?? 0) as double;

      print("aVal: $aVal bBal: $bVal");

      int r = ascDesc == "Desc" ? bVal.compareTo(aVal) : aVal.compareTo(bVal);

      return r;
    });
    if (mounted && isSetState) setState(() {});
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
                    filterTangki
                  ],
                ),
              ),
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
                    child: Column(children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/monitoring.svg",
                            width: 30,
                            color: MainStyle.primaryColor,
                          ),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          MainStyle.sizedBoxW10,
                          Text(
                            "Grafik Nyata",
                            style: MyTextStyle.defaultFontCustom(
                                MainStyle.primaryColor, 20),
                          )
                        ],
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      MainStyle.sizedBoxH20,
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Tegangan (V)")),
                      SizedBox(
                        width: 1200,
                        height: 230,
                        child: Stack(
                          children: [
                            MyLineChart(
                              points: teganganSetting,
                              maxY: 4,
                            ),
                            MyBarChart(
                                maxY: 4,
                                tangkiMaxData:
                                    currTangki != 0 ? [] : tangkiMaxData,
                                max: teganganSetting.first.y,
                                title: "tegangan",
                                points: teganganData),
                          ],
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      MainStyle.sizedBoxH10,
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Arus (A)")),
                      SizedBox(
                        width: 1200,
                        height: 230,
                        child: Stack(
                          children: [
                            MyLineChart(
                              points: arusSetting,
                              maxY: 200,
                            ),
                            MyBarChart(
                                maxY: 200,
                                tangkiMaxData:
                                    currTangki != 0 ? [] : tangkiMaxData,
                                max: teganganSetting.first.y,
                                title: "arus",
                                points: arusData),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    // padding: EdgeInsets.all(10),
                    width: 1200,
                    height: 230,
                    clipBehavior: Clip.none,
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
                    child: Column(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                style: MyTextStyle.defaultFontCustom(
                                    MainStyle.primaryColor, 20),
                              ),
                            ],
                          ),
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
                          height: 118,
                          child: PageView(
                            clipBehavior: Clip.none,
                            controller: pc,
                            onPageChanged: (V) => getTotal(
                                V, int.tryParse(filterTangki.tangkiValue) ?? 0),
                            // scrollDirection: Axis.horizontal,
                            children:
                                (selData[int.tryParse(
                                            filterTangki.tangkiValue) ??
                                        0] as List<dynamic>)
                                    .map((e) => Container(
                                          margin:
                                              const EdgeInsets.only(right: 70),
                                          clipBehavior: Clip.none,
                                          width: lWidth,
                                          // height: 100,
                                          decoration: BoxDecoration(
                                              color: MainStyle.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(32)),
                                          child: Transform.scale(
                                            scale: 1.4,
                                            origin: const Offset(-170, -70),
                                            child: Stack(
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Transform.translate(
                                                        offset: const Offset(
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
                                                      Transform.translate(
                                                        offset:
                                                            const Offset(0, 0),
                                                        child: Column(
                                                          children: [
                                                            Visibility(
                                                              visible:
                                                                  currTangki ==
                                                                      0,
                                                              child: Text(
                                                                "  Sel ${e["tangki"]}",
                                                                style: MyTextStyle
                                                                    .defaultFontCustom(
                                                                        Colors
                                                                            .white,
                                                                        20),
                                                              ),
                                                            ),
                                                            Text(
                                                              "  Anoda ${e["sel"]}",
                                                              style: MyTextStyle
                                                                  .defaultFontCustom(
                                                                      Colors
                                                                          .white,
                                                                      20),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ]),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Transform.translate(
                                                    offset: const Offset(0, 55),
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
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color: MainStyle
                                                                        .secondaryColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Text(
                                                                  "S: ${(e["suhu"] as double).toStringAsFixed(2)} \u00B0 C",
                                                                  style: MyTextStyle.defaultFontCustom(
                                                                      MainStyle
                                                                          .primaryColor,
                                                                      8,
                                                                      weight: FontWeight
                                                                          .w700),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color: MainStyle
                                                                        .secondaryColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Text(
                                                                  "T: ${(e["tegangan"] as double).toStringAsFixed(2)}  V",
                                                                  style: MyTextStyle.defaultFontCustom(
                                                                      MainStyle
                                                                          .primaryColor,
                                                                      8,
                                                                      weight: FontWeight
                                                                          .w700),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color: MainStyle
                                                                        .secondaryColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Text(
                                                                  "Ars: ${(e["arus"] as double).toStringAsFixed(2)}  A",
                                                                  style: MyTextStyle.defaultFontCustom(
                                                                      MainStyle
                                                                          .primaryColor,
                                                                      8,
                                                                      weight: FontWeight
                                                                          .w700),
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
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color: MainStyle
                                                                        .secondaryColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Text(
                                                                  "D: ${(e["daya"] as double).toStringAsFixed(2)}  watt",
                                                                  style: MyTextStyle.defaultFontCustom(
                                                                      MainStyle
                                                                          .primaryColor,
                                                                      8,
                                                                      weight: FontWeight
                                                                          .w700),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color: MainStyle
                                                                        .secondaryColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Text(
                                                                  "E: ${(e["energi"] as double).toStringAsFixed(2)}  kwh",
                                                                  style: MyTextStyle.defaultFontCustom(
                                                                      MainStyle
                                                                          .primaryColor,
                                                                      8,
                                                                      weight: FontWeight
                                                                          .w700),
                                                                ),
                                                              ),
                                                              Opacity(
                                                                opacity: 0,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          3),
                                                                  decoration: BoxDecoration(
                                                                      color: MainStyle
                                                                          .secondaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Text(
                                                                    "E: 0  kwh",
                                                                    style: MyTextStyle.defaultFontCustom(
                                                                        MainStyle
                                                                            .primaryColor,
                                                                        8,
                                                                        weight:
                                                                            FontWeight.w700),
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
                          onItemClicked: (index) => pc.animateToPage(index,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.ease),
                          alignment: Alignment.centerLeft,
                          currentItem: currPage,
                          count: selData[
                                  int.tryParse(filterTangki.tangkiValue) ?? 0]
                              .length,
                          unselectedColor: Colors.grey,
                          selectedColor: MainStyle.primaryColor)
                    ]),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Container(
                      clipBehavior: Clip.none,
                      padding: const EdgeInsets.all(10),
                      width: 530,
                      height: 250,
                      decoration: BoxDecoration(
                        color: MainStyle.secondaryColor,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: totalData
                            .map((e) => Container(
                                  clipBehavior: Clip.none,
                                  decoration: const BoxDecoration(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          e["title"] as String,
                                          style: MyTextStyle.defaultFontCustom(
                                              Colors.black, 15,
                                              weight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        clipBehavior: Clip.none,
                                        // width: 300,
                                        height: 35,
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: grad_colors,
                                              stops: [0, 0.6, 1],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight),
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 30,
                                              clipBehavior: Clip.none,
                                              decoration: const BoxDecoration(),
                                              width: 200,
                                              child: Text(
                                                (e["value"] as double)
                                                    .toStringAsFixed(2),
                                                style: MyTextStyle
                                                    .defaultFontCustom(
                                                        MainStyle.primaryColor,
                                                        25),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                e["unit"] as String,
                                                textAlign: TextAlign.right,
                                                style: MyTextStyle
                                                    .defaultFontCustom(
                                                        Colors.black, 15,
                                                        weight:
                                                            FontWeight.bold),
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
                  ),
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
