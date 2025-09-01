import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyPlanCard extends StatelessWidget {
  final String dayOfWeek;
  final String sport;

  const DailyPlanCard({
    super.key,
    required this.dayOfWeek,
    required this.sport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          dayOfWeek,
          style: GoogleFonts.volkhov(
            fontSize: 18,
            color:Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),                    
        ),
        subtitle: Text(
          sport,
          style: GoogleFonts.volkhov(
            fontSize: 14,
            color:Colors.white.withOpacity(0.9),
            letterSpacing: 1.2,
          ),          
        ),
        trailing: Icon(
          _getSportIcon(sport),
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  IconData _getSportIcon(String sport) {
    switch (sport.toUpperCase()) {
      case "RUNNING":
        return Icons.directions_run;
      case "CYCLING":
        return Icons.directions_bike;
      case "SWIMMING":
        return Icons.pool;
      default:
        return Icons.single_bed;
    }
  }
}