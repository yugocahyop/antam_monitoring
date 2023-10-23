import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/sign-up/controller/sign-up-controller.dart';
// import 'package:antam_monitoring/home/home.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:antam_monitoring/widget/myTextField.dart';
import 'package:antam_monitoring/widget/overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../sign-up.dart';

class Content_signUp_mobile extends StatefulWidget {
  Content_signUp_mobile({super.key});

  @override
  State<Content_signUp_mobile> createState() => _Content_signUp_mobileState();
}

class _Content_signUp_mobileState extends State<Content_signUp_mobile> {
  bool isRemember = false;

  final Mytextfield email = Mytextfield(
    width: 800,
    hintText: "Email",
    obscure: false,
    inputType: TextInputType.emailAddress,
    prefixIcon: Icons.email,
  );

  final Mytextfield password = Mytextfield(
    width: 800,
    hintText: "Password",
    obscure: true,
    prefixIcon: Icons.lock,
    // inputType: TextInputType.emailAddress,
  );

  final Mytextfield phone = Mytextfield(
    width: 800,
    hintText: "Phone",
    obscure: false,
    prefixIcon: Icons.phone,
    // inputType: TextInputType.emailAddress,
  );

  final cc = SignUpController();

  bool isOverlay = false;

  double overlayOpacity = 0;

  toggleOverlay() {
    bool temp = !isOverlay;

    if (temp) {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          isOverlay = temp;
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
    await cc.signUp([email, password, phone], context);
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        SizedBox(
          width: lWidth,
          // height: lheight,
          child: Column(
            children: [
              Up(),
              const SizedBox(
                height: 50,
              ),
              SvgPicture.asset(
                "assets/logo_antam.svg",
                width: 250,
              ),
              const SizedBox(
                height: 50,
              ),
              Transform.translate(
                offset: Offset(0, 15),
                child: Container(
                  width: lWidth,
                  // height: 500 ,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, -2),
                            blurRadius: 10,
                            spreadRadius: 0)
                      ],
                      color: MainStyle.secondaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Row(
                            children: [
                              Icon(
                                Icons.chevron_left,
                                color: MainStyle.primaryColor,
                              ),
                              Text(
                                "Back",
                                style: MyTextStyle.defaultFontCustom(
                                    MainStyle.primaryColor, 14,
                                    weight: FontWeight.bold),
                              ),
                            ],
                          )),
                      Text(
                        "sign-up",
                        style: MyTextStyle.defaultFontCustom(
                            MainStyle.primaryColor, 36,
                            weight: FontWeight.bold),
                      ),
                      email,
                      password,
                      phone,
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      MainStyle.sizedBoxH10,

                      const SizedBox(
                        height: 30,
                      ),
                      MyButton(
                          icon: Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                          color: MainStyle.primaryColor,
                          text: "Sign-up",
                          onPressed: () => signUp(),
                          textColor: Colors.white),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
        Visibility(
            visible: false,
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
    );
  }
}
