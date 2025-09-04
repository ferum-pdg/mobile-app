import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Circular progress pie chart with a gradient-filled portion for progress and text in the center
class ProgressPieChart extends StatelessWidget {
  final int current;
  final int total;
  final String title;

  const ProgressPieChart({
    super.key,
    required this.current,
    required this.total,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 140,
          width: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  centerSpaceRadius: 45,
                  sectionsSpace: 0,
                  // Rotate chart so progress starts from the top (12 o'clock)
                  startDegreeOffset: -90,
                  sections: [
                    // Progress portion: filled with gradient
                    PieChartSectionData(
                      value: current.toDouble(),
                      color: null,
                      radius: 16,
                      showTitle: false,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D47A1), Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    // Remaining portion: grey background
                    PieChartSectionData(
                      value: (total - current).toDouble(),
                      color: Colors.grey.shade300,
                      radius: 16,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show current progress ratio in the center
                  Text(
                    "$current / $total",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Subtitle label under the ratio
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
