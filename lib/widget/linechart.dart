import 'dart:math';

import '../style/mainStyle.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
// import 'package:qr_scanner/widget/dotPainter.dart';
import 'dart:ui' as ui;

class MyLineChart extends StatelessWidget {
  MyLineChart(
      {this.color = Colors.green,
      required this.points,
      this.title,
      required this.maxY});

  // double minX;
  // double minY;

  //  double maxX;
  double maxY;

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
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
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
        lineTouchData: LineTouchData(
          enabled: true,
          // touchTooltipData: LineTouchTooltipData(
          //   getTooltipItems: (touchedSpots) {
          //     return touchedSpots.map((e) {

          //       return LineTooltipItem("", textStyle)
          //     }).toList();
          //   },
          // )
        ),

        clipData: FlClipData.none(),
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
        lineBarsData: [
          LineChartBarData(
            belowBarData: BarAreaData(
              show: false,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
              ),
            ),
            spots: points,
            dotData: FlDotData(
              show: false,
            ),
            // gradient: LinearGradient(
            //         colors: gradientColors,
            //       ),
            color: Colors.red,
            dashArray: [8, 4],
            // colorStops: [0.1, 1.0],
            barWidth: 1,
            isCurved: false,
          ),
        ],
        titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            )),
            rightTitles: AxisTitles(
              // showTitles: false,
              // axisNameSize: 100,
              sideTitles: SideTitles(
                interval: points.first.y,
                reservedSize: 60,
                showTitles: true,
                getTitlesWidget: (value, meta) => value == points.last.y
                    ? const Text("  Setting")
                    : const Text(""),
              ),
            ),
            topTitles: AxisTitles(
                axisNameSize: 30,
                sideTitles: SideTitles(showTitles: false),
                axisNameWidget: const Text("")),
            bottomTitles: AxisTitles(
              axisNameSize: 20,
              // axisNameWidget:  Text(title ?? "" , style: TextStyle(fontSize: 16, color: Colors.green),),
              sideTitles: SideTitles(
                getTitlesWidget: (value, meta) => const Text(""),
                showTitles: true,
              ),
            )),
      ),
      swapAnimationDuration: const Duration(milliseconds: 500),
      // swapAnimationCurve: Curves.ease,
    );
  }
}
