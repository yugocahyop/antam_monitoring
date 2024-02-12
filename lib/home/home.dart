library home;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
// import 'dart:js_interop';
import 'dart:math';

// import 'dart:ui_web';

import 'package:antam_monitoring/home/model/homeArgument.dart';
import 'package:antam_monitoring/home/widget/content_call/widget/phonePanel.dart'
    if (dart.library.html) 'package:antam_monitoring/home/widget/content_call/widget/phonePanelWeb.dart';
import 'package:antam_monitoring/home/widget/content_dataLogger/widget/panelTable.dart';
import 'package:antam_monitoring/home/widget/content_diagnostic/widget/panelNode.dart';
import 'package:antam_monitoring/home/widget/content_setting/widget/panelTableSetting.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/tools/encrypt.dart';
import 'package:antam_monitoring/tools/mqtt/mqtt.dart';
import 'package:antam_monitoring/widget/barChart.dart';
import 'package:antam_monitoring/widget/linechart.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
// import 'package:mqtt_client/mqtt_client.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../controller/controller.dart';

part 'widget/menu.dart';
part 'widget/content_home.dart';
part 'widget/account_alarm.dart';
part 'widget/filterTgl.dart';
part 'widget/myDropDown.dart';
part 'widget/filterTangki.dart';
part 'widget/content_home_mobile.dart';
part 'widget/up.dart';
part 'widget/content_diagnostic/content_diagnostic.dart';
part 'widget/content_call/content_call.dart';
part 'widget/content_setting/content_setting.dart';
part 'widget/content_dataLogger/content_dataLogger.dart';
part 'widget/content_dataLogger/content_dataLogger2.dart';

class Home extends StatefulWidget {
  Home({super.key});

  static String email = "";
  static bool isAdmin = false;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
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

  List<dynamic> selData = [
    [
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

  changePage(int p) {
    switch (p) {
      case 0:
        setState(() {
          page = Content_home(
            isAdmin: isAdmin,
            mqtt: mqtt,
            scSel: scSel,
            selData: selData,
          );
          pageMobile = Content_home_mobile(
            isAdmin: isAdmin,
            mqtt: mqtt,
            selData: selData,
            scSel: scSel,
            menuItem: menuItems,
          );
        });
        break;
      case 1:
        setState(() {
          page = Content_dataLogger2(
            isAdmin: isAdmin,
            mqtt: mqtt,
            scSel: scSel,
            selData: selData,
          );
          pageMobile = Content_home_mobile(
            isAdmin: isAdmin,
            mqtt: mqtt,
            selData: selData,
            scSel: scSel,
            menuItem: menuItems,
          );
        });
        break;
      case 2:
        setState(() {
          page = Content_diagnostic(
            isAdmin: isAdmin,
            mqtt: mqtt,
            scSel: scSel,
            selData: selData,
          );
          pageMobile = Content_home_mobile(
            isAdmin: isAdmin,
            mqtt: mqtt,
            selData: selData,
            scSel: scSel,
            menuItem: menuItems,
          );
        });

        break;
      case 3:
        setState(() {
          page = Content_call(
            isAdmin: false,
            mqtt: mqtt,
            scSel: scSel,
            selData: selData,
          );
          pageMobile = Content_home_mobile(
            isAdmin: isAdmin,
            mqtt: mqtt,
            selData: selData,
            scSel: scSel,
            menuItem: menuItems,
          );
        });

        break;
      case 4:
        setState(() {
          page = Content_setting(
            email: email,
            isAdmin: isAdmin,
            mqtt: mqtt,
            scSel: scSel,
            selData: selData,
          );
          pageMobile = Content_home_mobile(
            isAdmin: isAdmin,
            mqtt: mqtt,
            selData: selData,
            scSel: scSel,
            menuItem: menuItems,
          );
        });

        break;
    }
  }

  late Widget page;
  late Widget pageMobile;

  late List<Map<String, dynamic>> menuItems;

  var scMain = ScrollController();
  var scSel = ScrollController();

  final double wide = 16 / 9;

  late MyMqtt mqtt;

  initToken() async {
    if (ApiHelper.tokenMain.isEmpty) {
      final c = Controller();
      final encrypt = MyEncrtypt();

      final tokenEncrypted = await c.loadSharedPref("antam.data", "String");
      ApiHelper.tokenMain = encrypt.decrypt(tokenEncrypted);
    }
  }

  late Timer timer;

  void onFocus(Event e) {
    didChangeAppLifecycleState(AppLifecycleState.resumed);
  }

  void onBlur(Event e) {
    didChangeAppLifecycleState(AppLifecycleState.paused);
  }

  String email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    // WidgetsBinding.instance!.addObserver(this);

    if (kIsWeb) {
      window.addEventListener('focus', onFocus);
      window.addEventListener('blur', onBlur);
    } else {
      WidgetsBinding.instance!.addObserver(this);
    }
    // final r = Random(70);
    initToken();

    mqtt = MyMqtt(onUpdate: (data, topic) {});

    timer = Timer.periodic(const Duration(seconds: 4), (t) async {
      try {
        if (!mqtt.isConnected && mqtt.reconnecting) {
          MyMqtt? temp = mqtt;
          mqtt = MyMqtt(onUpdate: temp.onUpdate);

          // int r = await mqtt.connect();

          // if (r == 0) {
          //   // topics.forEach((element) {
          //   //   client.subscribe(element, MqttQos.atLeastOnce);
          //   // });

          //   mqtt.reconnecting = false;

          //   setState(() {});
          //   // t.cancel();
          // }
        }
      } catch (e) {
        // reconnecting = false;
        mqtt.client.disconnect();
      }
    });

    menuItems = [
      {
        "title": "Home",
        "icon": Icons.home_outlined,
        "isActive": true,
        "function": () => changePage(0)
      },
      {
        "title": "Data Logger",
        "icon": Icons.description_outlined,
        "isActive": false,
        "function": () => changePage(1)
      },
      {
        "title": "Diagnostic",
        "icon": Icons.lan,
        "isActive": false,
        "function": () => changePage(2)
      },
      {
        "title": "Emergency Call",
        "icon": Icons.call_outlined,
        "isActive": false,
        "function": () => changePage(3)
      },
      {
        "title": "Settings",
        "icon": Icons.settings_outlined,
        "isActive": false,
        "function": () => changePage(4)
      },
    ];

    page = Content_home(
      isAdmin: isAdmin,
      mqtt: mqtt,
      scSel: scSel,
      selData: selData,
    );

    pageMobile = Content_home_mobile(
      isAdmin: isAdmin,
      mqtt: mqtt,
      selData: selData,
      scSel: scSel,
      menuItem: menuItems,
    );

    // for (var i = 0; i < selData.length; i++) {
    //   final v = selData[i];
    //   for (var e in v) {
    //     final c = e["celcius"] = 0;
    //     final vv = e["volt"] = 0;
    //     final a = e["ampere"] = 0;
    //     //  e["celcius"] = (e["celcius"] as int) + 1;
    //     // final index = v.indexOf(e);
    //     // selData[0][index]["celcius"] = max(
    //     //     selData[0][index]["celcius"] is int
    //     //         ? (selData[0][index]["celcius"] as int).toDouble()
    //     //         : selData[0][index]["celcius"] as double,
    //     //     c);
    //     // selData[0][index]["volt"] = max(
    //     //     selData[0][index]["volt"] is int
    //     //         ? (selData[0][index]["volt"] as int).toDouble()
    //     //         : selData[0][index]["volt"] as double,
    //     //     vv);
    //     // selData[0][index]["ampere"] = max(
    //     //     selData[0][index]["ampere"] is int
    //     //         ? (selData[0][index]["ampere"] as int).toDouble()
    //     //         : selData[0][index]["ampere"] as double,
    //     //     a);
    //   }

    //   // if (kDebugMode) {
    //   //   print("sel data 0 : ${selData[0][0].toString()}");
    //   // }
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scSel.dispose();
    timer.cancel();
    mqtt.disconnect();
    mqtt.dispose();

    if (kIsWeb) {
      window.removeEventListener('focus', onFocus);
      window.removeEventListener('blur', onBlur);
    } else {
      WidgetsBinding.instance!.removeObserver(this);
    }
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // if (kDebugMode) {
      //   print("home state : $state");
      // }
      // mqtt.unsubscribeAll();
      // mqtt.disconnect();
      // // mqtt.dispose();

      // mqtt.isConnected = false;
    } else if (state == AppLifecycleState.resumed) {
      mqtt.unsubscribeAll();
      mqtt.disconnect();
      mqtt.reconnecting = true;
      mqtt.isConnected = false;
      //   mqtt.connect();

      //   mqtt.reconnecting = false;

      if (kDebugMode) {
        print("home state : $state");
      }
    }
  }

  // double currSelOffset = 0;
  loadEmail() async {
    Controller controller = Controller();
    email = await controller.loadSharedPref("antam.email", email);

    // print("email: $email");
    if (mounted) setState(() {});
  }

  // loadIsAdmin() async {
  //   // Controller controller = Controller();
  //   isAdmin = Home.isAdmin;

  //   if (mounted) setState(() {});
  // }

  checkAccess() async {
    await initToken();
    final api = ApiHelper();

    final r =
        await api.callAPI("/user/find?limit=1&id=342", "POST", "{}", true);

    if (r["error"] == null) {
      if (kDebugMode) {
        print("user data: $r");
      }

      email = r["email"] ?? "";

      isAdmin = r["isAdmin"] ?? false;

      if (mounted) setState(() {});
    } else {
      if (kDebugMode) {
        print(r["error"]);
      }
    }
  }

  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;

    if (email.isEmpty) {
      final args = ((ModalRoute.of(context)!.settings.arguments ??
          HomeArgument(email: "", isAdmin: false)) as HomeArgument);

      if (args.email == "") {
        checkAccess();
        // loadEmail();
        // loadIsAdmin();
      } else {
        email = args.email;
        isAdmin = args.isAdmin;

        if (kDebugMode) {
          print("isAdmin: ${args.isAdmin}");
        }
      }

      page = Content_home(
        isAdmin: isAdmin,
        mqtt: mqtt,
        scSel: scSel,
        selData: selData,
      );

      pageMobile = Content_home_mobile(
        isAdmin: isAdmin,
        mqtt: mqtt,
        selData: selData,
        scSel: scSel,
        menuItem: menuItems,
      );
    }
    // print(lheight);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: lWidth < 900
          ? Scrollbar(
              controller: scMain,
              thumbVisibility: true,
              child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  controller: scMain,
                  child: SizedBox(
                      width: lWidth, height: lheight, child: pageMobile)),
            )
          : FittedBox(
              fit: lWidth < 1000 ? BoxFit.fitWidth : BoxFit.fitHeight,
              // scaleY: lheight / ,
              child: Container(
                // clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                // width: lWidth,
                // height: lheight,
                child: SizedBox(
                  width: (lWidth / lheight) < wide
                      ? 2200
                      : lWidth < 900
                          ? 450
                          : lWidth >= 1920
                              ? lWidth
                              : 1520,
                  child: Listener(
                    onPointerSignal: (pointerSignal) {
                      // if (pointerSignal is PointerScrollEvent) {
                      //   scMain.animateTo(scMain.offset + pointerSignal.scrollDelta.dy,
                      //       duration: const Duration(milliseconds: 100),
                      //       curve: Curves.ease);
                      // }
                    },
                    child: Scrollbar(
                      // hoverThickness: 10,
                      thickness: 10,
                      thumbVisibility: true,
                      controller: scMain,
                      child: SingleChildScrollView(
                        controller: scMain,
                        scrollDirection:
                            lWidth < 900 ? Axis.vertical : Axis.horizontal,
                        child: Row(
                          children: [
                            Visibility(
                              visible: lWidth >= 900,
                              child: SizedBox(
                                width: (lWidth / lheight) < wide ? 400 : 250,
                                child: Menu(
                                  menuItem: menuItems,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                // Visibility(
                                //   visible: false,
                                //   child: Transform.scale(
                                //       scale:
                                //           (lWidth / lheight) < wide ? 1.2 : 1,
                                //       origin: Offset(
                                //           (lWidth / lheight) < wide ? -610 : 0,
                                //           0),
                                //       child: Account_alarm(alarm: alarm)),
                                // ),
                                page
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
