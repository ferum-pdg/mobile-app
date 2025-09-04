import 'package:flutter/material.dart';

// Reusable elevated button with full width and custom black/white theme
class ElevButton extends StatelessWidget {
  final String title;

  const ElevButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Force the button to expand to full available width
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          // Rounded 8px corners for consistent look
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(title),
      ),
    );
  }
}
