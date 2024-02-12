import 'dart:math';

import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/material.dart';

class AccountSetting extends StatelessWidget {
  const AccountSetting({super.key, required this.email, required this.isAdmin});

  final String email;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 540,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Account",
                      style: MyTextStyle.defaultFontCustom(Colors.black, 22,
                          weight: FontWeight.w700)),
                  MainStyle.sizedBoxH10,
                  Row(
                    children: [
                      Text(
                        "Masuk Sebagai ",
                        style: MyTextStyle.defaultFontCustom(
                            const Color(0xff919798), 14),
                      ),
                      Text(
                        isAdmin ? "Administrator" : "User",
                        style: MyTextStyle.defaultFontCustom(
                            MainStyle.primaryColor, 14),
                      ),
                    ],
                  )
                ],
              ),
              Icon(
                Icons.person,
                color: MainStyle.primaryColor,
                size: 60,
              )
            ],
          ),
          MainStyle.sizedBoxH10,
          SizedBox(
            width: 500,
            child: Divider(
              color: Color(0xff9ACAC8),
            ),
          ),
          MainStyle.sizedBoxH10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Akun Anda",
                  style: MyTextStyle.defaultFontCustom(Colors.black, 22,
                      weight: FontWeight.w700)),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: pi * 0.7,
                        child: const Icon(
                          Icons.key,
                          color: const Color(0xff919798),
                          size: 20,
                        ),
                      ),
                      Text(
                        "Edit Password",
                        style: MyTextStyle.defaultFontCustom(
                            const Color(0xff919798), 14),
                      )
                    ],
                  )),
            ],
          ),
          MainStyle.sizedBoxH10,
          Row(
            children: [
              Image.asset(
                "assets/circleAvatarBig.png",
                width: 120,
              ),
              MainStyle.sizedBoxW10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email,
                    style: MyTextStyle.defaultFontCustom(
                        MainStyle.primaryColor, 14,
                        weight: FontWeight.w600),
                  ),
                  MainStyle.sizedBoxH10,
                  Text(
                    isAdmin ? "Administrator" : "User",
                    style: MyTextStyle.defaultFontCustom(
                        MainStyle.primaryColor, 14,
                        weight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
