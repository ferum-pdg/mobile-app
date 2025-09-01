import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final List<Color> gradientColors;

  const GoalHeader({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.gradientColors
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(
              icon,
              size: 36,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.volkhov(
              fontSize: 18,
              color: Colors.white70,
              letterSpacing: 1.2,
            ),            
          ),
          const SizedBox(height: 4),
          Text(
            subTitle,
            style: GoogleFonts.volkhov(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),                
          ),
          const SizedBox(height: 8),
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}