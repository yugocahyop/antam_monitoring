import 'package:antam_monitoring/sign-up/controller/sign-up-controller.dart';

import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:antam_monitoring/widget/myTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Content_signUp extends StatefulWidget {
  Content_signUp({super.key, required this.postFunction});

  Function() postFunction;

  final Mytextfield email = Mytextfield(
    width: 500,
    hintText: "Email",
    obscure: false,
    inputType: TextInputType.emailAddress,
    prefixIcon: Icons.email,
  );

  final Mytextfield password = Mytextfield(
    width: 500,
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

  @override
  State<Content_signUp> createState() => _Content_signUpState();
}

class _Content_signUpState extends State<Content_signUp> {
  bool isRemember = false;

  final cc = SignUpController();
  final sc = ScrollController();

  signUp() async {
    await cc.signUp([widget.email, widget.password, widget.phone], context,
        () => widget.postFunction());
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Container(
      width: lWidth * 0.6,
      height: lheight * 0.8,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: MainStyle.secondaryColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: MainStyle.primaryColor,
            width: 7,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 30,
              offset: Offset(0, 20),
              color: Colors.black26,
              spreadRadius: 0,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Text(
              "Sign-up",
              style: MyTextStyle.defaultFontCustom(
                  MainStyle.primaryColor, lheight < 500 ? 20 : 65,
                  weight: FontWeight.bold),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            MainStyle.sizedBoxH10,
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/logo_xirka.svg",
                    width: lWidth * 0.2,
                  ),
                  SizedBox(
                    width: lWidth * 0.2,
                    child: Scrollbar(
                      controller: sc,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: sc,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: lWidth * 0.2, child: widget.email),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            MainStyle.sizedBoxH20,
                            SizedBox(
                                width: lWidth * 0.2, child: widget.password),
                            // const SizedBox(
                            //   height: 10,
                            // ),

                            MainStyle.sizedBoxH20,
                            SizedBox(width: lWidth * 0.2, child: widget.phone),
                            MainStyle.sizedBoxH10,

                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
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
                                MyButton(
                                    icon: Icon(
                                      Icons.login,
                                      color: Colors.white,
                                    ),
                                    color: MainStyle.primaryColor,
                                    text: "Sign-up",
                                    onPressed: () => widget.postFunction(),
                                    textColor: Colors.white),
                              ],
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            MainStyle.sizedBoxH10,
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
