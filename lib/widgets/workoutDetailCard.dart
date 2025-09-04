import 'package:flutter/material.dart';
import 'tagBadge.dart';

// A row block for a workout "step": number bubble + main content + optional side badges and repetition counter
class StepBlock extends StatelessWidget {
  final int number;
  final List<Widget> children;
  final List<SideBadge>? sideBadges;
  final int nbRepetition;

  const StepBlock({
    required this.number,
    required this.children,
    this.sideBadges,
    required this.nbRepetition,
  });

  @override
  Widget build(BuildContext context) {
    // Card-like container with subtle border and rounded corners
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 12),

          // Leading step index (1, 2, 3, ...)
          CircleNumber(number: number),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
          // Optional vertical stack of side badges (e.g., intensity, notes)
          if (sideBadges != null && sideBadges!.isNotEmpty) ...[
            const SizedBox(width: 12),
            Align(
              alignment: Alignment.center,
              child: Column(children: sideBadges!),
            ),
          ],
          // Show repetition count on the right when this step repeats (e.g., 3x)
          if (nbRepetition > 1) ...[
            SizedBox(width: 10),
            Align(
              alignment: Alignment.center,
              child: SideBadge(text: '${nbRepetition}x', color: Colors.purple),
            ),
          ],
        ],
      ),
    );
  }
}

// Top-level card header used to title a workout section with a colored tag
class workoutDetailCard extends StatelessWidget {
  final String title;
  final String tag;
  final Color tagColor;
  final bool transparentBorder;
  const workoutDetailCard({
    required this.title,
    required this.tag,
    required this.tagColor,
    this.transparentBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        // Elevation only when a border is visible; keep it flat when `transparentBorder` is true
        boxShadow: [
          if (!transparentBorder)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
        ],
        // Toggle between transparent and subtle gray border
        border: transparentBorder
            ? Border.all(color: Colors.transparent)
            : Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          TagBadge(text: tag, color: tagColor),
        ],
      ),
    );
  }
}

// Filled circular badge for the step index
class CircleNumber extends StatelessWidget {
  final int number;
  const CircleNumber({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Small circular badge placed on the right: shows either text or an icon
class SideBadge extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color color;
  const SideBadge({this.text, this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    // Compact, pill-like circle; text variant used for counts (e.g., "3x"), icon variant for symbols
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: text != null
          ? Text(
              text!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            )
          : Icon(icon, color: Colors.white, size: 18),
    );
  }
}
