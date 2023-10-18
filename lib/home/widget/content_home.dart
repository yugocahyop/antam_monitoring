part of home;

class Content_home extends StatefulWidget {
  Content_home({super.key, required this.scSel});

  ScrollController scSel;

  @override
  State<Content_home> createState() => _Content_homeState();
}

class _Content_homeState extends State<Content_home> {
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

  var titleData = ["#Sel", "Celcius", "Volt", "Ampere"];

  // final selScrollController = ScrollController();

  var selData = [
    [
      {
        "sel": 1,
        "celcius": double.minPositive.toInt(),
        "volt": double.minPositive.toInt(),
        "ampere": double.minPositive.toInt()
      },
      {
        "sel": 2,
        "celcius": double.minPositive.toInt(),
        "volt": double.minPositive.toInt(),
        "ampere": double.minPositive.toInt()
      },
      {
        "sel": 3,
        "celcius": double.minPositive.toInt(),
        "volt": double.minPositive.toInt(),
        "ampere": double.minPositive.toInt()
      },
      {
        "sel": 4,
        "celcius": double.minPositive.toInt(),
        "volt": double.minPositive.toInt(),
        "ampere": double.minPositive.toInt()
      },
      {
        "sel": 5,
        "celcius": double.minPositive.toInt(),
        "volt": double.minPositive.toInt(),
        "ampere": double.minPositive.toInt()
      },
      {
        "sel": 6,
        "celcius": double.minPositive.toInt(),
        "volt": double.minPositive.toInt(),
        "ampere": double.minPositive.toInt()
      },
    ],
    [
      {"sel": 1, "celcius": 32, "volt": 60, "ampere": 30},
      {"sel": 2, "celcius": 50, "volt": 50, "ampere": 31},
      {"sel": 3, "celcius": 43, "volt": 20, "ampere": 33},
      {"sel": 4, "celcius": 36, "volt": 35, "ampere": 35},
      {"sel": 5, "celcius": 37, "volt": 65, "ampere": 36},
      {"sel": 6, "celcius": 60, "volt": 55, "ampere": 37},
    ],
    [
      {"sel": 1, "celcius": 32, "volt": 60, "ampere": 30},
      {"sel": 2, "celcius": 50, "volt": 50, "ampere": 31},
      {"sel": 3, "celcius": 43, "volt": 20, "ampere": 33},
      {"sel": 4, "celcius": 36, "volt": 35, "ampere": 35},
      {"sel": 5, "celcius": 37, "volt": 65, "ampere": 36},
      {"sel": 6, "celcius": 60, "volt": 55, "ampere": 37},
    ],
    [
      {"sel": 1, "celcius": 32, "volt": 60, "ampere": 30},
      {"sel": 2, "celcius": 50, "volt": 50, "ampere": 31},
      {"sel": 3, "celcius": 43, "volt": 20, "ampere": 33},
      {"sel": 4, "celcius": 36, "volt": 35, "ampere": 35},
      {"sel": 5, "celcius": 37, "volt": 65, "ampere": 36},
      {"sel": 6, "celcius": 60, "volt": 55, "ampere": 37},
    ],
    [
      {"sel": 1, "celcius": 32, "volt": 60, "ampere": 30},
      {"sel": 2, "celcius": 50, "volt": 50, "ampere": 31},
      {"sel": 3, "celcius": 43, "volt": 20, "ampere": 33},
      {"sel": 4, "celcius": 36, "volt": 35, "ampere": 35},
      {"sel": 5, "celcius": 37, "volt": 65, "ampere": 36},
      {"sel": 6, "celcius": 60, "volt": 55, "ampere": 37},
    ],
    [
      {"sel": 1, "celcius": 32, "volt": 60, "ampere": 30},
      {"sel": 2, "celcius": 50, "volt": 50, "ampere": 31},
      {"sel": 3, "celcius": 43, "volt": 20, "ampere": 33},
      {"sel": 4, "celcius": 36, "volt": 35, "ampere": 35},
      {"sel": 5, "celcius": 37, "volt": 65, "ampere": 36},
      {"sel": 6, "celcius": 60, "volt": 55, "ampere": 37},
    ],
    [
      {"sel": 1, "celcius": 32, "volt": 60, "ampere": 30},
      {"sel": 2, "celcius": 50, "volt": 50, "ampere": 31},
      {"sel": 3, "celcius": 43, "volt": 20, "ampere": 33},
      {"sel": 4, "celcius": 36, "volt": 35, "ampere": 35},
      {"sel": 5, "celcius": 37, "volt": 65, "ampere": 36},
      {"sel": 6, "celcius": 60, "volt": 55, "ampere": 37},
    ],
  ];

  var totalData = [
    {"title": "Total Waktu", "value": 1, "unit": "Jam"},
    {"title": "Tegangan Total", "value": 23, "unit": "Volt"},
    {"title": "Arus Total", "value": 32, "unit": "Ampere"},
    {"title": "Power", "value": 66, "unit": "Watt"},
    {"title": "Energi", "value": 50, "unit": "Watt_Jam"},
  ];

  var teganganSetting = [FlSpot(0, 70), FlSpot(6, 70)];

  var teganganData = [
    FlSpot(1, 20),
    FlSpot(2, 30),
    FlSpot(3, 15),
    FlSpot(4, 60),
    FlSpot(5, 15),
    FlSpot(6, 40)
  ];

  var arusData = [
    FlSpot(1, 20),
    FlSpot(2, 30),
    FlSpot(3, 15),
    FlSpot(4, 60),
    FlSpot(5, 15),
    FlSpot(6, 40)
  ];

  var arusSetting = [FlSpot(0, 70), FlSpot(6, 70)];

  final grad_colors = [
    MainStyle.primaryColor.withAlpha(((255 * 0.4) * 0.3).toInt()),
    MainStyle.primaryColor.withAlpha(((255 * 0.3) * 0.3).toInt()),
    MainStyle.primaryColor.withAlpha(((255 * 0.1) * 0.3).toInt()),
  ];

  String warningMsg = "Message";

  double msgOpacity = 1;

  bool isMsgVisible = true;

  final double wide = 16 / 9;

  final filterTglHingga = FilterTgl(
    title: "Hingga",
  );

  final filterTglDari = FilterTgl(
    title: "Dari",
  );

  getTotal(int tangki) {
    final d = selData[tangki];

    int totalArus = 0;
    int totalTegangan = 0;

    d.forEach((element) {
      totalArus += element["ampere"] as int;
      totalTegangan += element["volt"] as int;
    });

    totalData
        .where((element) => element["title"] == "Tegangan Total")
        .first["value"] = totalTegangan;
    totalData
        .where((element) => element["title"] == "Arus Total")
        .first["value"] = totalArus;

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
    teganganData = [];

    arusData = [];

    for (var e in selData[tangki]) {
      teganganData.add(
          FlSpot((e["sel"] as int).toDouble(), (e["volt"] as int).toDouble()));

      arusData.add(FlSpot(
          (e["sel"] as int).toDouble(), (e["ampere"] as int).toDouble()));
    }

    getTotal(tangki);

    setState(() {});
  }

  late FilterTangki filterTangki;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    filterTangki = FilterTangki(
      tangkiValue: "Semua",
      items: ["Semua", "1", "2", "3", "4", "5", "6"],
      onChange: (value) => getData(int.tryParse(value) ?? 0),
    );

    // if (kDebugMode) {
    //   print("sel length: ${selData.length}");
    // }

    final r = Random(70);

    for (var i = 1; i < selData.length; i++) {
      final v = selData[i];
      for (var e in v) {
        final c = e["celcius"] = r.nextInt(70);
        final vv = e["volt"] = r.nextInt(70);
        final a = e["ampere"] = r.nextInt(70);
        //  e["celcius"] = (e["celcius"] as int) + 1;
        final index = v.indexOf(e);
        selData[0][index]["celcius"] =
            max(selData[0][index]["celcius"] as int, c);
        selData[0][index]["volt"] = max(selData[0][index]["volt"] as int, vv);
        selData[0][index]["ampere"] =
            max(selData[0][index]["ampere"] as int, a);
      }

      // if (kDebugMode) {
      //   print("sel data 0 : ${selData[0][0].toString()}");
      // }
    }

    getData(0);

    // getTotal(0);
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: (lWidth / lheight) < wide ? 1800 : 1270,
      height: (lWidth / lheight) < wide ? 1400 : 740,
      child: Stack(
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(45, 30, 30, 10),
              width: (lWidth / lheight) < wide ? 2200 : 1270,
              height: (lWidth / lheight) < wide ? 1400 : 740,
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
                      width: (lWidth / lheight) < wide ? 2200 : 1270,
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
                      width: (lWidth / lheight) < wide ? 2200 : 1270,
                      child: Transform.scale(
                        scale: (lWidth / lheight) < wide ? 1.2 : 1,
                        origin: Offset((lWidth / lheight) < wide ? -1010 : 0,
                            (lWidth / lheight) < wide ? -50 : 0),
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: (lWidth / lheight) < wide ? 1.35 : 1,
                              origin: Offset(
                                  (lWidth / lheight) < wide ? -300 : 0, 0),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: 600,
                                height: 620,
                                decoration: BoxDecoration(
                                    color: MainStyle.secondaryColor,
                                    borderRadius: BorderRadius.circular(30),
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
                                      child: Text(
                                        "Tegangan (V)",
                                        style: MyTextStyle.defaultFontCustom(
                                            Colors.black, 14),
                                      )),
                                  SizedBox(
                                    width: 1200,
                                    height: 230,
                                    child: Stack(
                                      children: [
                                        MyLineChart(points: teganganSetting),
                                        MyBarChart(
                                            title: "", points: teganganData),
                                      ],
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  MainStyle.sizedBoxH10,
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Arus (A)",
                                        style: MyTextStyle.defaultFontCustom(
                                            Colors.black, 14),
                                      )),
                                  SizedBox(
                                    width: 1200,
                                    height: 230,
                                    child: Stack(
                                      children: [
                                        MyLineChart(points: arusSetting),
                                        MyBarChart(title: "", points: arusData),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Transform.scale(
                              scale: (lWidth / lheight) < wide ? 1.18 : 1,
                              origin: Offset(
                                  (lWidth / lheight) < wide ? -1350 : 0,
                                  (lWidth / lheight) < wide ? -1900 : 0),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width: 550,
                                    height: 320,
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
                                                    MainStyle.primaryColor, 20),
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
                                                  color: MainStyle.primaryColor
                                                      .withAlpha(
                                                          (255 * 0.15).toInt()),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 5,
                                                  spreadRadius: 0),
                                              BoxShadow(
                                                  color: MainStyle.primaryColor
                                                      .withAlpha(
                                                          (255 * 0.15).toInt()),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 30,
                                                  spreadRadius: 0)
                                            ]),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              width: 500,
                                              decoration: BoxDecoration(
                                                  color: MainStyle.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  4),
                                                          topRight:
                                                              Radius.circular(
                                                                  4))),
                                              child: Row(
                                                children: titleData
                                                    .map((e) => SizedBox(
                                                          width: 120,
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
                                                width: 500,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffC1E1DF),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(4),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    4))),
                                                child: Scrollbar(
                                                  thumbVisibility: true,
                                                  controller: widget.scSel,
                                                  child: ListView.builder(
                                                      controller: widget.scSel,
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
                                                        val.forEach(
                                                            (key, value) =>
                                                                listSel.add(
                                                                    SizedBox(
                                                                  width: 120,
                                                                  height: 35,
                                                                  child: Center(
                                                                    child: Text(
                                                                      (value as int)
                                                                              .toString() +
                                                                          (key == "celcius"
                                                                              ? "\u00B0"
                                                                              : ""),
                                                                      style: MyTextStyle.defaultFontCustom(
                                                                          Colors
                                                                              .black,
                                                                          15),
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
                                                              width: 500,
                                                              child: Divider(
                                                                color: const Color(
                                                                    0xff9ACBC7),
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
                                    width: 550,
                                    height: 250,
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
                                                            width: 200,
                                                            child: Text(
                                                              (e["value"]
                                                                      as int)
                                                                  .toString(),
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
                                                                      weight: FontWeight
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
                                ],
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
                                      textColor: Colors.black),
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
