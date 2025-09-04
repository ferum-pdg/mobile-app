import 'package:flutter/material.dart';

// Small square card showing a title (and optional subtitle), with optional gradient background
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double size;
  final double fontSize;
  final bool useGradient;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.size = 55,
    this.fontSize = 11,
    this.useGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // When useGradient = true, apply a blue→purple gradient; otherwise transparent background
        gradient: useGradient
            ? LinearGradient(
                colors: [Colors.blue.shade900, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: useGradient ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        // Only draw a light border when no gradient is used
        border: useGradient ? null : Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              // Switch text color for readability on gradient vs. plain background
              color: useGradient ? Colors.white : Colors.black,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: const TextStyle(color: Colors.grey)),
          ],
        ],
      ),
    );
  }
}
