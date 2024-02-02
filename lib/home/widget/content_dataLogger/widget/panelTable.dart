import 'dart:convert';

import 'package:antam_monitoring/home/widget/content_dataLogger/widget/panelTableItem.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PanelTable extends StatefulWidget {
  PanelTable({super.key, required this.dataLog, required this.onTap});

  List<Map<String, dynamic>> dataLog;

  Function(int index) onTap;

  @override
  State<PanelTable> createState() => _PanelTableState();
}

class _PanelTableState extends State<PanelTable> {
  List<Map<String, dynamic>> tabItems = [
    {"title": "Data", "icon": Icons.bar_chart, "shown": true},
    {"title": "Alarm", "icon": Icons.message, "shown": false},
  ];
  List<Map<String, dynamic>> dataLog = [{}];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dataLog.clear();

    dataLog = widget.dataLog;
  }

  @override
  Widget build(BuildContext context) {
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
              child: ListView.builder(
                  itemCount: dataLog.length,
                  itemBuilder: ((context, index) => InkWell(
                      onTap: () {
                        try {
                          dataLog.firstWhere((element) =>
                                  element["isClicked"] == true)["isClicked"] =
                              false;
                        } catch (e) {}

                        dataLog[index]["isClicked"] =
                            !dataLog[index]["isClicked"];

                        widget.onTap(index);
                      },
                      onHover: (value) => setState(() {
                            // print("hovered $value");
                            dataLog[index]["isHover"] = value;
                          }),
                      child: PanelItem(
                          primaryColor: dataLog[index]["isClicked"]
                              ? MainStyle.thirdColor.withAlpha(150)
                              : dataLog[index]["isHover"]
                                  ? MainStyle.thirdColor.withAlpha(150)
                                  : Colors.transparent,
                          date: dataLog[index]["timeStamp_server"],
                          title: "Data ${index + 1}")))),
            ),
          ),
          SizedBox(
            height: 100,
            width: 500,
            child: Row(
              children: tabItems
                  .map((e) => Opacity(
                        opacity: !e["shown"] ? 0 : 1,
                        child: Transform.translate(
                          offset: Offset(tabItems.indexOf(e) * -10, 0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            splashColor: Colors.transparent,
                            onTap: () {
                              tabItems.firstWhere((element) =>
                                  element["shown"] == true)["shown"] = false;
                              e["shown"] = true;
                              setState(() {});
                            },
                            child: Container(
                              width: 100,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                  color: MainStyle.secondaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(4, -4),
                                        color: MainStyle.primaryColor
                                            .withAlpha((255 * 0.05).toInt()),
                                        blurRadius: 10,
                                        spreadRadius: 0),
                                    //   BoxShadow(
                                    //       offset: const Offset(-4, -4),
                                    //       color: Colors.white
                                    //           .withAlpha((255 * 0.5).toInt()),
                                    //       blurRadius: 13,
                                    //       spreadRadius: 0),
                                    //   BoxShadow(
                                    //       offset: const Offset(6, 6),
                                    //       color: MainStyle.primaryColor
                                    //           .withAlpha((255 * 0.10).toInt()),
                                    //       blurRadius: 20,
                                    //       spreadRadius: 0),
                                  ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(e["icon"],
                                      color: MainStyle.primaryColor, size: 20),
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
          ),
        ],
      ),
    );
  }
}
