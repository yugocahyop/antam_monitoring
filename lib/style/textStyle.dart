// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../style/mainStyle.dart';

class MyTextStyle {
  final double height;

  const MyTextStyle(this.height);

  static TextStyle poppinsCustom(Color color, double size,
      {FontWeight weight = FontWeight.normal}) {
    return GoogleFonts.poppins(
        fontSize: size, fontWeight: weight, color: color);
  }

  static TextStyle defaultFontCustom(Color color, double size,
      {FontWeight weight = FontWeight.normal, bool isStroke = false}) {
    return GoogleFonts.roboto(
        textStyle: !isStroke
            ? null
            : TextStyle(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.black),
        fontSize: size,
        fontWeight: weight,
        color: color);
  }

  static TextStyle defaultFontCustomMono(Color color, double size,
      {FontWeight weight = FontWeight.normal, bool isStroke = false}) {
    return GoogleFonts.robotoMono(
        textStyle: !isStroke
            ? null
            : TextStyle(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.black),
        fontSize: size,
        fontWeight: weight,
        color: color);
  }

  TextStyle defaultFontSmaller(Color color) {
    return GoogleFonts.inter(fontSize: height < 800 ? 10 : 12, color: color);
  }

  TextStyle defaultFontSmallerThick(Color color) {
    return GoogleFonts.inter(
        fontSize: height < 800 ? 10 : 12,
        color: color,
        fontWeight: FontWeight.w700);
  }

  TextStyle defaultFontSmall(Color color) {
    return GoogleFonts.inter(fontSize: height <= 500 ? 11 : 13, color: color);
  }

  TextStyle defaultFontSmallThick(Color color) {
    return GoogleFonts.inter(
        fontSize: height < 800 ? 13 : 15,
        color: color,
        fontWeight: FontWeight.w700);
  }

  TextStyle defaultFontMedium(Color color) {
    return GoogleFonts.inter(fontSize: height < 800 ? 14 : 16, color: color);
  }

  TextStyle defaultFontMediumThick(Color color) {
    return GoogleFonts.inter(
        fontSize: height < 800 ? 14 : 16,
        color: color,
        fontWeight: FontWeight.w700);
  }

  TextStyle defaultFontBig(Color color) {
    return GoogleFonts.inter(fontSize: height < 800 ? 17 : 19, color: color);
  }

  TextStyle defaultFontBigThick(Color color) {
    return GoogleFonts.inter(
        fontSize: height < 800 ? 17 : 19,
        color: color,
        fontWeight: FontWeight.w700);
  }

  TextStyle defaultFontBig2(Color color) {
    return GoogleFonts.inter(fontSize: height < 800 ? 26 : 28, color: color);
  }

  TextStyle defaultFontBigThick2(Color color) {
    return GoogleFonts.inter(
        fontSize: height < 800 ? 20 : 22,
        color: color,
        fontWeight: FontWeight.w700);
  }

  TextStyle defaultFontBigger(Color color) {
    return GoogleFonts.inter(fontSize: height < 800 ? 24 : 26, color: color);
  }

  TextStyle defaultFontBiggerThick(Color color) {
    return GoogleFonts.inter(
        fontSize: height < 800 ? 62 : 64,
        color: color,
        fontWeight: FontWeight.w700);
  }

  TextStyle defaultFontBigMidThick(Color color) {
    return GoogleFonts.inter(
        fontSize: height < 800 ? 32 : 34,
        color: color,
        fontWeight: FontWeight.w400);
  }
}
