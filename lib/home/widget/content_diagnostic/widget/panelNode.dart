import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PanelNode extends StatefulWidget {
  PanelNode(
      {super.key,
      required this.tangki,
      required this.sel,
      required this.status,
      required this.lastUpdated,
      required this.tapFunction,
      this.width = 100,
      this.isSensor = false});

  int tangki;
  int sel;
  double width;
  bool isSensor;

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
        child: SizedBox(
          width: widget.width,
          height: widget.width,
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
                        ? MainStyle.primaryColor
                        : widget.status.toLowerCase() == "alarm"
                            ? Colors.red
                            : MainStyle.thirdColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isSensor
                          ? "Sensor node"
                          : "Tangki ${widget.tangki}",
                      style: MyTextStyle.defaultFontCustom(
                          widget.status.toLowerCase() == "inactive"
                              ? MainStyle.primaryColor
                              : Colors.white,
                          12),
                    ),
                    Visibility(
                      visible: !widget.isSensor,
                      child: Text(
                        widget.isSensor ? "" : "#Sel ${widget.sel}",
                        style: MyTextStyle.defaultFontCustom(
                            widget.status.toLowerCase() == "inactive"
                                ? MainStyle.primaryColor
                                : Colors.white,
                            12),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                width: widget.width,
                padding: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    color: MainStyle.thirdColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.status,
                      style: MyTextStyle.defaultFontCustom(Colors.black, 10),
                    ),
                    SizedBox(
                      width: widget.width,
                      child: Text(
                        widget.lastUpdated,
                        textAlign: TextAlign.end,
                        style: MyTextStyle.defaultFontCustom(Colors.black, 8),
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
