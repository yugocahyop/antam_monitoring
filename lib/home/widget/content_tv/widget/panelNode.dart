import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PanelNode extends StatefulWidget {
  PanelNode(
      {super.key,
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
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MainStyle.thirdColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedContainer(
                width: widget.width,
                duration: d,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    color: widget.status.toLowerCase() == "active"
                        ? MainStyle.primaryColor.withOpacity(
                            widget.dateDiff > (60000 * 5) ? 0.5 : 1)
                        : widget.status.toLowerCase().contains("alarm")
                            ? Colors.red.withOpacity(
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
                            widget.isSensor ? "" : "#Anoda ${widget.sel}",
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
                            child: Text(
                              "00.00V",
                              style: MyTextStyle.defaultFontCustom(
                                  widget.status.toLowerCase() == "active"
                                      ? MainStyle.primaryColor.withOpacity(1)
                                      : widget.status
                                              .toLowerCase()
                                              .contains("alarm")
                                          ? Colors.red.withOpacity(1)
                                          : MainStyle.primaryColor
                                              .withOpacity(1),
                                  13),
                            ),
                            width: 55,
                            height: 30,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          Container(
                            child: Text(
                              "000.0A",
                              style: MyTextStyle.defaultFontCustom(
                                  widget.status.toLowerCase() == "active"
                                      ? MainStyle.primaryColor.withOpacity(1)
                                      : widget.status
                                              .toLowerCase()
                                              .contains("alarm")
                                          ? Colors.red.withOpacity(1)
                                          : MainStyle.primaryColor
                                              .withOpacity(1),
                                  13),
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
                  child: Container(
                width: widget.width,
                padding: EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                    color: widget.status.toLowerCase() == "active"
                        ? MainStyle.primaryColor.withOpacity(
                            widget.dateDiff > (60000 * 5) ? 0.5 : 1)
                        : widget.status.toLowerCase().contains("alarm")
                            ? Colors.red.withOpacity(
                                widget.dateDiff > (60000 * 5) ? 0.5 : 1)
                            : MainStyle.thirdColor.withOpacity(
                                widget.dateDiff > (60000 * 5) ? 0.5 : 1),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: widget.width - 10,
                        child: Text(
                          widget.isLoading
                              ? "Memuat"
                              : "0000 W 0000 Whr 00.0 C",
                          textAlign: TextAlign.end,
                          style: MyTextStyle.defaultFontCustom(
                              widget.status.toLowerCase() == "inactive"
                                  ? Colors.black
                                  : Colors.white,
                              lWidth > 500 ? 10 : 9),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: widget.width,
                      child: Text(
                        widget.isLoading ? "" : widget.lastUpdated,
                        textAlign: TextAlign.end,
                        style: MyTextStyle.defaultFontCustom(
                            widget.status.toLowerCase() == "inactive"
                                ? Colors.black
                                : Colors.white,
                            lWidth > 500 ? 8 : 7),
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
