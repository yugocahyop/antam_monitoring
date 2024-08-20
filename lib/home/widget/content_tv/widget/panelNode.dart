import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class PanelNode extends StatefulWidget {
  PanelNode(
      {super.key,
      required this.arus,
      required this.tegangan,
      required this.daya,
      required this.suhu,
      required this.energi,
      required this.isLoading,
      required this.dateDiff,
      required this.tangki,
      required this.sel,
      required this.status,
      required this.lastUpdated,
      required this.tapFunction,
      this.width = 100,
      this.isSensor = false});

  int tangki;
  int sel;
  int dateDiff;
  double width;
  bool isSensor;
  bool isLoading;

  String status;
  String lastUpdated;

  double tegangan;
  double arus;
  double suhu;
  double daya;
  double energi;

  Function() tapFunction;

  @override
  State<PanelNode> createState() => _PanelNodeState();
}

class MyCalculate {
  

  static TextStyle getStyleText(int id, String value) {
    value = value.toLowerCase();
    Color colorText = value ==  "inactive" ? Colors.black : Colors.white;
    // widget.status.toLowerCase() ==
    //                                             "inactive"
    //                                         ? Colors.black
    //                                         : Colors.white
    FontWeight fontText = FontWeight.normal;

    switch(id){
      case 0:
        fontText = value.contains("tegangan")? FontWeight.w900 : FontWeight.normal;
        break;
      case 1:
        fontText = value.contains("arus")? FontWeight.w900 : FontWeight.normal;
        break;
      case 2:
        fontText = value.contains("suhu")? FontWeight.w900 : FontWeight.normal;
        break;
      default:
        break;
    }

    return MyTextStyle.defaultFontCustom(colorText, 22, weight: fontText);
  }

  static TextStyle generateTextTemp(String value) {
    // colorText = value == "active"? 
    // Colors.white : value.contains("alarmsuhu")? 
    // value.contains("rendah")? 
    // Colors.orange : Colors.red.withOpacity(1) : Colors.white;
    Color colorText = Colors.white;
    FontWeight fontText = FontWeight.normal;
    fontText = value.contains("suhu")? FontWeight.w900 : FontWeight.normal;

    return MyTextStyle.defaultFontCustom(colorText, 14, weight: fontText);
  }
}

class _PanelNodeState extends State<PanelNode> {

  final Duration d = const Duration(milliseconds: 200);
  bool isHover = false;
  @override

  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    // if (widget.dateDiff <= (60000 * 5) && widget.status == "alarm") {
    //   if (kDebugMode) {
    //     print("datediff: ${widget.dateDiff}");
    //   }
    // }



    return InkWell(
      onHighlightChanged: (value) {
        setState(() {
          isHover = value;
        });
      },
      onFocusChange: (value) {
        setState(() {
          isHover = value;
        });
        // isHovers[widget.menuItem.indexOf(e)] = value;
      },
      onHover: (value) {
        setState(() {
          isHover = value;
        });
      },
      onTap: () => widget.tapFunction(),
      child: AnimatedScale(
        duration: Duration(milliseconds: 200),
        scale: isHover ? 1.15 : 1,
        child: Container(
          width: widget.width,
          height: 125,
          decoration: BoxDecoration(
              // border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
              color: MainStyle.thirdColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedContainer(
                width: widget.width,
                height: 20,
                duration: d,
                padding: EdgeInsets.only(right: 10, left: 8, bottom: 0, top: 0),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    color: widget.status.toLowerCase() == "active"
                        ? MainStyle.primaryColor.withOpacity(
                            widget.dateDiff > (60000 * 5) ? 0.5 : 1)
                        : widget.status.toLowerCase().contains("alarm")
                            ? widget.status
                                        .toLowerCase()
                                        .contains("tegangan") ||
                                    widget.status
                                        .toLowerCase()
                                        .contains("rendah")
                                ? Colors.orange.withOpacity(
                                    widget.dateDiff > (60000 * 5) ? 0.5 : 1)
                                : Colors.red.withOpacity(
                                    widget.dateDiff > (60000 * 5) ? 0.5 : 1)
                            : MainStyle.thirdColor.withOpacity(
                                widget.dateDiff > (60000 * 5) ? 0.5 : 1)),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isSensor
                              ? "Elektrolit"
                              : "${widget.tangki} -  ${widget.sel} ",
                          style: MyTextStyle.defaultFontCustom(
                              widget.status.toLowerCase() == "inactive"
                                  ? MainStyle.primaryColor
                                  : Colors.white,
                              lWidth > 500 ? 14 : 12,
                              weight: FontWeight.w700),
                        ),
                        // Visibility(
                        //   visible: !widget.isSensor,
                        //   child: Text(
                        //     widget.isSensor ? "" : "#Crossbar ${widget.sel}",
                        //     style: MyTextStyle.defaultFontCustom(
                        //         widget.status.toLowerCase() == "inactive"
                        //             ? MainStyle.primaryColor
                        //             : Colors.white,
                        //         lWidth > 500 ? 12 : 10,
                        //         weight: FontWeight.w700),
                        //   ),
                        // ),
                      ],
                    ),
                    // SizedBox(
                    //   width: widget.width -10,
                    //   child: Text(
                    //           widget.isLoading ? "" : widget.lastUpdated,
                    //           textAlign: TextAlign.end,
                    //           style: MyTextStyle.defaultFontCustom(
                    //             widget.status.toLowerCase() == "inactive"
                    //                 ? Colors.black
                    //                 : Colors.white,
                    //             lWidth > 500 ? 10 : 9,
                    //           ),
                    //         ),
                    // ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(),
                        // width: widget.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                widget.isLoading ? "" : widget.lastUpdated,
                                textAlign: TextAlign.end,
                                style: MyTextStyle.defaultFontCustom(
                                  widget.status.toLowerCase() == "inactive"
                                      ? Colors.black
                                      : Colors.white,
                                  lWidth > 500 ? 10 : 9,
                                ),
                              ),
                          ],
                        )
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                duration: d,
                width: widget.width,
                padding: EdgeInsets.only(),
                // padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                    color: widget.status.toLowerCase() == "active"
                        ? MainStyle.primaryColor.withOpacity(
                            widget.dateDiff > (60000 * 5) ? 0.5 : 1)
                        : widget.status.toLowerCase().contains("alarm")
                            ? widget.status
                                        .toLowerCase()
                                        .contains("tegangan") ||
                                    widget.status
                                        .toLowerCase()
                                        .contains("rendah")
                                ? Colors.orange.withOpacity(
                                    widget.dateDiff > (60000 * 5) ? 0.5 : 1)
                                : Colors.red.withOpacity(
                                    widget.dateDiff > (60000 * 5) ? 0.5 : 1)
                            : MainStyle.thirdColor.withOpacity(
                                widget.dateDiff > (60000 * 5) ? 0.5 : 1),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  
                  children: [ 
                    //box sensor
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Center(
                              // child: Text(
                              //   "${widget.tegangan.toStringAsFixed(2)} V",
                              //   style: MyTextStyle.defaultFontCustom(
                              //       widget.status.toLowerCase() == "active"
                              //           ? MainStyle.primaryColor.withOpacity(1)
                              //           : widget.status
                              //                   .toLowerCase()
                              //                   .contains("alarmtegangan")
                              //               ? Colors.orange.withOpacity(1)
                              //               : MainStyle.primaryColor
                              //                   .withOpacity(1),
                              //       14,
                              //       weight: widget.status
                              //               .toLowerCase()
                              //               .contains("tegangan")
                              //           ? FontWeight.w900
                              //           : FontWeight.normal),
                              // ),
                              child: Text("${widget.tegangan.toStringAsFixed(2)} V", style: MyCalculate.getStyleText(0, widget.status)),
                              // child: Text("9.99 V", style: MyCalculate.getStyleText(0, widget.status)),
                            ),
                            width: 70,
                            height: 30,
                            padding: EdgeInsets.only(left: 2),
                            // decoration: BoxDecoration(
                            //     color: MainStyle.primaryColor.withOpacity(0.5),
                            //     borderRadius: BorderRadius.circular(5)),
                          ),
                          Container(
                            child: Center(
                              // child: Text(
                              //   "${widget.arus.toStringAsFixed(0)} A",
                              //   style: MyTextStyle.defaultFontCustom(
                              //       widget.status.toLowerCase() == "active"
                              //           ? MainStyle.primaryColor.withOpacity(1)
                              //           : widget.status
                              //                   .toLowerCase()
                              //                   .contains("alarmarus")
                              //               ? widget.status
                              //                       .toLowerCase()
                              //                       .contains("rendah")
                              //                   ? Colors.orange
                              //                   : Colors.red.withOpacity(1)
                              //               : MainStyle.primaryColor
                              //                   .withOpacity(1),
                              //       14,
                              //       weight: widget.status
                              //               .toLowerCase()
                              //               .contains("arus")
                              //           ? FontWeight.w900
                              //           : FontWeight.normal),
                              // ),
                              child: Text("${widget.arus.toStringAsFixed(0)} A", style: MyCalculate.getStyleText(1, widget.status)),
                              // child: Text("999 A", style: MyCalculate.getStyleText(1, widget.status)),
                            ),
                            width: 70,
                            height: 25,
                            padding: EdgeInsets.only(right: 4, left: 4),
                            // decoration: BoxDecoration(
                            //     color: MainStyle.primaryColor.withOpacity(0.5),
                            //     borderRadius: BorderRadius.circular(5)),
                          ),
                          Container(
                            child: Center(
                              // child: Text(
                              //   "${widget.suhu.toStringAsFixed(0)} \u00B0C",
                              //   style: MyTextStyle.defaultFontCustom(widget.status.toLowerCase() == "active"? 
                              //   Colors.white : widget.status.toLowerCase().contains("alarmsuhu") ? widget.status.toLowerCase().contains("rendah") ? 
                              //   Colors.orange : Colors.red.withOpacity(1): // MainStyle.primaryColor.withOpacity(1)
                              //               Colors.white, 14,
                              //       weight: widget.status
                              //               .toLowerCase()
                              //               .contains("suhu")
                              //           ? FontWeight.w900
                              //           : FontWeight.normal),
                              // ),
                              child: Text("${widget.suhu.toStringAsFixed(0)} \u00B0C", style: MyCalculate.getStyleText(2, widget.status)),
                              // child: Text("100 \u00B0C", style: MyCalculate.getStyleText(2, widget.status)),
                              // child: Text("${widget.suhu.toStringAsFixed(0)} \u00B0C", 
                              // style: MyTextStyle.defaultFontCustom(Colors.white, 14, weight: widget.status.toLowerCase().contains("suhu")? FontWeight.w900 : FontWeight.normal)),
                            ),
                            width: 60,
                            height: 30,
                            padding: EdgeInsets.only(right: 4),
                          //   decoration: BoxDecoration(
                          //       color: MainStyle.primaryColor.withOpacity(0.5),
                          //       borderRadius: BorderRadius.circular(5)),
                          ),
                        ],
                      ),
                    ),
                    widget.isLoading
                        ? SizedBox(
                            width: widget.width - 10,
                            child: Text(
                              "Memuat",
                              textAlign: TextAlign.end,
                              style: MyTextStyle.defaultFontCustom(
                                  widget.status.toLowerCase() == "inactive"
                                      ? Colors.black
                                      : Colors.white,
                                  lWidth > 500 ? 13 : 12),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${widget.daya.toStringAsFixed(0)} W ",
                                    textAlign: TextAlign.end,
                                    style: MyTextStyle.defaultFontCustom(
                                        widget.status.toLowerCase() ==
                                                "inactive"
                                            ? Colors.black
                                            : Colors.white,
                                        lWidth > 500 ? 13 : 12,
                                        weight: widget.status
                                                .toLowerCase()
                                                .contains("power")
                                            ? FontWeight.w900
                                            : FontWeight.normal),
                                  ),
                                  Text(
                                    " ${widget.energi.toStringAsFixed(0)} Whr ",
                                    textAlign: TextAlign.end,
                                    style: MyTextStyle.defaultFontCustom(
                                        widget.status.toLowerCase() ==
                                                "inactive"
                                            ? Colors.black
                                            : Colors.white,
                                        lWidth > 500 ? 13 : 12,
                                        weight: widget.status
                                                .toLowerCase()
                                                .contains("energi")
                                            ? FontWeight.w900
                                            : FontWeight.normal),
                                  ),
                                  // Text(
                                  //   " ${widget.suhu.toStringAsFixed(2)} \u00B0 C",
                                  //   textAlign: TextAlign.end,
                                  //   style: MyTextStyle.defaultFontCustom(
                                  //       widget.status.toLowerCase() ==
                                  //               "inactive"
                                  //           ? Colors.black
                                  //           : Colors.white,
                                  //       lWidth > 500 ? 13 : 12,
                                  //       weight: widget.status
                                  //               .toLowerCase()
                                  //               .contains("suhu")
                                  //           ? FontWeight.w900
                                  //           : FontWeight.normal),
                                  // ),
                                ]),
                          ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
