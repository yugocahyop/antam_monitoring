part of home;

class Content_home_mobile extends StatefulWidget {
  Content_home_mobile(
      {super.key,
      required this.isAdmin,
      required this.mqtt,
      required this.selData,
      required this.scSel,
      required this.menuItem});

  final bool isAdmin;

  List<dynamic> selData;

  MyMqtt mqtt;

  ScrollController scSel;
  List<Map<String, dynamic>> menuItem;

  @override
  State<Content_home_mobile> createState() => _Content_home_mobileState();
}

class _Content_home_mobileState extends State<Content_home_mobile> {
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
    {"title": "Total Waktu", "value": 1, "unit": "Jam"},
    {"title": "Tegangan Total", "value": 23, "unit": "Volt"},
    {"title": "Arus Total", "value": 32, "unit": "Ampere"},
    {"title": "Power", "value": 66, "unit": "Watt"},
    {"title": "Energi", "value": 50, "unit": "Watt_Jam"},
  ];

  var teganganSetting = [FlSpot(0, 1), FlSpot(6, 1)];

  var teganganData = [
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
  ];

  var arusData = [
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
  ];

  var arusSetting = [FlSpot(0, 1), FlSpot(6, 1)];

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

  final filterTglHingga = FilterTgl(
    title: "Hingga",
  );

  final filterTglDari = FilterTgl(
    title: "Dari",
  );

  getTotal(int value, int tangki) {
    // currPage = value;
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
    // setState(() {});
  }

  getData(int tangki) {
    currTangki = tangki;
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
    selData[0].clear();
    for (var i = 1; i < selData.length; i++) {
      final v = selData[i];

      // int count = 1;

      for (Map<String, dynamic> e in v) {
        final c = (e["suhu"] ?? e["celcius"]) as double;
        final vv = (e["tegangan"] ?? e["volt"]) as double;
        final a = (e["arus"] ?? e["ampere"]) as double;
        final w = (e["daya"] ?? e["watt"] ?? 0) as double;
        final en = (e["energi"] ?? e["kwh"] ?? 0) as double;

        selData[0].add({
          "tangki": i.toDouble(),
          "sel": e["sel"] as double,
          "suhu": c,
          "tegangan": vv,
          "arus": a,
          "daya": w,
          "energi": en,
        });

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
  }

  int currTangki = 0;

  initSelData() async {
    final api = ApiHelper();

    while (ApiHelper.tokenMain.isEmpty) {
      await Future.delayed(Duration(seconds: 1));
    }

    final r = await api.callAPI("/monitoring/find/last", "POST", "", true);

    if (kDebugMode) {
      print("backend data: $r");
    }

    if (r["error"] == null) {
      selData.clear();

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

      selData.addAll(r["data"][0]["tangkiData"] ?? []);
    }

    if (mounted) setState(() {});

    getMax2();

    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      if (mounted) setState(() {});
      getData(0);

      Future.delayed(Duration(milliseconds: 300), () {
        setSetting("tegangan", 3);
        setSetting("arus", 100);
        initMqtt();
      });
    });
  }

  initMqtt() {
    mqtt.onUpdate = (data, topic) {
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

          selData[tangki][(data["sel"] as int) - 1][title] = sData[title];
        }

        getMax();

        getData(currTangki);
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

      if (mounted) {
        setState(() {});
      }

      // Future.delayed(Duration(milliseconds: 500), () {

      // });
    };
  }

  late Account_alarm account_alarm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

    initSelData();
    // getMax2();
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: lWidth,
      height: lheight,
      child: Stack(
        children: [
          Container(
              // padding: EdgeInsets.fromLTRB(45, 30, 30, 0),
              width: lWidth,
              height: lheight,
              child: Column(
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
                            child: Divider(
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
                              padding: EdgeInsets.all(10),
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
                                Align(
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
                                Align(
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
                                          max: teganganSetting.first.y,
                                          title: "",
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
                              height: 210,
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
                                      children: (selData[int.tryParse(
                                                  filterTangki.tangkiValue) ??
                                              0] as List<dynamic>)
                                          .map((e) => Container(
                                                margin:
                                                    EdgeInsets.only(right: 70),
                                                clipBehavior: Clip.none,
                                                width: lWidth,
                                                // height: 100,
                                                decoration: BoxDecoration(
                                                    color:
                                                        MainStyle.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32)),
                                                child: Transform.scale(
                                                  scale: 1.4,
                                                  origin: Offset(-170, -70),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Transform.translate(
                                                          offset:
                                                              Offset(0, -30),
                                                          child: Text(
                                                            "#",
                                                            style: MyTextStyle
                                                                .defaultFontCustom(
                                                                    Colors
                                                                        .white30,
                                                                    120),
                                                          ),
                                                        ),
                                                        Transform.translate(
                                                          offset:
                                                              Offset(0, -20),
                                                          child: Text(
                                                            "  Sel ${e["sel"]}",
                                                            style: MyTextStyle
                                                                .defaultFontCustom(
                                                                    Colors
                                                                        .white,
                                                                    20),
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                              ))
                                          .toList(),
                                    )),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                MainStyle.sizedBoxH20,
                                PageViewDotIndicator(
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
                            const SizedBox(
                              height: 13,
                            ),
                            FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Container(
                                clipBehavior: Clip.none,
                                padding: EdgeInsets.all(10),
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
                                            decoration: BoxDecoration(),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    e["title"] as String,
                                                    style: MyTextStyle
                                                        .defaultFontCustom(
                                                            Colors.black, 15,
                                                            weight: FontWeight
                                                                .bold),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  clipBehavior: Clip.none,
                                                  // width: 300,
                                                  height: 35,
                                                  padding: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: grad_colors,
                                                        stops: [0, 0.6, 1],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
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
                                                        clipBehavior: Clip.none,
                                                        decoration:
                                                            BoxDecoration(),
                                                        width: 200,
                                                        child: Text(
                                                          (e["value"] as double)
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
                                                          e["unit"] as String,
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: MyTextStyle
                                                              .defaultFontCustom(
                                                                  Colors.black,
                                                                  15,
                                                                  weight:
                                                                      FontWeight
                                                                          .bold),
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
              )),
          Center(
            //warning
            child: Visibility(
              visible: isMsgVisible,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: msgOpacity,
                onEnd: () {
                  if (msgOpacity == 0 && mounted) {
                    setState(() {
                      isMsgVisible = false;
                    });
                  }
                },
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.only(top: 30),
                    width: lWidth > 600 ? lWidth * 0.7 : 500,
                    height: 400,
                    decoration: BoxDecoration(
                        color: const Color(0xffFEF7F1),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
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
                            height: 270,
                            decoration: BoxDecoration(
                              color: const Color(0xffDF7B00),
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
                                  Icon(
                                    Icons.info_rounded,
                                    color: const Color(0xffDF7B00),
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
                                height: lheight < 450 ? 100 : 200,
                                width: lWidth * 0.6,
                                child: Center(
                                  child: Text(
                                    warningMsg,
                                    textAlign: TextAlign.center,
                                    style: MyTextStyle.defaultFontCustom(
                                        Colors.black, lheight < 400 ? 20 : 40,
                                        weight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: lWidth > 600 ? lWidth * 0.6 : 420,
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: lWidth,
              height: lheight < 400 ? 60 : 100,
              decoration: BoxDecoration(
                  color: MainStyle.secondaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, -2),
                        blurRadius: 10,
                        spreadRadius: 0,
                        color: Colors.black26)
                  ]),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.menuItem
                      .map((e) => GestureDetector(
                            onTap: () {
                              widget.menuItem
                                  .where(
                                      (element) => element["isActive"] as bool)
                                  .first["isActive"] = false;

                              setState(() {
                                e["isActive"] = true;
                              });
                            },
                            child: Container(
                              width: 120,
                              color: Colors.transparent,
                              height: lheight < 400 ? 60 : 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    height: 25,
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            width:
                                                e["isActive"] as bool ? 50 : 0,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: e["isActive"] as bool
                                                  ? MainStyle.primaryColor
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Icon(
                                            e["icon"],
                                            size: lheight < 400 ? 20 : 25,
                                            color: e["isActive"] as bool
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   height: 5,
                                  // ),
                                  MainStyle.sizedBoxH5,
                                  Visibility(
                                    visible: lheight >= 400,
                                    child: Center(
                                      child: Text(
                                        e["title"],
                                        style: MyTextStyle.defaultFontCustom(
                                            e["isActive"] as bool
                                                ? MainStyle.primaryColor
                                                : Colors.grey,
                                            lWidth > 700
                                                ? 9
                                                : lWidth > 600
                                                    ? 10
                                                    : 15,
                                            weight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
