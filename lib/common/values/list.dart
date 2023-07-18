import 'dart:math';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder_app/common/models/bar_data_model.dart';
import 'package:water_reminder_app/common/models/cup_model.dart';

// Types of cups
List<CupModel> cups = [
  CupModel(
      id: '0',
      type: '100ml',
      capacity: '100',
      path: 'assets/icons/png/100ml.png'),
  CupModel(
      id: '1',
      type: '150ml',
      capacity: '150',
      path: 'assets/icons/png/150ml.png'),
  CupModel(
      id: '2',
      type: '175ml',
      capacity: '175',
      path: 'assets/icons/png/175ml.png'),
  CupModel(
      id: '3',
      type: '200ml',
      capacity: '200',
      path: 'assets/icons/png/200ml.png'),
  CupModel(
      id: '4',
      type: '300ml',
      capacity: '300',
      path: 'assets/icons/png/300ml.png'),
  CupModel(
      id: '5',
      type: '500ml',
      capacity: '500',
      path: 'assets/icons/png/500ml.png'),
];

List<String> weekName = [
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thur',
  'Fri',
  'Sat',
];

// #1 Store the data from firebase to BarDataModel
List<BarDataModel> barData = [
  BarDataModel(
    id: 0,
    name: 'Mon',
    y: 15,
    color: Color(0xff19bfff),
  ),
  BarDataModel(
    id: 1,
    name: 'Tue',
    y: 11,
    color: Color(0xffff4d94),
  ),
  BarDataModel(
    id: 2,
    name: 'Wed',
    y: 14,
    color: Color(0xff2bdb90),
  ),
];

// #2 Distribute the model data and store it in a datatype List<BarChartGroupData>
List<BarChartGroupData> barChartList = [
  BarChartGroupData(
    x: 0,
    barRods: [
      BarChartRodData(
        color: Colors.blue[400],
        toY: 10.toDouble(),
        width: 45,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
    ],
  ),
  BarChartGroupData(
    x: 1,
    barRods: [
      BarChartRodData(
        color: Colors.blue[400],
        toY: 15.toDouble(),
        width: 45,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
    ],
  ),
  BarChartGroupData(
    x: 2,
    barRods: [
      BarChartRodData(
        color: Colors.blue[400],
        toY: 20.toDouble(),
        width: 45,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
    ],
  ),
  BarChartGroupData(
    x: 3,
    barRods: [
      BarChartRodData(
        color: Colors.blue[400],
        toY: 30.toDouble(),
        width: 45,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
    ],
  )
];
