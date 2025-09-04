import 'package:flutter/material.dart';

// Pill-shaped badge used to label a workout (e.g., RUNNING, CYCLING) with a color theme
class TagBadge extends StatelessWidget {
  final String text;
  final Color color;
  const TagBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        // Light background tint derived from the main color
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        // Semi-transparent border to make the badge stand out
        border: Border.all(color: color.withOpacity(0.55)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
