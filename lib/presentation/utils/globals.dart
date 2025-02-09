import 'dart:math' as math;

import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
const String maxUploadSizeInMB = "5Mo";
final List<Locale> supportedLanguages = [
  const Locale('en'),
  const Locale('fr'),
  const Locale('de'),
  const Locale('es'),
  const Locale('it'),
];

class ChartData {
  ChartData(this.property, this.value, [this.color]);

  final String property;
  final double value;
  final Color? color;
}

final List<ChartData> chartData = [
  ChartData(
    'Food',
    30,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
  ChartData(
    'Education',
    20,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
  ChartData(
    'Clothes',
    20,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
  ChartData(
    'Rents',
    10,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
  ChartData(
    'Girls',
    10,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
  ChartData(
    'Other',
    15,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
];
