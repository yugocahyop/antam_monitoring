import 'dart:math';

import 'package:antam_monitoring/style/textStyle.dart';

import '../style/mainStyle.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
// import 'package:qr_scanner/widget/dotPainter.dart';
import 'dart:ui' as ui;

class MyBarChart extends StatelessWidget {
  MyBarChart({this.color = Colors.green, required this.points, this.title});

  // double minX;
  // double minY;

  //  double maxX;
  // double maxY;

  // double step;

  List<FlSpot> points;
  // List<FlSpot> value;
  String? title;

  Color color;
  List<Color> gradientColors = [
    MainStyle.primaryColor,
    MainStyle.secondaryColor,
    Colors.white,
  ];

  // ui.Image? imageData;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 100,
        // minX: points.sort(),
        // maxX: step,

        borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.transparent),
              left: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            )),

        gridData: FlGridData(
            // horizontalInterval: 1,
            // verticalInterval: 1,
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (double value) {
              return FlLine(
                color: const Color(0xffC4DBD9),
                strokeWidth: 1,
                dashArray: [8, 4],
              );
            }),
        barGroups: points
            .map((e) => BarChartGroupData(x: e.x.toInt(), barRods: [
                  BarChartRodData(
                    toY: e.y,
                    color: Color(0xffF6FE34).withAlpha(200),
                    width: 8,
                  )
                ]))
            .toList(),
        titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
                axisNameSize: 25,
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                )),
            rightTitles: AxisTitles(
              // showTitles: false,
              axisNameSize: 200,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) => Text(""),
              ),
            ),
            topTitles: AxisTitles(
              axisNameSize: 30,
              axisNameWidget: Text(
                title ?? "",
                textAlign: TextAlign.left,
              ),
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              axisNameSize: 20,
              // axisNameWidget:  Text(title ?? "" , style: TextStyle(fontSize: 16, color: Colors.green),),
              sideTitles: SideTitles(
                getTitlesWidget: (value, meta) => Text(
                  "Sel ${value.toInt()}",
                  style: MyTextStyle.defaultFontCustom(Colors.black, 14),
                ),
                showTitles: true,
              ),
            )),
      ),
      swapAnimationDuration: const Duration(milliseconds: 100),
      // swapAnimationCurve: Curves.ease,
    );
  }
}