library login;

import 'dart:io';
import 'dart:math';

import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/home/home.dart';
import 'package:antam_monitoring/login/controller/login_controller.dart';
import 'package:antam_monitoring/login/widget/message.dart';
import 'package:antam_monitoring/sign-up/sign-up.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:antam_monitoring/widget/myTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'widget/side.dart';
part 'widget/content_login.dart';
part 'widget/up.dart';
part 'widget/content_login_mobile.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Content_login c_login;
  final c_login_mobile = Content_login_mobile();

  List<Widget> msgs = [];

  // int msgIndex = 0;

  createMsg(String text) {
    msgs.add(
      MyMessage(
          warningMsg: text,
          dismiss: () {
            msgs.removeAt(msgs.length - 1);
            setState(() {});
          }),
    );

    // msgIndex++;

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c_login = Content_login(
      signUpDone: () => createMsg("Activaton link has been sent to your email"),
    );

    // createMsg("text");
    // createMsg("text");
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: lWidth > 900
            ? Stack(
                children: [
                  SizedBox(
                    width: lWidth,
                    height: lheight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(visible: lWidth > 900, child: Side()),
                        lWidth > 900 ? c_login : c_login_mobile,
                        Visibility(
                          visible: lWidth > 900,
                          child: Transform.rotate(
                            angle: pi,
                            child: Side(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Stack(
                    children: msgs,
                  )
                ],
              )
            : Column(
                // width: lWidth,
                // height: lheight,
                children: [
                  Flexible(
                      flex: 1,
                      child: SingleChildScrollView(child: c_login_mobile))
                ],
              ));
  }
}
