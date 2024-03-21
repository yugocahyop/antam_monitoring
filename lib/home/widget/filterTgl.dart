import 'dart:async';

import 'package:antam_monitoring/home/widget/menu.dart';
import 'package:antam_monitoring/home/widget/myDropDown.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterTgl extends StatefulWidget {
  FilterTgl(
      {super.key,
      this.today = 0,
      required this.title,
      required this.lastValue,
      required this.changePage});

  String title;

  String jamValue = "00:00";

  String hariValue = "Pilih";

  bool lastValue;

  int today;

  Function() changePage;

  @override
  State<FilterTgl> createState() => _FilterTglState();
}

class _FilterTglState extends State<FilterTgl> {
  final hari = [
    "Minggu",
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jum'at",
    "Sabtu"
  ];

  List<String> jam = ["00:00"];

  // int today = -1;

  late Timer timer;

  int dayNow = -1;

  void setDay() {
    hari.clear();

    DateTime now = DateTime.now();
    DateFormat df = DateFormat("EEEE", 'id_ID');

    dayNow = now.day;

    // today = now.day;

    for (var i = 0; i < 7; i++) {
      hari.insert(
          0,
          df.format(DateTime.fromMillisecondsSinceEpoch(
              now.millisecondsSinceEpoch - (i * 86400000))));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var i = 0; i < 25; i++) {
      if (i != 0) {
        jam.add("${i.toString().length > 1 ? "" : "0"}$i:00");
      }
      // if(i == 24){
      //   jam.add()
      // }
    }

    setDay();

    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      DateTime now = DateTime.now();
      if (dayNow != now.day) {
        setDay();

        widget.hariValue = widget.lastValue ? hari.last : hari[0];

        // widget.jamValue = widget.lastValue ? jam.last : jam.first;
        if (mounted) {
          setState(() {});
        }
      }
    });

    // hari.insert(0, "Pilih");

    if (widget.today > 0) {
      DateFormat df = DateFormat("EEEE", 'id_ID');
      DateTime d = DateTime.fromMillisecondsSinceEpoch(widget.today);

      widget.hariValue = df.format(d);
      widget.jamValue =
          "${d.hour.toString().length > 1 ? "" : "0"}${d.hour + (d.minute > 0 ? 1 : 0)}:00";
      if (kDebugMode) {
        print("jam value ${widget.jamValue}");
      }
    } else {
      widget.hariValue = widget.lastValue ? hari.last : hari[0];

      widget.jamValue = widget.lastValue ? jam.last : jam.first;
    }

    DateTime now = DateTime.now();

    widget.today =
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch -
            ((hari.reversed.toList().indexOf(widget.hariValue)) * 86400000);
    widget.today += ((jam.indexOf(widget.jamValue)) * 3600000) -
        ((jam.indexOf(widget.jamValue) == (jam.length - 1) ? 60000 : 0));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: lWidth < 900 ? 190 : 450,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: lWidth < 900 ? 190 : 450,
            decoration: BoxDecoration(
                color: MainStyle.secondaryColor,
                borderRadius: BorderRadius.circular(10),
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
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                    width: 100,
                    child: Text(
                      widget.title,
                      style: MyTextStyle.defaultFontCustom(Colors.black,
                          (lWidth / lheight) < wide && lWidth > 900 ? 24 : 14),
                    )),
                SizedBox(
                  width: lWidth < 900 ? 190 : 320,
                  child: Row(
                    children: [
                      MyDropDown(
                          items: hari,
                          value: widget.hariValue,
                          onChange: (value) {
                            DateTime now = DateTime.now();

                            widget.today =
                                DateTime(now.year, now.month, now.day)
                                        .millisecondsSinceEpoch -
                                    ((hari.reversed.toList().indexOf(value!)) *
                                        86400000);
                            if (kDebugMode) {
                              print("jam value ${widget.jamValue}");
                            }
                            widget.today +=
                                (jam.indexOf(widget.jamValue) * 3600000) -
                                    ((jam.indexOf(widget.jamValue) ==
                                            (jam.length - 1)
                                        ? 60000
                                        : 0));
                            setState(() {
                              widget.hariValue = value ?? "";
                            });

                            widget.changePage();
                          }),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      MainStyle.sizedBoxW10,
                      MyDropDown(
                          items: jam,
                          value: widget.jamValue,
                          onChange: (value) {
                            DateTime now = DateTime.now();

                            widget.today =
                                DateTime(now.year, now.month, now.day)
                                        .millisecondsSinceEpoch -
                                    ((hari.reversed
                                            .toList()
                                            .indexOf(widget.hariValue)) *
                                        86400000);
                            widget.today += jam.indexOf(value!) *
                                (3600000 -
                                    (jam.indexOf(value!) == (jam.length - 1)
                                        ? 60000
                                        : 0));
                            setState(() {
                              widget.jamValue = value ?? "";
                            });
                            widget.changePage();
                          }),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
