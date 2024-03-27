// library home;

import 'dart:async';
// import 'dart:html';
// import 'dart:js_interop';

// import 'dart:ui_web';

import 'package:antam_monitoring/home/model/homeArgument.dart';
import 'package:antam_monitoring/home/widget/content_call/content_call.dart';
import 'package:antam_monitoring/home/widget/content_dataLogger/content_dataLogger2.dart';
import 'package:antam_monitoring/home/widget/content_diagnostic/content_diagnostic.dart';
import 'package:antam_monitoring/home/widget/content_home.dart';
import 'package:antam_monitoring/home/widget/content_home_mobile.dart';
import 'package:antam_monitoring/home/widget/content_setting/content_setting.dart';
import 'package:antam_monitoring/home/widget/menu.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/tools/encrypt.dart';
import 'package:antam_monitoring/tools/mqtt/mqtt.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart';

import '../controller/controller.dart';

// part 'widget/menu.dart';
// part 'widget/content_home.dart';
// part 'widget/account_alarm.dart';
// part 'widget/filterTgl.dart';
// part 'widget/myDropDown.dart';
// part 'widget/filterTangki.dart';
// part 'widget/content_home_mobile.dart';
// part 'widget/up.dart';
// part 'widget/content_diagnostic/content_diagnostic.dart';
// part 'widget/content_call/content_call.dart';
// part 'widget/content_setting/content_setting.dart';
// part 'widget/content_dataLogger/content_dataLogger.dart';
// part 'widget/content_dataLogger/content_dataLogger2.dart';

class Home extends StatefulWidget {
  Home({super.key, this.page = ""});

  String page;
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
    [
      {
        "sel": 1,
        "suhu": 0.0,
        "pH": 0.0,
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
    ]
  ];

  int curr_page = 0;

  changePage(int p, {int? dari, int? hingga}) {
    final c = Controller();
    final encrypt = MyEncrtypt();
    curr_page = p;
    mqtt.onUpdate = (data, topi) {};

    checkAccess();
    switch (p) {
      case 0:
        c.saveSharedPref("antam.access", encrypt.encrypt("home"));
        setState(() {
          page = Content_home(
            changePage: changePage,
            isAdmin: isAdmin,
            mqtt: mqtt,
            scSel: ScrollController(),
            selData: selData,
          );
          pageMobile = Content_home_mobile(
            email: email,
            page: 0,
            changePage: changePage,
            isAdmin: isAdmin,
            mqtt: mqtt,
            selData: selData,
            scSel: ScrollController(),
            menuItem: menuItems,
          );
        });
        break;
      case 1:
        c.saveSharedPref("antam.access", encrypt.encrypt("datalog"));
        if (dari != null) {
          menuItems.firstWhere(
              (element) => element["isActive"] == true)["isActive"] = false;
          menuItems[1]["isActive"] = true;
        }
        setState(() {
          page = Content_dataLogger2(
              changePage: changePage,
              isAdmin: isAdmin,
              mqtt: mqtt,
              scSel: ScrollController(),
              selData: selData,
              dari: dari,
              hingga: hingga);
          pageMobile = Content_home_mobile(
            email: email,
            page: 1,
            changePage: changePage,
            isAdmin: isAdmin,
            mqtt: mqtt,
            selData: selData,
            scSel: ScrollController(),
            menuItem: menuItems,
          );
        });
        break;
      case 2:
        c.saveSharedPref("antam.access", encrypt.encrypt("diagnostic"));
        setState(() {
          page = Content_diagnostic(
            changePage: changePage,
            isAdmin: isAdmin,
            mqtt: mqtt,
            scSel: ScrollController(),
            selData: selData,
          );
          pageMobile = Content_home_mobile(
            email: email,
            page: 2,
            changePage: changePage,
            isAdmin: isAdmin,
            mqtt: mqtt,
            selData: selData,
            scSel: ScrollController(),
            menuItem: menuItems,
          );
        });

        break;
      case 3:
        c.saveSharedPref("antam.access", encrypt.encrypt("call"));
        setState(() {
          page = Content_call(
            changePage: changePage,
            isAdmin: isAdmin,
            mqtt: mqtt,
            scSel: ScrollController(),
            selData: selData,
          );
          pageMobile = Content_home_mobile(
            email: email,
            page: 3,
            changePage: changePage,
            isAdmin: isAdmin,
            mqtt: mqtt,
            selData: selData,
            scSel: ScrollController(),
            menuItem: menuItems,
          );
        });

        break;
      case 4:
        c.saveSharedPref("antam.access", encrypt.encrypt("setting"));
        setState(() {
          page = Content_setting(
            changePage: changePage,
            email: email,
            isAdmin: isAdmin,
            mqtt: mqtt,
            scSel: ScrollController(),
            selData: selData,
          );
          pageMobile = Content_home_mobile(
            email: email,
            page: 4,
            changePage: changePage,
            isAdmin: isAdmin,
            mqtt: mqtt,
            selData: selData,
            scSel: ScrollController(),
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
  // var scSel = ScrollController();

  final double wide = 16 / 9;

  late MyMqtt mqtt;

  initToken() async {
    if (ApiHelper.tokenMain.isEmpty) {
      final c = Controller();
      final encrypt = MyEncrtypt();

      try {
        final token2 =
            encrypt.decrypt(await c.loadSharedPref("antam.log", "String"));
        final token3 =
            encrypt.decrypt(await c.loadSharedPref("antam.public", "String"));

        final token1 =
            encrypt.decrypt(await c.loadSharedPref("antam.data", "String"));

        ApiHelper.tokenMain = ("$token1.$token2.$token3");
      } catch (e) {
        if (kDebugMode) {
          print("error: $e");
        }
      }

      //  c.loadSharedPref("antam.data", encrypt.encrypt(tokensplit[0]));
    }
  }

  late Timer timer;

  // void onFocus(Event e) {
  //   didChangeAppLifecycleState(AppLifecycleState.resumed);
  // }

  // void onBlur(Event e) {
  //   didChangeAppLifecycleState(AppLifecycleState.paused);
  // }

  String email = "";

  Future<void> initPage() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    try {
      String p = "";
      // if (widget.page.isEmpty) {
      final c = Controller();

      final encrypt = MyEncrtypt();

      final raw = await c.loadSharedPref("antam.access", "String");

      p = raw != null ? encrypt.decrypt(raw) : "";
      // } else {
      //   p = widget.page;
      // }

      if (kDebugMode) {
        print("init page: $p");
      }

      switch (p) {
        case "home":
          menuItems.firstWhere(
              (element) => element["isActive"] == true)["isActive"] = false;
          menuItems[0]["isActive"] = true;
          changePage(0);
          break;
        case "datalog":
          menuItems.firstWhere(
              (element) => element["isActive"] == true)["isActive"] = false;
          menuItems[1]["isActive"] = true;
          changePage(1);
          break;
        case "diagnostic":
          menuItems.firstWhere(
              (element) => element["isActive"] == true)["isActive"] = false;
          menuItems[2]["isActive"] = true;
          changePage(2);
          break;
        case "call":
          menuItems.firstWhere(
              (element) => element["isActive"] == true)["isActive"] = false;
          menuItems[3]["isActive"] = true;
          // print("initpage: $p");
          changePage(3);
          break;
        case "setting":
          menuItems.firstWhere(
              (element) => element["isActive"] == true)["isActive"] = false;
          menuItems[4]["isActive"] = true;
          changePage(4);
          break;
        default:
      }
    } catch (e) {
      if (kDebugMode) {
        print("error: $e");
      }
    }
  }

  late StreamSubscription listenUnload;

  Future<void> fcm_unsubscribe(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  Future<void> fcm_subscribe(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  getPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    await getPermission();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    // }

    // // Also handle any interaction when the app is in the background via a
    // // Stream listener

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    fcm_subscribe("antam-monitoring");
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    try {
      // Map<String,dynamic> data = jsonDecode(message.data.toString());

      // while(showNotif == null){
      //   await Future.delayed(const Duration(milliseconds: 500));
      // }

      print("app opened");

      if (kDebugMode) {
        print("tapped show notif");
      }

      // showNotif!(message.data["TECHIDENTNO"], int.tryParse(message.data["dateTime"]) ?? 0 );
    } catch (e) {
      if (kDebugMode) {
        print(" ${e}");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    setupInteractedMessage();

    final encrypt = MyEncrtypt();
    final c = Controller();

    for (var x = 2; x < 8; x++) {
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

    // c.saveSharedPref("antam.access", encrypt.encrypt("home"));

    // WidgetsBinding.instance!.addObserver(this);

    // if (kIsWeb) {
    //   window.addEventListener('focus', onFocus);
    //   window.addEventListener('blur', onBlur);
    //   window.addEventListener('visibilitychange', onFocus);
    //   listenUnload = window.onBeforeUnload.listen((event) {
    //     if (kDebugMode) {
    //       print("before unload");
    //     }
    //     // scSel.dispose();
    //     timer.cancel();
    //     mqtt.disconnect();
    //     mqtt.dispose();
    //     listenUnload.cancel();
    //   });

    // window.onPageShow.listen((event) {
    //   try {
    //     mqtt.publish({}, "antam/command");
    //   } catch (e) {
    //     mqtt.unsubscribeAll();
    //     mqtt.disconnect();
    //     mqtt.reconnecting = true;
    //     mqtt.isConnected = false;
    //   }
    //   if (kDebugMode) {
    //     print("page shown");
    //   }
    // });
    // } else {
    WidgetsBinding.instance!.addObserver(this);
    // }
    // final r = Random(70);
    initToken();

    mqtt = MyMqtt(onUpdate: (data, topic) {});

    timer = Timer.periodic(const Duration(seconds: 4), (t) async {
      try {
        if (!mqtt.isConnected && mqtt.reconnecting) {
          MyMqtt? temp = mqtt;

          mqtt = MyMqtt(onUpdate: temp.onUpdate);

          // while (!mqtt.isConnected) {
          //   await Future.delayed(const Duration(milliseconds: 200));
          // }

          page = const SizedBox(
            width: 1200,
            height: 500,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      color: MainStyle.primaryColor,
                    ))
              ],
            ),
          );

          setState(() {});

          await Future.delayed(Duration(seconds: 1));

          changePage(curr_page);

          // await initPage();

          mqtt.onUpdate = temp.onUpdate;

          // setState(() {});

          // int r = await mqtt.connect();

          // if (r == 0) {
          //   // topics.forEach((element) {
          //   //   client.subscribe(element, MqttQos.atLeastOnce);
          //   // });

          //   mqtt.reconnecting = false;

          //   initPage();

          //   setState(() {});
          //   // t.cancel();
          // }
        }
      } catch (e) {
        // reconnecting = false;
        mqtt.disconnect();
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
      changePage: changePage,
      isAdmin: isAdmin,
      mqtt: mqtt,
      scSel: ScrollController(),
      selData: selData,
    );

    pageMobile = Content_home_mobile(
      email: email,
      page: 0,
      changePage: changePage,
      isAdmin: isAdmin,
      mqtt: mqtt,
      selData: selData,
      scSel: ScrollController(),
      menuItem: menuItems,
    );

    initPage();

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
    final c = Controller();

    c.saveSharedPref("antam.data", "");
    c.saveSharedPref("antam.log", "");
    c.saveSharedPref("antam.public", "");
    c.saveSharedPref("antam.access", "");

    // saveSharedPref("antam.data", encrypt.encrypt(r["activeToken"]));

    c.saveSharedPref("antam.token", "");
    // TODO: implement dispose
    super.dispose();
    // scSel.dispose();
    scMain.dispose();
    timer.cancel();
    mqtt.disconnect();
    mqtt.dispose();

    // if (kIsWeb) {
    //   window.removeEventListener('focus', onFocus);
    //   window.removeEventListener('blur', onBlur);
    //   window.removeEventListener('visibilitychange', onBlur);
    // } else {
    WidgetsBinding.instance!.removeObserver(this);
    // }
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
      // mqtt.reconnecting = true;
      // mqtt.isConnected = false;
    } else if (state == AppLifecycleState.resumed) {
      try {
        mqtt.publish({}, "antam/check");
      } catch (e) {
        mqtt.unsubscribeAll();
        mqtt.disconnect();
        mqtt.reconnecting = true;
        mqtt.isConnected = false;
      }

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

      Navigator.pushNamedAndRemoveUntil(context, '/login', ((route) => false));
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
        changePage: changePage,
        isAdmin: isAdmin,
        mqtt: mqtt,
        scSel: ScrollController(),
        selData: selData,
      );

      pageMobile = Content_home_mobile(
        email: email,
        page: 0,
        changePage: changePage,
        isAdmin: isAdmin,
        mqtt: mqtt,
        selData: selData,
        scSel: ScrollController(),
        menuItem: menuItems,
      );
    }
    // print(lheight);
    return WillPopScope(
      onWillPop: () {
        final c = Controller();
        c.goToDialog(
            context,
            AlertDialog(
              title: Text("Apakah anda ingin keluar ?"),
              actions: [
                SizedBox(
                  width: 80,
                  child: MyButton(
                      color: MainStyle.primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: "No"),
                ),
                MainStyle.sizedBoxW10,
                SizedBox(
                  width: 80,
                  child: MyButton(
                      color: MainStyle.primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        // dispose();

                        Navigator.pop(context);

                        fcm_unsubscribe("antam_monitoring");

                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', ((route) => false));
                      },
                      text: ("Yes")),
                ),
              ],
            ));

        return Future.value(false);
      },
      child: Scaffold(
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
      ),
    );
  }
}