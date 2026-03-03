import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../configs/color/color.dart';

class BookStatsChart extends StatefulWidget {
  final List<dynamic> barGraphData;

  const BookStatsChart({
    super.key,
    required this.barGraphData,
  });

  @override
  State<BookStatsChart> createState() => _BookStatsChartState();
}

class _BookStatsChartState extends State<BookStatsChart> {
  int getTotalBooksIssued() {
    return widget.barGraphData.fold<int>(
      0,
      (sum, item) => sum + ((item['total_issues'] ?? 0) as num).toInt(),
    );
  }

  double getMaxY() {
  if (widget.barGraphData.isEmpty) return 10; // Or any default safe value

  final max = widget.barGraphData
      .map((e) => (e['total_issues'] ?? 0) as num)
      .reduce((a, b) => a > b ? a : b);

  return (max * 1.2).ceilToDouble(); // Adds 20% headroom
}

  double getDynamicInterval(double maxY) {
    if (maxY <= 10) return 1;
    if (maxY <= 50) return 5;
    if (maxY <= 100) return 10;
    if (maxY <= 200) return 20;
    if (maxY <= 500) return 50;
    return 100;
  }

  @override
  Widget build(BuildContext context) {
   
    final totalBooksIssued = getTotalBooksIssued();
    final maxY = getMaxY();
    final interval = getDynamicInterval(maxY);
    

    return Card(
      //margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Month-wise Book Issues',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  //color: Colors.deepPurple
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            /// Scrollable graph
     widget.barGraphData.isNotEmpty
    ? SizedBox(
        height: 220,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            //width: MediaQuery.sizeOf(context).width,
            width: widget.barGraphData.length * 90,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barGroups: _buildChartData(),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(
                    show: true,
                    verticalInterval: 10,
                    horizontalInterval: 10,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.deepPurple,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} books',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < widget.barGraphData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              widget.barGraphData[value.toInt()]['issue_month'],
                              style: const TextStyle(
                                  fontSize: 8, color: Colors.grey),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      reservedSize: 28,
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                ),
              ),
            ),
          ),
        ),
      )
    : const SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'No data available to display the chart.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ),

            const SizedBox(height: 24),

            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 16),

            /// Total books issued
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Books Issued',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  totalBooksIssued.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildChartData() {
    return widget.barGraphData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (data['total_issues'] ?? 0).toDouble(),
            color: Colors.deepPurple,
            width: 24,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();
  }
}
