import 'dart:math';

import 'package:antam_monitoring/home/widget/account_alarm.dart';
import 'package:antam_monitoring/home/widget/content_setting/widget/panelTableSetting.dart';
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

class SettingMobile extends StatefulWidget {
  SettingMobile(
      {super.key,
      required this.email,
      required this.changePage,
      required this.isAdmin,
      required this.mqtt,
      required this.selData,
      required this.scSel,
      required this.menuItem});

  final bool isAdmin;

  List<dynamic> selData;

  MyMqtt mqtt;

  String email;

  Function(int index, {int? dari, int? hingga}) changePage;

  ScrollController scSel;
  List<Map<String, dynamic>> menuItem;

  @override
  State<SettingMobile> createState() => _SettingMobileState();
}

class _SettingMobileState extends State<SettingMobile> {
  // final MyTextStyle MyTextStyle = const MyTextStyle();

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

  late FilterTangki filterTangki;

  late FilterTgl filterTglHingga;

  late FilterTgl filterTglDari;

  filterChange() {
    widget.changePage(1,
        dari: filterTglDari.today, hingga: filterTglHingga.today);
  }

  late MyMqtt mqtt;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    mqtt.disconnect();

    widget.scSel.dispose();

    // initState();
    // initMqtt();
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
    mqtt.onUpdate = (data, topic) {
      if (topic == "antam/device") {
        // selData.clear();
        // // final firstData = List.of(maxDdata);
        // selData.add([
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
        // selData.addAll(data["tangkiData"]);

        // getMax2();

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

        // getData(currTangki);

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

      // if (mounted) {
      //   setState(() {});
      // }

      // Future.delayed(Duration(milliseconds: 500), () {

      // });
    };
  }

  late Account_alarm account_alarm;

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

    // getData(0);

    // if (kDebugMode) {
    //   print("sel length: ${selData.length}");
    // }

    mqtt = MyMqtt(onUpdate: (data, topic) {});

    // getMax2();

    initStatus();
    initMqtt();
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
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      width: lWidth,
                      height: 750,
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
                        child: PanelTableSetting(
                            height: 750,
                            mqtt: mqtt,
                            email: widget.email,
                            isAdmin: widget.isAdmin,
                            dataLog: [],
                            onTap: (index) {}),
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
