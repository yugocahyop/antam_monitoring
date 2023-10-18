part of home;

class Content_home_mobile extends StatefulWidget {
  Content_home_mobile({super.key, required this.scSel, required this.menuItem});

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
      "isActive": true,
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

  var selData = [
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

  List<FlSpot> teganganData = [
    // FlSpot(1, 20),
    // FlSpot(2, 30),
    // FlSpot(3, 15),
    // FlSpot(4, 60),
    // FlSpot(5, 15),
    // FlSpot(6, 40)
  ];

  List<FlSpot> arusData = [
    // FlSpot(1, 20),
    // FlSpot(2, 30),
    // FlSpot(3, 15),
    // FlSpot(4, 60),
    // FlSpot(5, 15),
    // FlSpot(6, 40)
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

  int currPage = 0;

  late FilterTangki filterTangki;

  final filterTglHingga = FilterTgl(
    title: "Hingga",
  );

  final filterTglDari = FilterTgl(
    title: "Dari",
  );

  getTotal(int value, int tangki) {
    currPage = value;
    final d = selData[tangki]
        .where((element) => element["sel"] as int == (value + 1))
        .first;

    totalData
        .where((element) => element["title"] == "Tegangan Total")
        .first["value"] = d["volt"] as int;
    totalData
        .where((element) => element["title"] == "Arus Total")
        .first["value"] = d["ampere"] as int;
    setState(() {});
  }

  getData(int tangki) {
    teganganData = [];

    arusData = [];

    selData[tangki].forEach((e) {
      teganganData.add(
          FlSpot((e["sel"] as int).toDouble(), (e["volt"] as int).toDouble()));

      arusData.add(FlSpot(
          (e["sel"] as int).toDouble(), (e["ampere"] as int).toDouble()));
    });

    // if (pc.page != null) {
    getTotal(currPage, tangki);
    // }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    filterTangki = FilterTangki(
      tangkiValue: "1",
      items: ["1", "2", "3", "4", "5", "6"],
      onChange: (value) => getData(int.tryParse(value) ?? 0),
    );

    final r = Random(70);

    for (var i = 0; i < selData.length; i++) {
      final v = selData[i];
      v.forEach((e) {
        e["celcius"] = r.nextInt(70);
        e["volt"] = r.nextInt(70);
        e["ampere"] = r.nextInt(70);
        //  e["celcius"] = (e["celcius"] as int) + 1;
      });
    }

    getData(0);
    getTotal(0, 0);
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
                        SizedBox(
                            height: 20, child: Account_alarm(alarm: alarm)),
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
                                    child: Text("Arus (A)")),
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
                                      children: selData[int.tryParse(
                                                  filterTangki.tangkiValue) ??
                                              0]
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
                                                          (e["value"] as int)
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
                  if (msgOpacity == 0) {
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
                              // height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 50,
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
