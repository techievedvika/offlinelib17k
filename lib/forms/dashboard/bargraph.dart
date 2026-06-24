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
          (sum, item) => sum + _toDouble(item['total_issues']).toInt(),
    );
  }

  String formatMonthYear(String value) {
    final parts = value.split(' ');
    if (parts.length != 2) return value;

    return '${parts[0].substring(0, 3)} ${parts[1]}';
  }

  double getMaxY() {
    if (widget.barGraphData.isEmpty) return 10;

    final max = widget.barGraphData
        .map((e) => _toDouble(e['total_issues']))
        .reduce((a, b) => a > b ? a : b);

    return (max * 1.2).ceilToDouble();
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
              'Month-wise Book Issued',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  //color: Colors.deepPurple
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),

            /// Scrollable graph
     widget.barGraphData.isNotEmpty
    ? SizedBox(
        height: 230,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            //width: MediaQuery.sizeOf(context).width,
            width: widget.barGraphData.length * 65,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barGroups: _buildChartData(),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(
                  show: true,
                  verticalInterval: 5,
                  horizontalInterval: 10,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                ),
                barTouchData: BarTouchData(
                  enabled: true,

                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.black87,
                    direction: TooltipDirection.auto,
                    fitInsideVertically: true,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final data = widget.barGraphData[group.x.toInt()];
                      final fullMonth = data['issue_month'];

                      return BarTooltipItem(
                        '${formatMonthYear(fullMonth)}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Green: ${data['green']}\n',
                            style: const TextStyle(color: Colors.green),
                          ),
                          TextSpan(
                            text: 'Red: ${data['red']}\n',
                            style: const TextStyle(color: Colors.red),
                          ),
                          TextSpan(
                            text: 'Orange: ${data['orange']}\n',
                            style: const TextStyle(color: Colors.orange),
                          ),
                          TextSpan(
                            text: 'White: ${data['white']}\n',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'Others: ${data['na']}',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final fullMonth = widget.barGraphData[value.toInt()]['issue_month'];
                        final shortMonth = fullMonth.split(' ')[0].substring(0, 3);

                        if (value.toInt() >= 0 &&
                            value.toInt() < widget.barGraphData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              formatMonthYear(fullMonth), // Apr, Sep, Oct...
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                              // widget.barGraphData[value.toInt()]['issue_month'],
                              // style: const TextStyle(
                              //     fontSize: 8, color: Colors.grey),
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
                      reservedSize: 18,
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

            // const SizedBox(height: 24),
            //
            // const Divider(height: 1, color: Colors.grey),
            // const SizedBox(height: 16),
            //
            // /// Total books issued
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text(
            //       'Total Books Issued',
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            //     ),
            //     Text(
            //       totalBooksIssued.toString(),
            //       style: const TextStyle(
            //         fontSize: 18,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.deepPurple,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }


  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  List<BarChartGroupData> _buildChartData() {
    return widget.barGraphData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;


      double start = 0;
      double green = _toDouble(data['green']);
      double red = _toDouble(data['red']);
      double orange = _toDouble(data['orange']);
      double white = _toDouble(data['white']);
      double others = _toDouble(data['na']);
      double total = green + red + orange + white;

      return BarChartGroupData(
        x: index,
        //showingTooltipIndicators: [0],
        barRods: [
          BarChartRodData(
            toY: green + red + orange + white + others,
            width: 24,
            borderRadius: BorderRadius.circular(6),

            ///  STACKED SECTIONS
            rodStackItems: [
              /// GREEN
              BarChartRodStackItem(
                start,
                start += green,
                Colors.green.shade400,
              ),

              /// RED
              BarChartRodStackItem(
                start,
                start += red,
                Colors.red.shade400,
              ),

              /// ORANGE
              BarChartRodStackItem(
                start,
                start += orange,
                Colors.orange.shade400,
              ),

              /// WHITE (use light grey for visibility)
              BarChartRodStackItem(
                start,
                start += white,
                Colors.grey.shade300,
              ),

              BarChartRodStackItem(
                start,
                start += others,
                Colors.grey.shade600,
              ),
            ],
          ),
        ],
      );
    }).toList();
  }
}
