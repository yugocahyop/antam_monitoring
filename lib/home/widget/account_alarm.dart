import 'dart:async';

import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Account_alarm extends StatefulWidget {
  Account_alarm(
      {super.key,
      required this.alarm,
      required this.isAdmin,
      this.isTv = false});

  List<Map> alarm;

  bool isAdmin;

  bool isTv;

  Function()? setState;

  @override
  State<Account_alarm> createState() => _Account_alarmState();
}

class _Account_alarmState extends State<Account_alarm> {
  String date = "", time = "";

  DateFormat df = DateFormat("dd/MM/yyyy");

  String addZero(int) {
    String res = int.toString();

    if (int.toString().length == 1) {
      res = "0$res";
    }
    return res;
  }

  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.setState = () => mounted ? setState(() {}) : () {};

    DateTime dateTime = DateTime.now();

    date = df.format(dateTime);

    time = "${addZero(dateTime.hour)}:${addZero(dateTime.minute)} ";

    setState(() {});

    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      DateTime dateTime = DateTime.now();

      date = df.format(dateTime);

      time = "${addZero(dateTime.hour)}:${addZero(dateTime.minute)} ";

      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  final double wide = 16 / 9;

  TextStyle textStyle16BlackBold =
      MyTextStyle.defaultFontCustom(Colors.black, 16, weight: FontWeight.bold);

  TextStyle textStyle26BlackBold =
      MyTextStyle.defaultFontCustom(Colors.black, 26, weight: FontWeight.bold);

  TextStyle textStyle16Black = MyTextStyle.defaultFontCustom(Colors.black, 16);

  TextStyle textStyle26Black = MyTextStyle.defaultFontCustom(Colors.black, 26);

  TextStyle textStyle24Grey = MyTextStyle.defaultFontCustom(Colors.grey, 24);

  TextStyle textStyle16Grey = MyTextStyle.defaultFontCustom(
    Colors.grey,
    16,
  );

  TextStyle textStyle24Primary =
      MyTextStyle.defaultFontCustom(MainStyle.primaryColor, 24);

  TextStyle textStyle14Primary =
      MyTextStyle.defaultFontCustom(MainStyle.primaryColor, 14);

  Widget userSvg = SvgPicture.asset(
    "assets/user.svg",
    width: 30,
  );

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: (lWidth / lheight) < wide
          ? 1430
          : lWidth < 900
              ? lWidth < 500
                  ? lWidth
                  : lWidth * 0.4
              : 1230,
      child: Row(
        mainAxisAlignment: lWidth < 900
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: const BoxDecoration(),
            clipBehavior: Clip.none,
            width: (lWidth < 900
                ? lWidth < 800
                    ? 300
                    : lWidth * 0.4
                : 300),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Column(
                children: [
                  Visibility(
                    visible: widget.isTv && lWidth < 900,
                    child: SizedBox(
                      width: (lWidth / lheight) < wide ? 430 : 300,
                      child: Row(
                        children: [
                          Text(
                            time,
                            style: (lWidth / lheight) < wide
                                ? textStyle26BlackBold
                                : textStyle16BlackBold,
                          ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          MainStyle.sizedBoxW20,
                          Text(
                            date,
                            style: (lWidth / lheight) < wide
                                ? textStyle26Black
                                : textStyle16Black,
                          ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          MainStyle.sizedBoxW20,
                          // SvgPicture.asset(
                          //   "assets/user.svg",
                          //   width: 30,
                          // ),
                          userSvg,
                          // const SizedBox(
                          //   width: 5,
                          // ),
                          MainStyle.sizedBoxW5,
                          Expanded(
                            child: Text(
                              widget.isAdmin ? "Admin" : "User",
                              style: (lWidth / lheight) < wide
                                  ? textStyle24Primary
                                  : textStyle14Primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: widget.alarm
                        .map((e) => Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: ((e["isActive"] as bool)
                                      ? Colors.red
                                      : Colors.grey),
                                  size: 15,
                                ),
                                SizedBox(
                                  width: (lWidth / lheight) < wide ? 3 : 2,
                                ),
                                Text(
                                  e["title"] as String,
                                  style:
                                      (lWidth / lheight) < wide && lWidth > 900
                                          ? textStyle24Grey
                                          : textStyle16Grey,
                                ),
                                // const SizedBox(
                                //   width: 10,
                                // )
                                MainStyle.sizedBoxW10,
                              ],
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: lWidth >= 900,
            child: SizedBox(
              width: (lWidth / lheight) < wide ? 430 : 300,
              child: Row(
                children: [
                  Text(
                    time,
                    style: (lWidth / lheight) < wide
                        ? textStyle26BlackBold
                        : textStyle16BlackBold,
                  ),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  MainStyle.sizedBoxW20,
                  Text(
                    date,
                    style: (lWidth / lheight) < wide
                        ? textStyle26Black
                        : textStyle16Black,
                  ),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  MainStyle.sizedBoxW20,
                  // SvgPicture.asset(
                  //   "assets/user.svg",
                  //   width: 30,
                  // ),
                  userSvg,
                  // const SizedBox(
                  //   width: 5,
                  // ),
                  MainStyle.sizedBoxW5,
                  Expanded(
                    child: Text(
                      widget.isAdmin ? "Admin" : "User",
                      style: (lWidth / lheight) < wide
                          ? textStyle24Primary
                          : textStyle14Primary,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
