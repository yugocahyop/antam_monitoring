import 'dart:convert';
import 'dart:math';

import 'package:antam_monitoring/home/widget/account_alarm.dart';
import 'package:antam_monitoring/home/widget/content_call/widget/phonePanel.dart';
import 'package:antam_monitoring/home/widget/content_dataLogger/widget/panelTable.dart';
import 'package:antam_monitoring/home/widget/filterTangki.dart';
import 'package:antam_monitoring/home/widget/filterTgl.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/tools/mqtt/mqtt.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Content_dataLogger extends StatefulWidget {
  Content_dataLogger(
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
  State<Content_dataLogger> createState() => _Content_dataLoggerState();
}

class _Content_dataLoggerState extends State<Content_dataLogger> {
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

  var titleData = ["#Sel", "Suhu", "Tegangan", "Arus", "Daya", "Energi"];

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
  ];

  List<dynamic> selData = [
    [
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
    ],
    [
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
    ],
    [
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
    ],
    [
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
    ],
    [
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
    ],
    [
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
    ],
    [
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

    if (mounted) setState(() {});
  }

  getMax() {
    for (var i = 1; i < selData.length; i++) {
      final v = selData[i];

      // int count = 1;
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

        // count++;
      }

      // if (kDebugMode) {
      //   print("sel data 0 : ${selData[0][0].toString()}");
      // }
    }
  }

  MyMqtt? mqtt;

  Map<String, bool> dataNyataSortOrder = {};
  List<String> dataNyataSortOrderList = [];

  resetSelDataSort() {
    (selData[int.tryParse(filterTangki.tangkiValue) ?? 0] as List<dynamic>)
        .sort((dynamic a, dynamic b) {
      // final aVal = currTangki == 0 ? a["tangki"] as double : a["sel"] as double;
      // final bVal = currTangki == 0 ? b["tangki"] as double : b["sel"] as double;
      final aVal = a["sel"] as double;
      final bVal = b["sel"] as double;

      // print(
      //     "sel");
      int r = aVal.compareTo(bVal);

      // if (r == 0) {
      //   r = aVal2.compareTo(bVal2);
      // }

      return r;
    });
  }

  sortSelData() {
    if (dataNyataSortOrderList.isEmpty || dataNyataSortOrder.isEmpty) return;
    resetSelDataSort();
    (selData[int.tryParse(filterTangki.tangkiValue) ?? 0] as List<dynamic>)
        .sort((dynamic a, dynamic b) {
      final aVal =
          a[dataNyataSortOrderList[0].toLowerCase().replaceAll("#", "")] ??
              0 as double;
      final bVal =
          b[dataNyataSortOrderList[0].toLowerCase().replaceAll("#", "")] ??
              0 as double;

      // print("aVal: $aVal");

      int r = dataNyataSortOrder[dataNyataSortOrderList[0]]!
          ? bVal.compareTo(aVal)
          : aVal.compareTo(bVal);

      int i = 1;

      while (r == 0 &&
          dataNyataSortOrderList.length > 1 &&
          i < dataNyataSortOrderList.length) {
        if (i < dataNyataSortOrderList.length) {
          final aVal =
              a[dataNyataSortOrderList[i].toLowerCase().replaceAll("#", "")] ??
                  0 as double;
          final bVal =
              b[dataNyataSortOrderList[i].toLowerCase().replaceAll("#", "")] ??
                  0 as double;

          // print("aVal: $aVal");

          r = dataNyataSortOrder[dataNyataSortOrderList[i]]!
              ? bVal.compareTo(aVal)
              : aVal.compareTo(bVal);
        }

        i++;
      }

      return r;
    });
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mqtt!.onUpdate = (t, d) {};

    tangkiMaxData.clear();
    maxDdata.clear();

    // if (mqtt != null) {
    //   mqtt!.disconnect();
    // }
  }

  int currTangki = 0;

  List<Map<String, dynamic>> dataLog = [
    {
      "isHover": false,
      "timeStamp_server": 1706561733680,
      "tangkiData": [[]]
    }
  ];

  initDataLog() async {
    final api = ApiHelper();

    // while (ApiHelper.tokenMain == null) {
    //   await Future.delayed(const Duration(seconds: 1));
    // }

    final r = await api.callAPI(
        "/monitoring/find?limit=10", "POST", jsonEncode({"from": 0}), true);

    if (r["error"] == null) {
      if ((r["data"] as List).isEmpty) return;
      List<dynamic> data = r['data'] as List<dynamic>;

      if (kDebugMode) {
        print("backend data2:  $data");
      }

      dataLog.clear();
      for (var i = 0; i < data.length; i++) {
        final val = data[i];

        dataLog.add({
          "isClicked": false,
          "isHover": false,
          "timeStamp_server": val["timeStamp_server"],
          "tangkiData": val["tangkiData"] as List<dynamic>
        });
      }

      if (mounted) setState(() {});
    } else {
      if (kDebugMode) {
        print(r["error"]);
      }
    }
  }

  initSelData() async {
    final api = ApiHelper();

    final r = await api.callAPI("/monitoring/find/last", "POST", "", true);

    if (kDebugMode) {
      print("backend data: $r");
    }

    if (r["error"] == null) {
      if ((r["data"] as List).isEmpty) return;
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

      selData.addAll(r["data"][0]["tangkiData"] ?? []);
    }

    setState(() {});

    getMax();

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

    if (mounted) setState(() {});
  }

  initMqtt() {
    mqtt!.onUpdate = (data, topic) {
      if (kDebugMode) {
        print("mqtt topic $topic");
      }

      if (topic == "antam/device") {
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

        final sData = Map.from(data["selData"]);

        resetSelDataSort();

        if (kDebugMode) {
          print((sData));
        }

        for (var i = 2; i < titleData.length; i++) {
          final title = titleData[i].toLowerCase();

          selData[tangki][(data["sel"] as int) - 1][title] = sData[title];
        }

        getMax();

        getData(currTangki);
        sortSelData();
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

        alarm.clear();
        alarm.addAll(temp);
      } else if (topic == "antam/statistic") {
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
      }

      data.clear();

      // getTotal(currTangki);

      if (mounted) {
        setState(() {});
      }
    };
  }

  initTotalDataStatistic() async {
    ApiHelper api = ApiHelper();

    final r = await api.callAPI("/statistic/find/last", "POST", "", true);

    if (r["error"] == null) {
      if ((r["data"] as List).isEmpty) return;
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

      setState(() {});
    }
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

    mqtt = widget.mqtt;

    selData = widget.selData;

    // getData(0);

    filterTangki = FilterTangki(
      tangkiValue: "Max",
      items: ["Max", "1", "2", "3", "4", "5", "6"],
      onChange: (value) => getData(int.tryParse(value) ?? 0),
    );

    // getMax();

    initSelData();
    initTotalDataStatistic();
    initDataLog();
  }

  List<Map<String, dynamic>> callData = [
    {
      "name": "Yugo cahyopratopo",
      "phone": "+6282120432996",
      "role": "Developer"
    },
    {"name": "Tengku Ahmad", "phone": "+6285265262812", "role": "Developer"}
  ];

  List<Widget> createPhonePanels(double width) {
    List<Widget> panels = [];

    for (var i = 0; i < callData.length; i++) {
      final val = callData[i];
      panels.add(PhonePanel(
          name: val["name"],
          role: val["role"],
          phone: val["phone"],
          width: width));
      panels.add(SizedBox(
        height: 5,
      ));
    }

    return panels;
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
              : 740,
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
                      : 740,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.scale(
                      scale: (lWidth / lheight) < wide ? 1.2 : 1,
                      origin: Offset((lWidth / lheight) < wide ? -610 : 0, 0),
                      child:
                          Account_alarm(alarm: alarm, isAdmin: widget.isAdmin)),
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
                                    fileNum: 0,
                                    progress: 0,
                                    download: () {},
                                    isLoading: false,
                                    changeIsAlarm: (bool isAlarm) {},
                                    loadmore: () async {
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      return true;
                                    },
                                    max: 1,
                                    onTap: (index) {},
                                    dataLog: dataLog,
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
                                    Container(
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
                                              style:
                                                  MyTextStyle.defaultFontCustom(
                                                      MainStyle.primaryColor,
                                                      20),
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
                                                        .withAlpha((255 * 0.15)
                                                            .toInt()),
                                                    offset: const Offset(0, 3),
                                                    blurRadius: 5,
                                                    spreadRadius: 0),
                                                BoxShadow(
                                                    color: MainStyle
                                                        .primaryColor
                                                        .withAlpha((255 * 0.15)
                                                            .toInt()),
                                                    offset: const Offset(0, 3),
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
                                                    color:
                                                        MainStyle.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    4),
                                                            topRight: Radius
                                                                .circular(4))),
                                                child: Row(
                                                  children: titleData
                                                      .map((e) => InkWell(
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

                                                                    setState(
                                                                        () {});

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
                                                            },
                                                            child: SizedBox(
                                                              width: 90,
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
                                                                      style: MyTextStyle.defaultFontCustom(
                                                                          Colors
                                                                              .white,
                                                                          14),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 3,
                                                                    ),
                                                                    Stack(
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              Visibility(
                                                                            visible: dataNyataSortOrder.containsKey(e)
                                                                                ? !dataNyataSortOrder[e]!
                                                                                : false,
                                                                            child:
                                                                                Transform.translate(
                                                                              offset: const Offset(0, -2),
                                                                              child: const Icon(Icons.arrow_drop_up, size: 13, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Center(
                                                                          child:
                                                                              Visibility(
                                                                            visible: dataNyataSortOrder.containsKey(e)
                                                                                ? dataNyataSortOrder[e]!
                                                                                : false,
                                                                            child:
                                                                                Transform.translate(
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
                                                      color: Color(0xffC1E1DF),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(4),
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
                                                        itemCount: selData[int.tryParse(
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
                                                          List<Widget> listSel =
                                                              [];
                                                          List<Widget>
                                                              listTangki = [];
                                                          val.forEach((key,
                                                                  value) =>
                                                              key == "sel"
                                                                  ? listSel
                                                                      .insert(
                                                                          0,
                                                                          SizedBox(
                                                                            width:
                                                                                90,
                                                                            height:
                                                                                35,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                (value as double).toStringAsFixed(key == "sel" ? 0 : 2) + (key == "suhu" || key == "celcius" ? "\u00B0" : ""),
                                                                                style: MyTextStyle.defaultFontCustom(Colors.black, 15),
                                                                              ),
                                                                            ),
                                                                          ))
                                                                  : listSel.add(
                                                                      Visibility(
                                                                      visible:
                                                                          key !=
                                                                              "tangki",
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            90,
                                                                        height:
                                                                            35,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            (value as double).toStringAsFixed(key == "sel" ? 0 : 2) +
                                                                                (key == "suhu" || key == "celcius" ? "\u00B0" : ""),
                                                                            style:
                                                                                MyTextStyle.defaultFontCustom(Colors.black, 15),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )));

                                                          tangkiMaxData[i]
                                                              .forEach((key,
                                                                      value) =>
                                                                  listTangki.add(
                                                                      SizedBox(
                                                                    width: 90,
                                                                    // height: 35,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Visibility(
                                                                        visible:
                                                                            key !=
                                                                                "sel",
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              80,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              2),
                                                                          decoration: BoxDecoration(
                                                                              color: MainStyle.secondaryColor,
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          child:
                                                                              Text(
                                                                            "tangki " +
                                                                                (value as int).toString(),
                                                                            style: MyTextStyle.defaultFontCustom(MainStyle.primaryColor,
                                                                                12,
                                                                                weight: FontWeight.w600),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )));

                                                          // listSel.add();
                                                          return Column(
                                                            children: [
                                                              Row(
                                                                  children:
                                                                      listSel),
                                                              SizedBox(
                                                                width: 600,
                                                                child: Stack(
                                                                  children: [
                                                                    const Divider(
                                                                      color: Color(
                                                                          0xff9ACBC7),
                                                                    ),
                                                                    Visibility(
                                                                      visible:
                                                                          currTangki ==
                                                                              0,
                                                                      child:
                                                                          Row(
                                                                        children:
                                                                            listTangki,
                                                                      ),
                                                                    ),
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
                                                          style: MyTextStyle
                                                              .defaultFontCustom(
                                                                  Colors.black,
                                                                  15,
                                                                  weight:
                                                                      FontWeight
                                                                          .bold),
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
                                                              child: Text(
                                                                (e["value"]
                                                                        as double)
                                                                    .toStringAsFixed(
                                                                        2),
                                                                style: MyTextStyle
                                                                    .defaultFontCustom(
                                                                        MainStyle
                                                                            .primaryColor,
                                                                        25),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 100,
                                                              child: Text(
                                                                e["unit"]
                                                                    as String,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: MyTextStyle
                                                                    .defaultFontCustom(
                                                                        Colors
                                                                            .black,
                                                                        15,
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
                      setState(() {
                        isMsgVisible = false;
                      });
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
                                    style: MyTextStyle.defaultFontCustom(
                                        Colors.black, 20,
                                        weight: FontWeight.bold),
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
                                    style: MyTextStyle.defaultFontCustom(
                                        Colors.black, 40,
                                        weight: FontWeight.bold),
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
                                        setState(() {
                                          msgOpacity = 0;
                                        });
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
