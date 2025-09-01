import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  startDegreeOffset: -90,
                  sections: [
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
                  Text(
                    "$current / $total",
                    style: GoogleFonts.volkhov(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    title,
                    style: GoogleFonts.volkhov(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
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