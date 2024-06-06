import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/tools/mqtt/mqtt.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AlarmMsg extends StatefulWidget {
  AlarmMsg({super.key, required this.mqtt});

  MyMqtt mqtt;

  @override
  State<AlarmMsg> createState() => _AlarmMsgState();
}

class _AlarmMsgState extends State<AlarmMsg> {
  final wide = 16 / 9;

  List<String> warningMsg = [""];

  double msgOpacity = 0;

  bool isMsgVisible = false;

  showMsg(int tangki, int node, String msg) {
    if (mounted) {
      if (warningMsg[0].isEmpty) {
        warningMsg.clear();
      }

      final dataString = warningMsg
          .where((element) =>
              element.contains("${tangki.toString()} - ${node.toString()}"))
          .toList();
      if (dataString.isEmpty) {
        warningMsg.insert(0, msg);

        setState(() {
          isMsgVisible = true;
        });

        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() {
              msgOpacity = 1;
            });
          }
        });
      }
      // else {
      // warningMsg.remove(dataString.first);

      // warningMsg.insert(0, msg);
      // }
    }
  }

  // late MyMqtt mqtt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // mqtt = widget.mqtt;

    widget.mqtt.onUpdateAlarm = (data) {
      // if (topic == "antam/statusNode") {
      final String status = data["status"] as String;

      if (status.contains("alarmArusTinggi") ||
          status.contains("alarmArusRendah") ||
          status.contains("alarmTegangan") ||
          status.contains("alarmSuhuTinggi") ||
          status.contains("alarmSuhuRendah") ||
          status.contains("alarmPhTinggi") ||
          status.contains("alarmPhRendah") ||
          status == "alarm") {
        if (status == "alarm") {
          showMsg(data["tangki"], data["node"],
              "Terjadi masalah pada sel ${data["tangki"]} - ${data["node"]}");
        } else {
          showMsg(data["tangki"], data["node"],
              "${status.contains("Rendah") ? "Minimum" : "Maksimum"} ${status.replaceAll("alarm", "").replaceAll("Tinggi", "").replaceAll("Rendah", "")} telah di lewati pada sel ${data["tangki"]} - ${data["node"]}");
        }
        // }
      }

      data.clear();
    };

    initStatus();
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
      final listAlarmSuhu = data["listAlarmSuhu"] as List<dynamic>;
      final listAlarmPh = data["listAlarmPh"] as List<dynamic>;

      if (listAlarmArus.isNotEmpty) {
        for (var i = 0; i < listAlarmArus.length; i++) {
          final List<dynamic> e = listAlarmArus[i] as List<dynamic>;

          final aT = listAlarmTegangan
              .where((element) => element[0] == e[0] && element[1] == e[1]);
          final aS = listAlarmSuhu
              .where((element) => element[0] == e[0] && element[1] == e[1]);
          final aP = listAlarmPh
              .where((element) => element[0] == e[0] && element[1] == e[1]);

          if (aS.isNotEmpty) {
            listAlarmSuhu.remove(aS.first);
          }

          if (aP.isNotEmpty) {
            listAlarmPh.remove(aP.first);
          }

          if (aT.isNotEmpty) {
            listAlarmTegangan.remove(aT.first);

            showMsg(e[0], e[1], "Terjadi masalah pada sel ${e[0]} - ${e[1]}");
          } else {
            showMsg(e[0], e[1],
                "Batas Arus telah di lewati pada sel ${e[0]} - ${e[1]}");
          }
        }
      }

      if (listAlarmTegangan.isNotEmpty) {
        for (var i = 0; i < listAlarmTegangan.length; i++) {
          final List<dynamic> e = listAlarmTegangan[i] as List<dynamic>;

          showMsg(e[0], e[1],
              "Batas Tegangan telah di lewati pada sel ${e[0]} - ${e[1]}");
        }
      }

      if (listAlarmSuhu.isNotEmpty) {
        for (var i = 0; i < listAlarmSuhu.length; i++) {
          final List<dynamic> e = listAlarmSuhu[i] as List<dynamic>;

          showMsg(e[0], e[1],
              "Batas Suhu telah di lewati pada sel ${e[0]} - ${e[1]}");
        }
      }

      if (listAlarmPh.isNotEmpty) {
        for (var i = 0; i < listAlarmPh.length; i++) {
          final List<dynamic> e = listAlarmPh[i] as List<dynamic>;

          showMsg(e[0], e[1],
              "Batas pH telah di lewati pada sel ${e[0]} - ${e[1]}");
        }
      }
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // mqtt.unsubscribeAll();
    // mqtt.disconnect();
    // mqtt.dispose();
    widget.mqtt.onUpdateAlarm = null;
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Transform.scale(
      scale: (lWidth / lheight) < wide ? 1.4 : 1,
      origin: Offset((lWidth / lheight) < wide ? 700 : 0, 0),
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
          child: Container(
            padding: const EdgeInsets.only(top: 30),
            width: 700,
            height: 500,
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
                            style: MainStyle.textStyleDefault20BlackBold,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 300,
                        width: 600,
                        child: Center(
                          child: Text(
                            warningMsg[0],
                            textAlign: TextAlign.center,
                            style: MainStyle.textStyleDefault40BlackBold,
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
                              text: warningMsg.length > 1 ? "Next" : "Dismiss",
                              onPressed: () {
                                if (warningMsg.length > 1) {
                                  warningMsg.remove(warningMsg[0]);
                                } else {
                                  warningMsg[0] = "";
                                }

                                if (warningMsg[0].isEmpty) {
                                  setState(() {
                                    msgOpacity = 0;
                                  });
                                } else {
                                  setState(() {});
                                }
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
    );
  }
}
