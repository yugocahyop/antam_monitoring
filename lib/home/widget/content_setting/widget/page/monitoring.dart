import 'dart:convert';

import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/tools/mqtt/mqtt.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:antam_monitoring/widget/myTextField_label.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MonitoringSetting extends StatefulWidget {
  MonitoringSetting({super.key, required this.mqtt, this.height});

  MyMqtt mqtt;
  double? height;

  @override
  State<MonitoringSetting> createState() => _MonitoringSettingState();
}

class _MonitoringSettingState extends State<MonitoringSetting> {
  final List<Map<String, dynamic>> settingWidgetText = [
    {
      "label": "Maximum suhu",
      "hint": "",
      "unit": "Celcius",
      "value": 0,
      "reply": "suhuAtas"
    },
    {
      "label": "Minimum suhu",
      "hint": "",
      "unit": "Celcius",
      "value": 0,
      "reply": "suhuBawah"
    },
    {
      "label": "Maximum arus",
      "hint": "",
      "unit": "Ampere",
      "value": 0,
      "reply": "arusAtas"
    },
    {
      "label": "Minimum arus",
      "hint": "",
      "unit": "Ampere",
      "value": 0,
      "reply": "arusBawah"
    },
    {
      "label": "Maximum pH",
      "hint": "",
      "unit": "",
      "value": 0,
      "reply": "phAtas"
    },
    {
      "label": "Minimum pH",
      "hint": "",
      "unit": "",
      "value": 0,
      "reply": "phBawah"
    },
    {
      "label": "Maximum tegangan",
      "hint": "",
      "value": 0,
      "unit": "Volt",
      "reply": "teganganAtas"
    },
  ];

  updateSetting() async {
    if (!isReplied) {
      final c = Controller();
      c.showSnackBar(context, "Update setting gagal - belum menerima balasan");
      return;
    }
    final api = ApiHelper();

    Map<String, dynamic> data = {};

    for (var i = 0; i < settingWidgetText.length; i++) {
      final val = settingWidgetText[i];

      if (mapTextField[val["label"]]!.con.text.isEmpty ||
          double.tryParse(mapTextField[val["label"]]!.con.text) == null) {
        mapTextField[val["label"]]!.startShake();
        return;
      }

      data.putIfAbsent(val["reply"],
          () => double.tryParse(mapTextField[val["label"]]!.con.text) ?? 0);
    }

    final r =
        await api.callAPI("/setting/update", "PUT", jsonEncode(data), true);

    if (r["error"] == null) {
      widget.mqtt.publish(data, "antam/setLimit");

      // checkData();

      final c = Controller();

      c.showSnackBar(context, "Update setting berhasil");

      // initMqtt();

      checkData();

      // if (mounted)
      //   setState(() {
      //     isLoading = false;
      //   });
    } else {
      if (kDebugMode) {
        print(r["error"]);
      }
      final c = Controller();
      c.showSnackBar(context, "Update setting gagal - ${r["error"]}");
    }
  }

  Map<String, Mytextfield_label> mapTextField = {};

  bool isLoading = false;

  // double lwidth = 200;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var i = 0; i < settingWidgetText.length; i++) {
      final val = settingWidgetText[i];

      Mytextfield_label tf = Mytextfield_label(
        isBorder: true,
        width: (widget.height ?? 540) > 700 ? 150 : 200,
        obscure: false,
        hintText: val["hint"],
        suffixText: val["unit"],
        inputType: TextInputType.number,
      );

      mapTextField.putIfAbsent(val["label"], () => tf);

      mapTextField[val["label"]]!.con.text = (val["value"] as int).toString();
    }

    setState(() {});

    initMqtt();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  bool isReplied = false;

  void checkData() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    widget.mqtt.subscribe("antam/reply");
    Future.delayed(const Duration(seconds: 3), () {
      widget.mqtt.onReply = (json) {
        for (var i = 0; i < settingWidgetText.length; i++) {
          final val = settingWidgetText[i];

          mapTextField[val["label"]]!.con.text =
              ((json[val["reply"]] / 1) as double).toStringAsFixed(2);
        }

        // final c = Controller();

        // c.showSnackBar(context, "Update setting berhasil");

        // isReplied = true;

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }

        widget.mqtt.unsubscribe("antam/reply");

        widget.mqtt.onReply = null;
      };

      widget.mqtt.publish({"query": "batasan"}, "antam/query");
    });
  }

  void initMqtt() {
    setState(() {
      isLoading = true;
    });
    // Future.delayed(duration)
    widget.mqtt.subscribe("antam/reply");
    Future.delayed(const Duration(seconds: 1), () {
      widget.mqtt.onReply = (json) {
        for (var i = 0; i < settingWidgetText.length; i++) {
          final val = settingWidgetText[i];

          mapTextField[val["label"]]!.con.text =
              ((json[val["reply"]] / 1) as double).toStringAsFixed(2);
        }

        isReplied = true;

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }

        widget.mqtt.unsubscribe("antam/reply");

        widget.mqtt.onReply = null;
      };

      widget.mqtt.publish({"query": "batasan"}, "antam/query");
    });
  }

  @override
  Widget build(BuildContext context) {
    final lwidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: 500,
      height: widget.height ?? 540,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Monitoring Setting",
                      style: MyTextStyle.defaultFontCustom(Colors.black, 22,
                          weight: FontWeight.w700)),
                  MainStyle.sizedBoxH10,
                  Row(
                    children: [
                      SizedBox(
                        width: lwidth <= 500 ? 250 : 380,
                        child: Text(
                          "Merupakan menu untuk mengganti parameter monitoring ",
                          style: MyTextStyle.defaultFontCustom(
                              const Color(0xff919798), 14),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const Icon(
                Icons.bar_chart,
                color: MainStyle.primaryColor,
                size: 60,
              )
            ],
          ),
          MainStyle.sizedBoxH10,
          const SizedBox(
            width: 500,
            child: Divider(
              color: Color(0xff9ACAC8),
            ),
          ),
          isLoading
              ? SizedBox(
                  width: 500,
                  height: 280,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                      MainStyle.sizedBoxW10,
                      Text("Loading Data")
                    ],
                  ),
                )
              : Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: settingWidgetText
                      .map((e) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: (widget.height ?? 540) > 700 &&
                                        (lwidth <= 500)
                                    ? 150
                                    : 200,
                                child: Text(
                                  e["label"],
                                  // textAlign:
                                  //     (e["label"] as String).contains("Maximum")
                                  //         ? TextAlign.start
                                  //         : TextAlign.end,
                                  style: MyTextStyle.defaultFontCustom(
                                      MainStyle.primaryColor, 16),
                                ),
                              ),
                              mapTextField[e["label"]]!
                            ],
                          ))
                      .toList()),
          MainStyle.sizedBoxH10,
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 200,
              child: Visibility(
                visible: !isLoading,
                child: MyButton(
                    color: MainStyle.primaryColor,
                    text: "Submit",
                    onPressed: () => updateSetting(),
                    textColor: Colors.white),
              ),
            ),
          ),
          MainStyle.sizedBoxH10,
          // SizedBox(
          //   width: 500,
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         SvgPicture.asset(
          //           "assets/database.svg",
          //           color: MainStyle.primaryColor,
          //           width: 60,
          //         ),
          //         SizedBox(
          //           width: 200,
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   Text("Node Timer ",
          //                       style: MyTextStyle.defaultFontCustom(
          //                           Colors.black, 22,
          //                           weight: FontWeight.w700)),
          //                   Text("Synchronization",
          //                       style: MyTextStyle.defaultFontCustom(
          //                           Colors.black, 22,
          //                           weight: FontWeight.w700)),
          //                 ],
          //               ),
          //               MainStyle.sizedBoxH10,
          //               // SizedBox(
          //               //   width: 200,
          //               //   child: Wrap(
          //               //     children: [
          //               //       Text(
          //               //         "Singkronisasi timer pada sensor Node dengan Web Server ",
          //               //         style: MyTextStyle.defaultFontCustom(
          //               //             const Color(0xff919798), 14),
          //               //       ),
          //               //     ],
          //               //   ),
          //               // )
          //             ],
          //           ),
          //         ),
          //         Container(
          //           width: 200,
          //           // height: 135,
          //           padding: const EdgeInsets.all(5),
          //           decoration: BoxDecoration(
          //               // color: const Color(0xff9ACAC8),
          //               borderRadius: BorderRadius.circular(10)),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.end,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 "Last Synchronization: 12/12/2023 10:00",
          //                 style:
          //                     MyTextStyle.defaultFontCustom(Colors.black, 14),
          //               ),
          //               MainStyle.sizedBoxH10,
          //               Align(
          //                 alignment: Alignment.bottomRight,
          //                 child: SizedBox(
          //                   width: 200,
          //                   child: MyButton(
          //                       color: MainStyle.primaryColor,
          //                       text: "Synchronize Now",
          //                       onPressed: () {},
          //                       textColor: Colors.white),
          //                 ),
          //               )
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
