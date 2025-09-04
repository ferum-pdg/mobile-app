import 'package:flutter/material.dart';

// Gradient card summarizing the daily plan: shows day, sport, and an icon
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
        // Blue→purple gradient background
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        // Subtle shadow for elevation
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
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          sport,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)),
        ),
        // Sport-specific icon on the right
        trailing: Icon(_getSportIcon(sport), color: Colors.white, size: 28),
      ),
    );
  }

  // Map sport name (string) to a Material icon. fallback is a generic icon
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
