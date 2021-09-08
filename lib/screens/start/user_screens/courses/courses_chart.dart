// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';

// 🌎 Project imports:
import 'package:learnlab/shared/constants.dart';

class CoursesChart extends StatelessWidget {
  final List<int> grades;

  const CoursesChart({this.grades = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      height: 150,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
                isCurved: true,
                barWidth: 4,
                colors: [ColorTheme.light],
                spots: grades
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                    .toList(),
                dotData: FlDotData(show: false))
          ],
        ),
      ),
    );
  }
}
