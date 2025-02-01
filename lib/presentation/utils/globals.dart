import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
const String maxUploadSizeInMB = "5Mo";
final List<Locale> languages = [
  const Locale('en'),
  const Locale('fr'),
];


class ChartData {
  ChartData(this.property, this.value, [this.color]);

  final String property;
  final double value;
  final Color? color;
}

final List<ChartData> chartData = [
  ChartData('Food', 30, Colors.blueAccent),
  ChartData('Education', 20, Colors.greenAccent),
  ChartData('Clothes', 20, Colors.redAccent),
  ChartData('Rents', 10, Colors.purpleAccent),
  ChartData('Girls', 10, Colors.pink),
  ChartData('Other', 10, Colors.orangeAccent),
];
