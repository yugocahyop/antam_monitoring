part of home;

class Content_diagnostic extends StatefulWidget {
  Content_diagnostic(
      {super.key,
      required this.scSel,
      required this.selData,
      required this.mqtt});

  List<dynamic> selData;

  MyMqtt mqtt;

  ScrollController scSel;

  @override
  State<Content_diagnostic> createState() => _Content_diagnosticState();
}

class _Content_diagnosticState extends State<Content_diagnostic> {
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

  togglePanelMqtt(int tangki, int sel, bool isActive) {
    mqtt!.publish({
      "tangki": tangki,
      "node": sel,
      "activate": isActive ? false : true
      // "status": isActive ? false : true
    }, "antam/command");
  }

  List<Widget> getDiagnostiWidget(double width) {
    List<Widget> rows = [];

    for (var i = 0; i < diagnosticData.length; i++) {
      final sel = diagnosticData[i];
      List<Widget> pn = [];

      DateFormat df = DateFormat("dd MMMM yyyy");

      for (var ii = 0; ii < sel.length; ii++) {
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(sel[ii]["lastUpdated"] as int);
        String status = sel[ii]["status"] as String;
        pn.add(InkWell(
          splashColor: Colors.transparent,
          onTap: (() => togglePanelMqtt(
              i + 1, ii + 1, status == "active" ? true : false)),
          child: PanelNode(
              isSensor: i == 6,
              width: width,
              tangki: i + 1,
              sel: ii + 1,
              status: status,
              lastUpdated: df.format(date)),
        ));
      }

      rows.add(SizedBox(
        height: width,
        child: Stack(
          children: [
            Center(
              child: Visibility(
                visible: (i != 6),
                child: SizedBox(
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

      rows.add(SizedBox(
        height: 7,
      ));
    }

    return rows;
  }

  var totalData = [
    {"title": "Total Waktu", "value": 0.0, "unit": "Jam"},
    {"title": "Tegangan Total", "value": 0.0, "unit": "Volt"},
    {"title": "Arus Total", "value": 0.0, "unit": "Ampere"},
    {"title": "Power", "value": 0.0, "unit": "Watt"},
    {"title": "Energi", "value": 0.0, "unit": "Watt_Jam"},
  ];

  var teganganSetting = [FlSpot(0, 1), FlSpot(6, 1)];

  var teganganData = [
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
    FlSpot(6, 0)
  ];

  var arusData = [
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
    FlSpot(6, 0)
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

  final double wide = 16 / 9;

  final filterTglHingga = FilterTgl(
    title: "Hingga",
  );

  final filterTglDari = FilterTgl(
    title: "Dari",
  );

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // if (mqtt != null) {
    //   mqtt!.disconnect();
    // }
  }

  int currTangki = 0;

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
      ]);

      selData.addAll(r["data"][0]["tangkiData"] ?? []);
    }

    setState(() {});

    getMax();

    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {});
      getData(0);

      Future.delayed(Duration(milliseconds: 300), () {
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

      if (topic == "antam/statusNode" || topic == "antam/statusnode") {
        int tangki = data["tangki"] as int;
        int sel = data["node"] as int;
        String status = data["status"] as String;
        int timeStamp =
            DateTime.now().millisecondsSinceEpoch - (data["timestamp"] as int);

        DateFormat df = DateFormat("dd MMMM yyyy");

        DateTime date = DateTime(timeStamp);

        diagnosticData[tangki - 1][sel - 1]["status"] = status;
        diagnosticData[tangki - 1][sel - 1]["lastUpdated"] = df.format(date);
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

        if (tangki > (selData.length - 1)) {
          for (var i = 0; i < (tangki - (selData.length - 1)); i++) {
            selData.add([
              {"sel": 1, "celcius": 0, "volt": 0, "ampere": 0},
              {"sel": 2, "celcius": 0, "volt": 0, "ampere": 0},
              {"sel": 3, "celcius": 0, "volt": 0, "ampere": 0},
              {"sel": 4, "celcius": 0, "volt": 0, "ampere": 0},
              {"sel": 5, "celcius": 0, "volt": 0, "ampere": 0},
              {"sel": 6, "celcius": 0, "volt": 0, "ampere": 0}
            ]);
          }
        }
        final sData = jsonEncode(Map.from(data["selData"]));

        if (kDebugMode) {
          print((sData));
        }

        selData[tangki][data["sel"] as int] =
            (jsonDecode(sData)) as Map<String, num>;

        getMax();

        List<String> items = [];

        items.add("Semua");

        for (var i = 0; i < selData.length; i++) {
          items.add((i + 1).toString());
        }

        filterTangki = FilterTangki(
          tangkiValue: currTangki.toString(),
          items: items,
          onChange: (value) => getData(int.tryParse(value) ?? 0),
        );

        getData(currTangki);

        // getTotal(currPage, currTangki);
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

    mqtt = widget.mqtt;

    selData = widget.selData;

    // getData(0);

    filterTangki = FilterTangki(
      tangkiValue: "Semua",
      items: ["Semua", "1", "2", "3", "4", "5", "6"],
      onChange: (value) => getData(int.tryParse(value) ?? 0),
    );

    // getMax();

    initSelData();
    initTotalDataStatistic();
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
              padding: EdgeInsets.fromLTRB(45, 30, 30, 10),
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
                      child: Account_alarm(alarm: alarm)),
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
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: 500,
                                  height: 620,
                                  decoration: BoxDecoration(
                                      color: MainStyle.secondaryColor,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(4, 4),
                                            color: MainStyle.primaryColor
                                                .withAlpha(
                                                    (255 * 0.05).toInt()),
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
                                                .withAlpha(
                                                    (255 * 0.10).toInt()),
                                            blurRadius: 20,
                                            spreadRadius: 0),
                                      ]),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        // SvgPicture.asset(
                                        //   "assets/monitoring.svg",
                                        //   width: 30,
                                        //   color: MainStyle.primaryColor,
                                        // ),
                                        Icon(
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
                                          style: MyTextStyle.defaultFontCustom(
                                              MainStyle.primaryColor, 20),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(children: getDiagnostiWidget(70))
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
                                      padding: EdgeInsets.all(10),
                                      width: 650,
                                      height: 320,
                                      decoration: BoxDecoration(
                                          color: MainStyle.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(4, 4),
                                                color: MainStyle.primaryColor
                                                    .withAlpha(
                                                        (255 * 0.05).toInt()),
                                                blurRadius: 10,
                                                spreadRadius: 0),
                                            BoxShadow(
                                                offset: Offset(-4, -4),
                                                color: Colors.white.withAlpha(
                                                    (255 * 0.5).toInt()),
                                                blurRadius: 13,
                                                spreadRadius: 0),
                                            BoxShadow(
                                                offset: Offset(6, 6),
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
                                                    offset: Offset(0, 3),
                                                    blurRadius: 5,
                                                    spreadRadius: 0),
                                                BoxShadow(
                                                    color: MainStyle
                                                        .primaryColor
                                                        .withAlpha((255 * 0.15)
                                                            .toInt()),
                                                    offset: Offset(0, 3),
                                                    blurRadius: 30,
                                                    spreadRadius: 0)
                                              ]),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                width: 600,
                                                decoration: BoxDecoration(
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
                                                      .map((e) => SizedBox(
                                                            width: 90,
                                                            child: Center(
                                                              child: Text(
                                                                e,
                                                                style: MyTextStyle
                                                                    .defaultFontCustom(
                                                                        Colors
                                                                            .white,
                                                                        14),
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                ),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.all(8),
                                                  width: 600,
                                                  height: 200,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffC1E1DF),
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
                                                                          padding:
                                                                              EdgeInsets.all(2),
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
                                                                    Divider(
                                                                      color: const Color(
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
                                      padding: EdgeInsets.all(10),
                                      width: 650,
                                      height: 250,
                                      decoration: BoxDecoration(
                                          color: MainStyle.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(4, 4),
                                                color: MainStyle.primaryColor
                                                    .withAlpha(
                                                        (255 * 0.05).toInt()),
                                                blurRadius: 10,
                                                spreadRadius: 0),
                                            BoxShadow(
                                                offset: Offset(-4, -4),
                                                color: Colors.white.withAlpha(
                                                    (255 * 0.5).toInt()),
                                                blurRadius: 13,
                                                spreadRadius: 0),
                                            BoxShadow(
                                                offset: Offset(6, 6),
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
                                                  decoration: BoxDecoration(),
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
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        clipBehavior: Clip.none,
                                                        // width: 300,
                                                        height: 35,
                                                        padding:
                                                            EdgeInsets.all(3),
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
                                                                  BoxDecoration(),
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
                    padding: EdgeInsets.only(top: 30),
                    width: 700,
                    height: 500,
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
                            height: 400,
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
