import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../configs/color/color.dart';

class GradeBookStatsChart extends StatefulWidget {
  final List<dynamic> gradeBarGraphData;

  const GradeBookStatsChart({
    super.key,
    required this.gradeBarGraphData,
  });

  @override
  State<GradeBookStatsChart> createState() =>
      _GradeBookStatsChartState();
}

class _GradeBookStatsChartState
    extends State<GradeBookStatsChart> {

  int getTotalBooksIssued() {
    return widget.gradeBarGraphData.fold<int>(
      0,
          (sum, item) =>
      sum + _toDouble(item['total_books']).toInt(),
    );
  }

  double getMaxY() {
    if (widget.gradeBarGraphData.isEmpty) return 10;

    final max = widget.gradeBarGraphData
        .map((e) => _toDouble(e['total_books']))
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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grade-wise Book Issued',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),

            const SizedBox(height: 20),

            widget.gradeBarGraphData.isNotEmpty
                ? SizedBox(
              height: 230,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width:
                  widget.gradeBarGraphData.length * 60,
                  child: BarChart(
                    BarChartData(
                      alignment:
                      BarChartAlignment.spaceAround,
                      maxY: maxY,
                      barGroups: _buildChartData(),

                      borderData:
                      FlBorderData(show: false),

                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: interval,
                        drawVerticalLine: false,
                      ),

                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData:
                        BarTouchTooltipData(
                          tooltipBgColor:
                          Colors.black87,
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,

                          getTooltipItem:
                              (group, groupIndex,
                              rod, rodIndex) {
                            final data =
                            widget.gradeBarGraphData[
                            group.x.toInt()];

                            return BarTooltipItem(
                              'Grade: ${data['grade']}\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                  'Green: ${data['green']}\n',
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.green,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  'Red: ${data['red']}\n',
                                  style:
                                  const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  'Orange: ${data['orange']}\n',
                                  style:
                                  const TextStyle(
                                    color: Colors
                                        .orange,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  'White: ${data['white']}\n',
                                  style: TextStyle(
                                    color: Colors
                                        .grey.shade300,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  'Others: ${data['na']}',
                                  style: TextStyle(
                                    color: Colors
                                        .grey.shade500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      titlesData: FlTitlesData(
                        topTitles:
                        const AxisTitles(),
                        rightTitles:
                        const AxisTitles(),

                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            interval: interval,
                            getTitlesWidget:
                                (value, meta) {
                              return Text(
                                value
                                    .toInt()
                                    .toString(),
                                style:
                                const TextStyle(
                                  fontSize: 10,
                                  color:
                                  Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),

                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,

                            getTitlesWidget:
                                (value, meta) {

                              if (value.toInt() <
                                  0 ||
                                  value.toInt() >=
                                      widget
                                          .gradeBarGraphData
                                          .length) {
                                return const SizedBox
                                    .shrink();
                              }

                              final grade = widget
                                  .gradeBarGraphData[
                              value.toInt()]
                              ['grade']
                                  .toString();

                              return Padding(
                                padding:
                                const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: Text(
                                  grade,
                                  style:
                                  const TextStyle(
                                    fontSize: 10,
                                    color:
                                    Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            //const SizedBox(height: 8),

            // const Divider(),
            //
            // const SizedBox(height: 16),
            //
            // Row(
            //   mainAxisAlignment:
            //   MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text(
            //       'Total Books Issued',
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w600,
            //       ),
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

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  List<BarChartGroupData> _buildChartData() {
    return widget.gradeBarGraphData
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final data = entry.value;

      double start = 0;

      final double green =
      _toDouble(data['green']);

      final double red =
      _toDouble(data['red']);

      final double orange =
      _toDouble(data['orange']);

      final double white =
      _toDouble(data['white']);

      final double na =
      _toDouble(data['na']);

      final double total =
          green + red + orange + white + na;

      return BarChartGroupData(
        x: index,

        barRods: [
          BarChartRodData(
            toY: total,
            width: 24,
            borderRadius:
            BorderRadius.circular(6),

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

              /// WHITE
              BarChartRodStackItem(
                start,
                start += white,
                Colors.grey.shade300,
              ),

              /// NA
              BarChartRodStackItem(
                start,
                start += na,
                Colors.grey.shade600,
              ),
            ],
          ),
        ],
      );
    }).toList();
  }
}