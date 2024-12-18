import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import '../../../theme/app_colors.dart';
import 'dart:math';


class SwingGraph extends StatefulWidget {
  final SwingData swing;
  const SwingGraph({super.key, required this.swing});
  @override
  State<SwingGraph> createState() => _SwingGraphState();
}

class _SwingGraphState extends State<SwingGraph> {
  late double maxY; // Max Y value for the graph
  late double minY; // Min Y value for the graph

  @override
  void initState() {
    super.initState();
    // Calculate maxY and minY dynamically based on the 'z' data
    final zValues = widget.swing.swingPoints['z']!;
    maxY = zValues.reduce(max) + 20; // Max value + 20
    minY = zValues.reduce(min) - 20; // Min value - 20
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: LineChart(
          LineChartData(
            backgroundColor: AppColors.platinum,
            lineBarsData: [
              LineChartBarData(
                //curveSmoothness: .8,
                preventCurveOverShooting: true,
                aboveBarData: BarAreaData(
                  //show: true
                ),
                belowBarData: BarAreaData(
                    show: true
                ),
                isCurved: true,
                color: Colors.yellow,
                spots: widget.swing.swingPoints['z']!
                    .asMap()
                    .entries
                    .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                    .toList(),
              ),
            ],
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false, // Hide right axis
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false, // Hide top axis
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 60,
                  showTitles: true,
                  //interval: widget.swing.swingPoints['z']!.length / 20, // Set the interval for x-axis labels
                  getTitlesWidget: (value, meta) {
                    if (value == meta.max) {
                      return const Text('');
                    } else if (value == meta.min) {
                      return const Text('');
                    } else {
                      return Text(
                        "${value.toInt()} G's", // Display the value as an integer
                        style: const TextStyle(color: Colors.black),
                      );
                    }
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(), // Display the value as an integer
                      style: const TextStyle(color: Colors.black),
                    );
                  },
                ),
              ),
            ),
            maxY: maxY,
            minY: minY,
          ),
        ),
      ),
    );
  }
}