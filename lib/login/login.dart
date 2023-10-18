library login;

import 'dart:io';
import 'dart:math';

import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/home/home.dart';
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
                        lWidth > 900 ? Content_login() : Content_login_mobile(),
                        Visibility(
                          visible: lWidth > 900,
                          child: Transform.rotate(
                            angle: pi,
                            child: Side(),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            : Column(
                // width: lWidth,
                // height: lheight,
                children: [
                  Flexible(
                      flex: 1,
                      child:
                          SingleChildScrollView(child: Content_login_mobile()))
                ],
              ));
  }
}
