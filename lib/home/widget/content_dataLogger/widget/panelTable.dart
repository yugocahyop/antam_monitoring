import 'dart:convert';
// import 'dart:ffi';

import 'package:antam_monitoring/home/widget/content_dataLogger/content_dataLogger2.dart';
import 'package:antam_monitoring/home/widget/content_dataLogger/widget/panelTableItem.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loadmore/loadmore.dart';

class PanelTable extends StatefulWidget {
  PanelTable(
      {super.key,
      required this.fileNum,
      required this.progress,
      required this.download,
      required this.isLoading,
      required this.changeIsAlarm,
      required this.loadmore,
      required this.dataLog,
      required this.onTap,
      required this.max});

  List<Map<String, dynamic>> dataLog;

  int max, fileNum;

  double progress;

  bool isLoading;

  Function(int index) onTap;

  Future<bool> Function() loadmore;

  Function(bool isAlarm) changeIsAlarm;
  Function() download;

  static int maxDataNumDownload = 0;

  @override
  State<PanelTable> createState() => _PanelTableState();
}

class _PanelTableState extends State<PanelTable> {
  List<Map<String, dynamic>> tabItems = [
    {"title": "Data", "icon": Icons.bar_chart, "shown": true},
    {"title": "Alarm", "icon": Icons.message, "shown": false},
  ];
  List<Map<String, dynamic>> dataLog = [{}];

  bool isAlarm = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dataLog.clear();

    dataLog = widget.dataLog;
  }

  download() async {
    PanelTable.maxDataNumDownload = widget.max;

    if (isAlarm) {
      tabItems.firstWhere((element) => element["shown"] == true)["shown"] =
          false;
      tabItems.firstWhere((element) => element["title"] == "Data")["shown"] =
          true;
      // e["shown"] = true;
      isAlarm = false;

      // print("is alarm : $isAlarm");
      setState(() {});

      dataLog.clear();

      await widget.changeIsAlarm(isAlarm);

      setState(() {});
    }

    widget.download();
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: 500,
      height: 620,
      child: Stack(
        children: [
          SizedBox(
            height: 100,
            width: 500,
            child: Row(
              children: tabItems
                  .map((e) => Transform.translate(
                        offset: Offset(tabItems.indexOf(e) * -10, 0),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(19)),
                                color: const Color(0xffC1E0E0),
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(4, 4),
                                      color: MainStyle.primaryColor
                                          .withAlpha((255 * 0.05).toInt()),
                                      blurRadius: 10,
                                      spreadRadius: 0),
                                  BoxShadow(
                                      offset: const Offset(-4, -4),
                                      color: Colors.white
                                          .withAlpha((255 * 0.5).toInt()),
                                      blurRadius: 13,
                                      spreadRadius: 0),
                                  BoxShadow(
                                      offset: const Offset(6, 6),
                                      color: MainStyle.primaryColor
                                          .withAlpha((255 * 0.10).toInt()),
                                      blurRadius: 20,
                                      spreadRadius: 0),
                                ]),
                            child: Visibility(
                              visible: !e["shown"],
                              child: Container(
                                width: 100,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                  color: const Color(0xffC1E0E0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(e["icon"],
                                        color: MainStyle.primaryColor,
                                        size: 20),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      e["title"],
                                      style: MyTextStyle.defaultFontCustom(
                                          MainStyle.primaryColor, 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 60),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 500,
              height: 570,
              decoration: BoxDecoration(
                  color: MainStyle.secondaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(4, 4),
                        color: MainStyle.primaryColor
                            .withAlpha((255 * 0.05).toInt()),
                        blurRadius: 10,
                        spreadRadius: 0),
                    BoxShadow(
                        offset: const Offset(-4, -4),
                        color: Colors.white.withAlpha((255 * 0.5).toInt()),
                        blurRadius: 13,
                        spreadRadius: 0),
                    BoxShadow(
                        offset: const Offset(6, 6),
                        color: MainStyle.primaryColor
                            .withAlpha((255 * 0.10).toInt()),
                        blurRadius: 20,
                        spreadRadius: 0),
                  ]),
              child: dataLog.isEmpty && !widget.isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_rounded,
                          color: MainStyle.primaryColor,
                        ),
                        MainStyle.sizedBoxW10,
                        Text("No data")
                      ],
                    )
                  : LoadMore(
                      textBuilder: (loadMoreStatus) {
                        return loadMoreStatus == LoadMoreStatus.loading
                            ? "Loading Data"
                            : "";
                      },
                      // delegate: DelegateBuilder(context),
                      isFinish: dataLog.length >= widget.max,
                      onLoadMore: widget.loadmore,
                      // delegate: ,
                      child: ListView.builder(
                          itemCount: dataLog.length,
                          itemBuilder: ((context, index) => InkWell(
                              onTap: () {
                                OnTap(index);
                              },
                              onHover: (value) => setState(() {
                                    // print("hovered $value");
                                    dataLog[index]["isHover"] = value;
                                  }),
                              child: PanelItem(
                                  onTap: () {
                                    OnTap(index);
                                  },
                                  isDownload: !isAlarm,
                                  primaryColor: dataLog[index]["isClicked"]
                                      ? MainStyle.thirdColor.withAlpha(150)
                                      : dataLog[index]["isHover"]
                                          ? MainStyle.thirdColor.withAlpha(150)
                                          : Colors.transparent,
                                  date: dataLog[index]["timeStamp_server"],
                                  title: isAlarm
                                      ? dataLog[index]["msg"]
                                      : "Data ${index + 1}")))),
                    ),
            ),
          ),
          SizedBox(
            height: 100,
            width: 500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: tabItems
                      .map((e) => Opacity(
                            opacity: !e["shown"] ? 0 : 1,
                            child: Transform.translate(
                              offset: Offset(tabItems.indexOf(e) * -10, 0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashColor: Colors.transparent,
                                onTap: () async {
                                  tabItems.firstWhere((element) =>
                                          element["shown"] == true)["shown"] =
                                      false;
                                  e["shown"] = true;
                                  isAlarm = e["title"] == "Alarm";

                                  // print("is alarm : $isAlarm");
                                  setState(() {});

                                  dataLog.clear();

                                  await widget.changeIsAlarm(isAlarm);

                                  setState(() {});
                                },
                                child: Container(
                                  width: 100,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    color: MainStyle.secondaryColor,
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //       offset: const Offset(4, -4),
                                    //       color: MainStyle.primaryColor
                                    //           .withAlpha(
                                    //               (255 * 0.05).toInt()),
                                    //       blurRadius: 10,
                                    //       spreadRadius: 0),
                                    //   //   BoxShadow(
                                    //   //       offset: const Offset(-4, -4),
                                    //   //       color: Colors.white
                                    //   //           .withAlpha((255 * 0.5).toInt()),
                                    //   //       blurRadius: 13,
                                    //   //       spreadRadius: 0),
                                    //   //   BoxShadow(
                                    //   //       offset: const Offset(6, 6),
                                    //   //       color: MainStyle.primaryColor
                                    //   //           .withAlpha((255 * 0.10).toInt()),
                                    //   //       blurRadius: 20,
                                    //   //       spreadRadius: 0),
                                    // ]
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(e["icon"],
                                          color: MainStyle.primaryColor,
                                          size: 20),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        e["title"],
                                        style: MyTextStyle.defaultFontCustom(
                                            MainStyle.primaryColor, 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                Transform.translate(
                  offset: Offset(0, -20),
                  child: SizedBox(
                    height: 30,
                    child: widget.progress > 0
                        ? SizedBox(
                            width: lWidth <= 500 ? 140 : 200,
                            height: 30,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      // width: lWidth <= 500 ? 120 : 180,
                                      // height: 8,
                                    width: 10,
                                    height: 10,
                                      child:
                                      CircularProgressIndicator(color: MainStyle.primaryColor,)
                                      //  LinearProgressIndicator(
                                      //   backgroundColor:
                                      //       MainStyle.secondaryColor,
                                      //   borderRadius: BorderRadius.circular(10),
                                      //   color: MainStyle.primaryColor,
                                      //   value: widget.progress,
                                      // ),
                                    ),
                                    // InkWell(
                                    //   onTap: () {
                                    //     Content_dataLogger2.isCancel = true;
                                    //   },
                                    //   child: Container(
                                    //       width: 18,
                                    //       padding: EdgeInsets.all(2),
                                    //       decoration: BoxDecoration(
                                    //           color: MainStyle.primaryColor,
                                    //           borderRadius:
                                    //               BorderRadius.circular(10)),
                                    //       child: Icon(
                                    //         Icons.close,
                                    //         size: 13,
                                    //         color: Colors.white,
                                    //       )),
                                    // )
                                  ],
                                ),
                                Expanded(
                                  child: Wrap(
                                      alignment: WrapAlignment.end,
                                      children: [
                                        Text(
                                            "downloading ${((widget.progress * (PanelTable.maxDataNumDownload / Content_dataLogger2.maxRowExcel))).ceil()} of ${widget.fileNum}"),
                                      ]),
                                ),
                              ],
                            ),
                          )
                        : MyButton(
                            color: MainStyle.primaryColor,
                            text: lWidth <= 500 ? "" : "Download",
                            icon: Icon(
                              Icons.download,
                              size: 25,
                              color: Colors.white,
                            ),
                            onPressed: () => download(),
                            textColor: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void OnTap(int index) {
    try {
      dataLog.firstWhere(
          (element) => element["isClicked"] == true)["isClicked"] = false;
    } catch (e) {}

    dataLog[index]["isClicked"] = true;

    if (!isAlarm) widget.onTap(index);
  }
}
