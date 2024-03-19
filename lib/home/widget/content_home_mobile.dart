import 'package:antam_monitoring/home/widget/mobilePage/callMobile.dart';
import 'package:antam_monitoring/home/widget/mobilePage/dataloggerMobile.dart';
import 'package:antam_monitoring/home/widget/mobilePage/diagnosticMobile.dart';
import 'package:antam_monitoring/home/widget/mobilePage/settingMobile.dart';
import 'package:antam_monitoring/tools/mqtt/mqtt.dart';
import 'package:flutter/material.dart';

import '../../style/mainStyle.dart';
import '../../style/textStyle.dart';
import '../../widget/myButton.dart';
import 'mobilePage/homeMobile.dart';

class Content_home_mobile extends StatefulWidget {
  Content_home_mobile(
      {super.key,
      required this.email,
      required this.page,
      required this.changePage,
      required this.isAdmin,
      required this.mqtt,
      required this.selData,
      required this.scSel,
      required this.menuItem});

  final bool isAdmin;

  String email;

  List<dynamic> selData;

  MyMqtt mqtt;

  int page;

  Function(int index, {int? dari, int? hingga}) changePage;

  ScrollController scSel;
  List<Map<String, dynamic>> menuItem;

  @override
  State<Content_home_mobile> createState() => _Content_home_mobileState();
}

class _Content_home_mobileState extends State<Content_home_mobile> {
  String warningMsg = "Message";

  double msgOpacity = 0;

  bool isMsgVisible = false;

  late PageController pc;

  int dari = 0, hingga = 0;

  changePage(int i, {int? dari, int? hingga}) {
    this.dari = dari ?? 0;
    this.hingga = hingga ?? 0;

    widget.menuItem
        .where((element) => element["isActive"] as bool)
        .first["isActive"] = false;

    // setState(() {
    widget.menuItem.firstWhere(
        (element) => element["title"] == "Data Logger")["isActive"] = true;
    // });

    setState(() {});

    pc.animateToPage(1,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  changePage2(int i, {int? dari, int? hingga}) {
    this.dari = dari ?? 0;
    this.hingga = hingga ?? 0;

    widget.menuItem
        .where((element) => element["isActive"] as bool)
        .first["isActive"] = false;

    // setState(() {

    switch (i) {
      case 0:
        widget.menuItem.firstWhere(
            (element) => element["title"] == "Home")["isActive"] = true;
        break;
      case 1:
        widget.menuItem.firstWhere(
            (element) => element["title"] == "Data Logger")["isActive"] = true;
        break;
      case 2:
        widget.menuItem.firstWhere(
            (element) => element["title"] == "Diagnostic")["isActive"] = true;
        break;
      case 3:
        widget.menuItem.firstWhere(
                (element) => element["title"] == "Emergency Call")["isActive"] =
            true;
        break;
      case 4:
        widget.menuItem.firstWhere(
            (element) => element["title"] == "Settings")["isActive"] = true;
        break;
      default:
    }

    // });

    setState(() {});

    pc.animateToPage(i,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pc = PageController(
      initialPage: widget.page,
    );

    // pc.jumpToPage(widget.page);

    Future.delayed(const Duration(seconds: 1), () {
      changePage2(widget.page);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    widget.scSel.dispose();
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
              child: PageView(
                controller: pc,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  HomeMobile(
                      changePage: changePage,
                      isAdmin: widget.isAdmin,
                      mqtt: widget.mqtt,
                      selData: widget.selData,
                      scSel: ScrollController(),
                      menuItem: widget.menuItem),
                  DataLogger(
                      dari: dari,
                      hingga: hingga,
                      changePage: changePage,
                      isAdmin: widget.isAdmin,
                      mqtt: widget.mqtt,
                      selData: widget.selData,
                      scSel: ScrollController(),
                      menuItem: widget.menuItem),
                  DiagnosticMobile(
                      changePage: changePage,
                      isAdmin: widget.isAdmin,
                      mqtt: widget.mqtt,
                      selData: widget.selData,
                      scSel: ScrollController(),
                      menuItem: widget.menuItem),
                  CallMobile(
                      changePage: changePage,
                      isAdmin: widget.isAdmin,
                      mqtt: widget.mqtt,
                      selData: widget.selData,
                      scSel: ScrollController(),
                      menuItem: widget.menuItem),
                  SettingMobile(
                      email: widget.email,
                      changePage: changePage,
                      isAdmin: widget.isAdmin,
                      mqtt: widget.mqtt,
                      selData: widget.selData,
                      scSel: ScrollController(),
                      menuItem: widget.menuItem),
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
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.only(top: 30),
                    width: lWidth > 600 ? lWidth * 0.7 : 500,
                    height: 400,
                    decoration: BoxDecoration(
                        color: const Color(0xffFEF7F1),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
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
              decoration: const BoxDecoration(
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
                            onTap: () async {
                              widget.menuItem
                                  .where(
                                      (element) => element["isActive"] as bool)
                                  .first["isActive"] = false;

                              setState(() {
                                e["isActive"] = true;
                              });

                              widget.changePage(widget.menuItem.indexOf(e));

                              await Future.delayed(
                                  const Duration(milliseconds: 200));

                              pc.animateToPage(widget.menuItem.indexOf(e),
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.ease);
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
