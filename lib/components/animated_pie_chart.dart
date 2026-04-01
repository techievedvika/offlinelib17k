import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../configs/helper/responsive_helper.dart';

class AnimatedPieChart extends StatelessWidget {
  final int touchedIndex;
  final Animation<double> animation;
  final int green;
  final int red;
  final int orange;
  final int white;
  final int na;

  const AnimatedPieChart({
    super.key,
    required this.touchedIndex,
    required this.animation,
    this.green = 0,
    this.red = 0,
    this.orange = 0,
    this.white = 0,
    this.na = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return SizedBox(
          height: Responsive(context).screenWidth() < 600 ? 220 : 300,
          width: Responsive(context).screenWidth() < 600 ? 220 : 300,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: showingSections(animation.value),
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(double scale) {
    final total = green + red + orange + white + na;

    double percent(int value) {
      return total == 0 ? 0 : (value / total) * 100;
    }

    return [
      PieChartSectionData(
        color: Colors.green,
        value: green.toDouble() * scale,
        title: '${percent(green).toStringAsFixed(1)}%',
        radius: touchedIndex == 0 ? 110.0 : 100.0,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: red.toDouble() * scale,
        title: '${percent(red).toStringAsFixed(1)}%',
        radius: touchedIndex == 1 ? 110.0 : 100.0,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: orange.toDouble() * scale,
        title: '${percent(orange).toStringAsFixed(1)}%',
        radius: touchedIndex == 2 ? 110.0 : 100.0,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.white,
        value: white.toDouble() * scale,
        title: '${percent(white).toStringAsFixed(1)}%',
        radius: touchedIndex == 3 ? 110.0 : 100.0,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 207, 191, 191),
        ),
      ),
      PieChartSectionData(
        color: Colors.black,
        value: na.toDouble() * scale,
        title: '${percent(na).toStringAsFixed(1)}%',
        radius: touchedIndex == 3 ? 110.0 : 100.0,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 207, 191, 191),
        ),
      ),
    ];
  }
}