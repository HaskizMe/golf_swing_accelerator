import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import '../../../theme/app_colors.dart';

class SwingGraph extends StatefulWidget {
  final SwingData swing;
  const SwingGraph({super.key, required this.swing});
  @override
  State<SwingGraph> createState() => _SwingGraphState();
}

class _SwingGraphState extends State<SwingGraph> {

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
                spots: widget.swing.swingPoints
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
                  interval: 10, // Set the interval for x-axis labels
                  getTitlesWidget: (value, meta) {
                    return Text(
                      "${value.toInt()} G's", // Display the value as an integer
                      style: const TextStyle(color: Colors.black),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: widget.swing.swingPoints.length / 6, // Set the interval for x-axis labels
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(), // Display the value as an integer
                      style: const TextStyle(color: Colors.black),
                    );
                  },
                ),
              ),
            ),
            maxY: 40,
            minY: -20,
          ),
        ),
      ),
    );
  }
}