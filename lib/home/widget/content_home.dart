part of home;

class Content_home extends StatefulWidget {
  Content_home({super.key, required this.scSel});

  ScrollController scSel;

  @override
  State<Content_home> createState() => _Content_homeState();
}

class _Content_homeState extends State<Content_home> {
  final alarm = [
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

  final titleData = ["#Sel", "Celcius", "Volt", "Ampere"];

  // final selScrollController = ScrollController();

  final selData = [
    {"sel": 1, "celcius": 32, "volt": 100, "ampere": 30},
    {"sel": 2, "celcius": 50, "volt": 120, "ampere": 31},
    {"sel": 3, "celcius": 43, "volt": 95, "ampere": 33},
    {"sel": 4, "celcius": 36, "volt": 110, "ampere": 35},
    {"sel": 5, "celcius": 37, "volt": 98, "ampere": 36},
    {"sel": 61, "celcius": 60, "volt": 105, "ampere": 37},
  ];

  final totalData = [
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
                  const SizedBox(
                    height: 20,
                  ),
                  Transform.scale(
                    scale: (lWidth / lheight) < wide ? 1.2 : 1,
                    origin: Offset((lWidth / lheight) < wide ? -800 : 0,
                        (lWidth / lheight) < wide ? -50 : 0),
                    child: SizedBox(
                      width: (lWidth / lheight) < wide ? 2200 : 1270,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilterTgl(
                            title: "Dari",
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          FilterTgl(
                            title: "Hingga",
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          FilterTangki()
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Grafik Nyata",
                                        style: MyTextStyle.defaultFontCustom(
                                            MainStyle.primaryColor, 20),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
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
                                  const SizedBox(
                                    height: 10,
                                  ),
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
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Data Nyata",
                                            style:
                                                MyTextStyle.defaultFontCustom(
                                                    MainStyle.primaryColor, 20),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
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
                                                      itemCount: selData.length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        final val = selData[i];
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
