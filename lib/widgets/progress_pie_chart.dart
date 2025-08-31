import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
                  centerSpaceRadius: 45, // pour faire l’anneau fin
                  sectionsSpace: 0,
                  startDegreeOffset: -90, // pour commencer en haut
                  sections: [
                    // Partie remplie (progression)
                    PieChartSectionData(
                      value: current.toDouble(),
                      color: null, // on met null car on va utiliser gradient
                      radius: 16,
                      showTitle: false,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D47A1), Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    // Partie restante
                    PieChartSectionData(
                      value: (total - current).toDouble(),
                      color: Colors.grey.shade300,
                      radius: 16,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              // Texte centré
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$current / $total",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}