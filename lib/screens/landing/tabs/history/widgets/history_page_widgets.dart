import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

BarChartGroupData generateGroupData(int x, int y) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        color: Colors.blue[400],
        toY: y.toDouble(),
        width: 7 * 7,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
    ],
  );
}
