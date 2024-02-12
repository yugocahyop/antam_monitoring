import 'dart:math';

import 'package:antam_monitoring/style/textStyle.dart';

import '../style/mainStyle.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
// import 'package:qr_scanner/widget/dotPainter.dart';
import 'dart:ui' as ui;

class MyBarChart extends StatelessWidget {
  MyBarChart(
      {this.color = const Color(0xffF6FE34),
      required this.points,
      this.title,
      required this.max,
      required this.maxY,
      this.tangkiMaxData = const []});

  // double minX;
  // double minY;

  //  double maxX;
  // double maxY;

  // double step;

  List<FlSpot> points;
  // List<FlSpot> value;
  String? title;

  double max;

  double maxY;

  List<dynamic> tangkiMaxData;

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
        barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
              "Sel ${group.x}:\n",
              MyTextStyle.defaultFontCustom(Colors.white, 16,
                  weight: FontWeight.bold),
              children: [
                TextSpan(
                    text:
                        "${rod.toY.toStringAsFixed(2)} ${title!.toLowerCase().contains("tegangan") ? 'V' : 'A'}",
                    style: MyTextStyle.defaultFontCustom(color, 14))
              ]),
        )),
        gridData: FlGridData(
            // horizontalInterval: 1,
            // verticalInterval: 1,
            show: false,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (double value) {
              return FlLine(
                color: value == max
                    ? Colors.red.withAlpha(0)
                    : const Color(0xffC4DBD9),
                strokeWidth: 1,
                dashArray: [8, 4],
              );
            }),
        barGroups: points
            .map((e) => BarChartGroupData(x: e.x.toInt(), barRods: [
                  BarChartRodData(
                    toY: e.y,
                    color: color,
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
                getTitlesWidget: (value, meta) => const Text(""),
              ),
            ),
            topTitles: AxisTitles(
              axisNameSize: 30,
              axisNameWidget: const Text(
                "",
                textAlign: TextAlign.left,
              ),
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              drawBehindEverything: true,
              axisNameSize: 20,
              // axisNameWidget:  Text(title ?? "" , style: TextStyle(fontSize: 16, color: Colors.green),),
              sideTitles: SideTitles(
                getTitlesWidget: (value, meta) => Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(tangkiMaxData.isEmpty ? 0 : 10, 0),
                      child: Text(
                        "Sel ${value.toInt()}",
                        style: MyTextStyle.defaultFontCustom(Colors.black, 14),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, 20),
                      child: Visibility(
                        visible: tangkiMaxData.isNotEmpty,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MainStyle.primaryColor),
                          child: Text(
                            tangkiMaxData.isEmpty
                                ? ""
                                : "Tangki ${tangkiMaxData[value.toInt() - 1][title!.toLowerCase()]}",
                            style:
                                MyTextStyle.defaultFontCustom(Colors.white, 12),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                showTitles: true,
              ),
            )),
      ),
      swapAnimationDuration: const Duration(milliseconds: 300),
      // swapAnimationCurve: Curves.ease,
    );
  }
}
