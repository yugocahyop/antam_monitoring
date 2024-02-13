library login;

import 'dart:io';
import 'dart:math';

import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/home/home.dart';
import 'package:antam_monitoring/login/controller/login_controller.dart';
import 'package:antam_monitoring/login/widget/message.dart';
import 'package:antam_monitoring/login/widget/message_mobile.dart';
import 'package:antam_monitoring/sign-up/sign-up.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/encrypt.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:antam_monitoring/widget/myTextField.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../widget/overlay.dart';

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
          overlayOpacity = 1;
        });
      });
    } else {
      setState(() {
        overlayOpacity = 0;
      });
    }
  }

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

  void preCache(AssetBundle rootBundle) {
    cachedActor(
      AssetFlare(bundle: rootBundle, name: 'assets/xirkaLoading.flr'),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c_login = Content_login(
        signUpDone: () =>
            createMsg("Activaton link has been sent to your email"),
        toggleOverlay: () => toggleOverlay());

    WidgetsFlutterBinding.ensureInitialized();
    FlareCache.doesPrune = false;

    preCache(rootBundle);
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
                children: [Flexible(flex: 1, child: c_login_mobile)],
              ));
  }
}
