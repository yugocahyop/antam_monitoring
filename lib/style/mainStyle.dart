import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/material.dart';

class MainStyle {
  static const primaryColor = Color(0xff00716A);
  static const secondaryColor = Color(0xffF1FCFD);
  static const thirdColor = Color(0xffC1E1DF);
  static const sizedBoxW10 = SizedBox(
    width: 10,
  );
  static const sizedBoxW20 = SizedBox(
    width: 20,
  );
  static const sizedBoxH20 = SizedBox(
    height: 20,
  );
  static const sizedBoxH10 = SizedBox(
    height: 10,
  );
  static const sizedBoxH5 = SizedBox(
    height: 5,
  );
  static const sizedBoxW5 = SizedBox(
    width: 5,
  );

  static TextStyle textStyleDefault20Primary =
      MyTextStyle.defaultFontCustom(MainStyle.primaryColor, 20);

  static TextStyle textStyleDefault14Black =
      MyTextStyle.defaultFontCustom(Colors.black, 14);

  static TextStyle textStyleDefault15White = MyTextStyle.defaultFontCustom(
    Colors.white,
    15,
  );

  static TextStyle textStyleDefault16Black =
      MyTextStyle.defaultFontCustom(Colors.black, 16);

  static TextStyle textStyleDefault15BlackBold =
      MyTextStyle.defaultFontCustom(Colors.black, 15, weight: FontWeight.bold);

  static TextStyle textStyleDefault25Primary =
      MyTextStyle.defaultFontCustomMono(MainStyle.primaryColor, 25);

  static TextStyle textStyleDefault20BlackBold =
      MyTextStyle.defaultFontCustom(Colors.black, 20, weight: FontWeight.bold);

  static TextStyle textStyleDefault40BlackBold =
      MyTextStyle.defaultFontCustom(Colors.black, 40, weight: FontWeight.bold);

  static TextStyle textStyleDefault12PrimaryW600 =
      MyTextStyle.defaultFontCustom(MainStyle.primaryColor, 12,
          weight: FontWeight.w600);
}
