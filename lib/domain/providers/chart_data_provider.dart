import 'dart:ui';

import 'package:trakli/domain/models/chart_data_model.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/graph_widget.dart';
import 'dart:math' as math;

class StatisticsProvider {
  List<ChartStatistics> getChartData() {
    return [
      ChartStatistics("10", 100, 500),
      ChartStatistics("11", 440, 228),
      ChartStatistics("12", 300, 50),
      ChartStatistics("13", 550, 30),
      ChartStatistics("14", 350, 350),
    ];
  }

  List<ChartData> getSummaryData() {
    return [
      ChartData(
        'Total Expense',
        24478,
        expenseRedText,
      ),
      ChartData(
        'Total Income',
        138000,
        const Color(0xFF047844),
      ),
    ];
  }

 List<ChartData> getPieData = [
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
}
