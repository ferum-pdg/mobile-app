import 'package:flutter/material.dart';

// Header widget with gradient background, icon, title and subtitle — used for goal sections
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
    required this.gradientColors,
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
        // Rounded bottom corners to visually separate the header from the rest of the screen
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular icon container with translucent white background
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(icon, size: 36, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 18, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // Decorative underline bar below the texts
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
