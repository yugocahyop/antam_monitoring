import 'dart:async';

import 'package:antam_monitoring/home/widget/menu.dart';
import 'package:antam_monitoring/home/widget/myDropDown.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
// import 'package:date_picker_plus/date_picker_plus.dart';
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

  DateFormat df1 = DateFormat("dd/MM/yyyy", 'id_ID');

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
    return Theme(
      data: Theme.of(context).copyWith(
        // colorScheme: ColorScheme(
        //     brightness: Brightness.light,
        //     primary: MainStyle.secondaryColor,
        //     onPrimary: MainStyle.primaryColor,
        //     secondary: MainStyle.primaryColor,
        //     onSecondary: MainStyle.secondaryColor,
        //     error: Colors.red,
        //     onError: Colors.red,
        //     background: MainStyle.secondaryColor,
        //     onBackground: MainStyle.primaryColor,
        //     surface: MainStyle.secondaryColor,
        //     onSurface: MainStyle.primaryColor),

        datePickerTheme: const DatePickerThemeData(
          backgroundColor: MainStyle.secondaryColor,
          surfaceTintColor: Colors.transparent,
          headerForegroundColor: MainStyle.primaryColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: MainStyle.primaryColor, // button text color
          ),
        ),
      ),
      child: SizedBox(
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
                        style: MyTextStyle.defaultFontCustom(
                            Colors.black,
                            (lWidth / lheight) < wide && lWidth > 900
                                ? 24
                                : 14),
                      )),
                  InkWell(
                    onTap: () async {
                      final now = DateTime.now();
                      final date = await showDatePicker(
                        context: context,
                        currentDate: DateTime.fromMillisecondsSinceEpoch(0),
                        initialDate:
                            DateTime.fromMillisecondsSinceEpoch(widget.today),
                        firstDate: DateTime.fromMillisecondsSinceEpoch(
                            now.millisecondsSinceEpoch - (2419200000 * 2)),
                        lastDate: now,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            // The below-written code will only affect the pop-up window.
                            data: ThemeData(
                              // I tried to match my picker with your photo.
                              useMaterial3: true,
                              brightness: Brightness.light,
                              colorSchemeSeed: MainStyle.primaryColor,
                              // // Write your own code for customizing the date picker theme.
                              // indicatorColor: MainStyle.primaryColor,
                              // colorScheme: ColorScheme(
                              //     brightness: Brightness.light,
                              //     primary: MainStyle.primaryColor,
                              //     onPrimary: MainStyle.secondaryColor,
                              //     secondary: MainStyle.primaryColor,
                              //     onSecondary: MainStyle.secondaryColor,
                              //     error: Colors.red,
                              //     onError: Colors.red,
                              //     background: MainStyle.primaryColor,
                              //     onBackground: MainStyle.secondaryColor,
                              //     surface: MainStyle.secondaryColor,
                              //     onSurface: MainStyle.primaryColor),

                              datePickerTheme: DatePickerThemeData(
                                  backgroundColor: Colors.white,
                                  surfaceTintColor: Colors.transparent,
                                  headerForegroundColor: MainStyle.primaryColor,
                                  yearForegroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return MainStyle.primaryColor;
                                    }
                                    return Colors.black;
                                  }),
                                  dayForegroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return MainStyle.primaryColor;
                                    } else if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.black.withAlpha(55);
                                    }
                                    return Colors.black;
                                  }),
                                  yearBackgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return MainStyle.secondaryColor;
                                    }
                                    return Colors.transparent;
                                  }),
                                  dayBackgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return MainStyle.secondaryColor;
                                    }
                                    return Colors.transparent;
                                  })),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: MainStyle
                                      .primaryColor, // button text color
                                ),
                              ),
                              textSelectionTheme: TextSelectionThemeData(
                                cursorColor: MainStyle.primaryColor,
                                selectionColor:
                                    MainStyle.primaryColor.withAlpha(155),
                                selectionHandleColor: MainStyle.primaryColor,
                              ),
                            ),
                            child: child ?? const SizedBox(),
                          );
                        },
                      );

                      // final time = await showTimePicker(
                      //     builder: (context, child) {
                      //       return Theme(
                      //         data: Theme.of(context).copyWith(
                      //             colorScheme: ColorScheme.light(
                      //                 primary: MainStyle.primaryColor),
                      //             textButtonTheme: TextButtonThemeData(
                      //               style: TextButton.styleFrom(
                      //                 foregroundColor: MainStyle
                      //                     .primaryColor, // button text color
                      //               ),
                      //             )),
                      //         child: child!,
                      //       );
                      //     },
                      //     context: context,
                      //     initialTime: TimeOfDay(hour: 0, minute: 0));

                      if (date != null) {
                        widget.today = (date.millisecondsSinceEpoch
                            // (time.hour * 3600000) +
                            // (time.minute * 60000)
                            );

                        // DateFormat df2 = DateFormat("HH:00");
                        // widget.jamValue = df2.format(
                        //     (DateTime.fromMillisecondsSinceEpoch(
                        //         widget.today)));

                        widget.today += (jam.indexOf(widget.jamValue) *
                                3600000) -
                            ((jam.indexOf(widget.jamValue) == (jam.length - 1)
                                ? 60000
                                : 0));
                        setState(() {});

                        widget.changePage();
                      }
                    },
                    child: SizedBox(
                        width: lWidth < 900 ? 190 : 320,
                        child: Row(
                          children: [
                            Container(
                              width: lWidth < 900 ? 80 : 150,
                              height: 30,
                              padding: EdgeInsets.only(
                                  left: lWidth < 900 ? 3 : 20,
                                  right: lWidth < 600 ? 3 : 20),
                              decoration: BoxDecoration(
                                  color: MainStyle.primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      df1.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              widget.today)),
                                      // textAlign: TextA,
                                      style: MyTextStyle.defaultFontCustom(
                                          Colors.white,
                                          (lWidth / lheight) < wide &&
                                                  lWidth > 900
                                              ? 23
                                              : lWidth < 900
                                                  ? 12
                                                  : 14),
                                    ),
                                    MainStyle.sizedBoxW10,
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                      size: 22,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            MainStyle.sizedBoxW10,
                            MyDropDown(
                                items: jam,
                                value: widget.jamValue,
                                onChange: (value) {
                                  // DateTime now = DateTime.now();

                                  // widget.today =
                                  //     DateTime(now.year, now.month, now.day)
                                  //             .millisecondsSinceEpoch -
                                  //         ((hari.reversed
                                  //                 .toList()
                                  //                 .indexOf(widget.hariValue)) *
                                  //             86400000);
                                  widget.today += jam.indexOf(value!) *
                                      (3600000 -
                                          (jam.indexOf(value!) ==
                                                  (jam.length - 1)
                                              ? 60000
                                              : 0));
                                  setState(() {
                                    widget.jamValue = value ?? "";
                                  });
                                  widget.changePage();
                                }),
                          ],
                        )
                        // Row(
                        //   children: [
                        //     MyDropDown(
                        //         items: hari,
                        //         value: widget.hariValue,
                        //         onChange: (value) {
                        //           DateTime now = DateTime.now();

                        //           widget.today =
                        //               DateTime(now.year, now.month, now.day)
                        //                       .millisecondsSinceEpoch -
                        //                   ((hari.reversed.toList().indexOf(value!)) *
                        //                       86400000);
                        //           if (kDebugMode) {
                        //             print("jam value ${widget.jamValue}");
                        //           }
                        //           widget.today +=
                        //               (jam.indexOf(widget.jamValue) * 3600000) -
                        //                   ((jam.indexOf(widget.jamValue) ==
                        //                           (jam.length - 1)
                        //                       ? 60000
                        //                       : 0));
                        //           setState(() {
                        //             widget.hariValue = value ?? "";
                        //           });

                        //           widget.changePage();
                        //         }),
                        //     // const SizedBox(
                        //     //   width: 10,
                        //     // ),
                        //     MainStyle.sizedBoxW10,
                        //     MyDropDown(
                        //         items: jam,
                        //         value: widget.jamValue,
                        //         onChange: (value) {
                        //           DateTime now = DateTime.now();

                        //           widget.today =
                        //               DateTime(now.year, now.month, now.day)
                        //                       .millisecondsSinceEpoch -
                        //                   ((hari.reversed
                        //                           .toList()
                        //                           .indexOf(widget.hariValue)) *
                        //                       86400000);
                        //           widget.today += jam.indexOf(value!) *
                        //               (3600000 -
                        //                   (jam.indexOf(value!) == (jam.length - 1)
                        //                       ? 60000
                        //                       : 0));
                        //           setState(() {
                        //             widget.jamValue = value ?? "";
                        //           });
                        //           widget.changePage();
                        //         }),
                        //   ],
                        // ),
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
