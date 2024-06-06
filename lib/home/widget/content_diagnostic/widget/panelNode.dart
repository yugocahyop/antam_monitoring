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
          height: widget.width,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isSensor ? "Elektrolit" : "Sel ${widget.tangki}",
                      style: MyTextStyle.defaultFontCustom(
                          widget.status.toLowerCase() == "inactive"
                              ? MainStyle.primaryColor
                              : Colors.white,
                          lWidth > 500 ? 12 : 10),
                    ),
                    Visibility(
                      visible: !widget.isSensor,
                      child: Text(
                        widget.isSensor ? "" : "#Crossbar ${widget.sel}",
                        style: MyTextStyle.defaultFontCustom(
                            widget.status.toLowerCase() == "inactive"
                                ? MainStyle.primaryColor
                                : Colors.white,
                            lWidth > 500 ? 11 : 9),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                width: widget.width,
                padding: EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                    color: MainStyle.thirdColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        widget.isLoading ? "Memuat" : widget.status,
                        style: MyTextStyle.defaultFontCustom(
                            Colors.black, lWidth > 500 ? 10 : 9),
                      ),
                    ),
                    SizedBox(
                      width: widget.width,
                      child: Text(
                        widget.isLoading ? "" : widget.lastUpdated,
                        textAlign: TextAlign.end,
                        style: MyTextStyle.defaultFontCustom(
                            Colors.black, lWidth > 500 ? 8 : 7),
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
