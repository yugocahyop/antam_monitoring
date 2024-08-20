library signUp;

import 'dart:math';

// import 'package:antam_monitoring/home/home.dart';
import 'package:antam_monitoring/sign-up/controller/sign-up-controller.dart';
import 'package:antam_monitoring/sign-up/widget/content_signUp.dart';
import 'package:antam_monitoring/sign-up/widget/content_signUp_mobile.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/widget/overlay.dart';
import 'package:flutter/material.dart';

part 'widget/side.dart';
// part 'widget/content_SignUp.dart';
part 'widget/up.dart';
// part 'widget/content_SignUp_mobile.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final cc = SignUpController();

  late Content_signUp c_signUp;

  bool isOverlay = false;

  double overlayOpacity = 0;

  toggleOverlay() {
    bool temp = !isOverlay;

    if (temp) {
      setState(() {
        isOverlay = temp;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          // isOverlay = temp;
          overlayOpacity = 1;
        });
      });
    } else {
      setState(() {
        overlayOpacity = 0;
      });
    }
  }

  signUp() async {
    await cc.signUp([c_signUp.email, c_signUp.password, c_signUp.phone],
        context, () => toggleOverlay());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c_signUp = Content_signUp(postFunction: () => signUp());
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
                        c_signUp,
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
                  Visibility(
                      visible: isOverlay,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: overlayOpacity,
                        onEnd: () {
                          if (overlayOpacity == 0) {
                            setState(() {
                              isOverlay = false;
                            });
                          }
                        },
                        child: MyOverlay(
                          isBlur: true,
                          isTransparent: true,
                        ),
                      ))
                ],
              )
            : Column(
                // width: lWidth,
                // height: lheight,
                children: [Flexible(flex: 1, child: Content_signUp_mobile())],
              ));
  }
}
