import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                duration: d,
                padding: EdgeInsets.all(2),
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
                              : "Sel ${widget.tangki}",
                          style: MyTextStyle.defaultFontCustom(
                              widget.status.toLowerCase() == "inactive"
                                  ? MainStyle.primaryColor
                                  : Colors.white,
                              lWidth > 500 ? 12 : 10,
                              weight: FontWeight.w700),
                        ),
                        Visibility(
                          visible: !widget.isSensor,
                          child: Text(
                            widget.isSensor ? "" : "#Crossbar ${widget.sel}",
                            style: MyTextStyle.defaultFontCustom(
                                widget.status.toLowerCase() == "inactive"
                                    ? MainStyle.primaryColor
                                    : Colors.white,
                                lWidth > 500 ? 12 : 10,
                                weight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Center(
                              child: Text(
                                "${widget.tegangan.toStringAsFixed(2)}V",
                                style: MyTextStyle.defaultFontCustom(
                                    widget.status.toLowerCase() == "active"
                                        ? MainStyle.primaryColor.withOpacity(1)
                                        : widget.status
                                                .toLowerCase()
                                                .contains("alarmtegangan")
                                            ? Colors.orange.withOpacity(1)
                                            : MainStyle.primaryColor
                                                .withOpacity(1),
                                    14,
                                    weight: widget.status
                                            .toLowerCase()
                                            .contains("tegangan")
                                        ? FontWeight.w900
                                        : FontWeight.normal),
                              ),
                            ),
                            width: 55,
                            height: 30,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                "${widget.arus.toStringAsFixed(1)}A",
                                style: MyTextStyle.defaultFontCustom(
                                    widget.status.toLowerCase() == "active"
                                        ? MainStyle.primaryColor.withOpacity(1)
                                        : widget.status
                                                .toLowerCase()
                                                .contains("alarmarus")
                                            ? widget.status
                                                    .toLowerCase()
                                                    .contains("rendah")
                                                ? Colors.orange
                                                : Colors.red.withOpacity(1)
                                            : MainStyle.primaryColor
                                                .withOpacity(1),
                                    14,
                                    weight: widget.status
                                            .toLowerCase()
                                            .contains("arus")
                                        ? FontWeight.w900
                                        : FontWeight.normal),
                              ),
                            ),
                            width: 55,
                            height: 30,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: AnimatedContainer(
                duration: d,
                width: widget.width,
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${widget.daya.toStringAsFixed(2)} W ",
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
                                    " ${widget.energi.toStringAsFixed(2)} Whr ",
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
                                  Text(
                                    " ${widget.suhu.toStringAsFixed(2)} \u00B0 C",
                                    textAlign: TextAlign.end,
                                    style: MyTextStyle.defaultFontCustom(
                                        widget.status.toLowerCase() ==
                                                "inactive"
                                            ? Colors.black
                                            : Colors.white,
                                        lWidth > 500 ? 13 : 12,
                                        weight: widget.status
                                                .toLowerCase()
                                                .contains("suhu")
                                            ? FontWeight.w900
                                            : FontWeight.normal),
                                  ),
                                ]),
                          ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: widget.width,
                      child: Text(
                        widget.isLoading ? "" : widget.lastUpdated,
                        textAlign: TextAlign.end,
                        style: MyTextStyle.defaultFontCustom(
                          widget.status.toLowerCase() == "inactive"
                              ? Colors.black
                              : Colors.white,
                          lWidth > 500 ? 10 : 9,
                        ),
                      ),
                    )
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
