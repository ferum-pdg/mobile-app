import 'package:flutter/material.dart';

import 'dart:math';

// Circular progress bar with gradient foreground and numeric label (supports hh:mm formatting)
class circularPogressBar extends StatelessWidget {
  final double totalDone;
  final double total;
  final String label;
  final double size;
  final bool toInt;
  final bool isHours;

  const circularPogressBar({
    super.key,
    required this.totalDone,
    required this.total,
    this.label = "",
    this.size = 120.0,
    this.toInt = false,
    this.isHours = false,
  });

  // Format a fractional hour value into `HhMM` or `MMmin` (e.g., 1.5 -> 1h30)
  String _formatHHMM(double valueHours) {
    final totalMinutes = (valueHours * 60).round();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0) {
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${minutes}min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // Keep the widget as small as needed (avoid taking full vertical space)
      children: [
        Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            // Transparent stroke preserves consistent layout when embedded alongside other circular widgets
            border: Border.all(color: Colors.transparent, width: 2.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _GradientCircularProgressPainter(
                  // Expected range: 0..1 (no clamping here) — ensure `total > 0` upstream
                  progress: totalDone / total,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade900, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // Neutral background ring for the "remaining" portion
                  backgroundColor: Colors.grey.shade400,
                  stroke: 10.0,
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      // Choose between hh:mm display, integer-only, or raw doubles
                      isHours
                          ? '${_formatHHMM(totalDone)} / ${_formatHHMM(total)}'
                          : (toInt
                                ? '${totalDone.toStringAsFixed(0)} / ${total.toStringAsFixed(0)}'
                                : '$totalDone / $total'),
                      style: TextStyle(
                        fontSize: isHours ? 12 : (toInt ? 14 : 12),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 6), // espace entre la barre et le texte
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }
}

// Custom painter that draws a full background arc and a rounded-caps gradient arc for progress
class _GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final Gradient gradient;
  final Color backgroundColor; // New parameter for background color
  final double? stroke;

  _GradientCircularProgressPainter({
    required this.progress,
    required this.gradient,
    required this.backgroundColor,
    this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = stroke ?? size.width / 10;
    final radius = (size.width / 2) - strokeWidth / 2;
    // Start at 12 o'clock so progress grows clockwise from the top
    const startAngle = -pi / 2;
    const fullSweepAngle = 2 * pi;
    final progressSweepAngle = 2 * pi * progress;

    final backgroundPaint = Paint()
      ..color =
          backgroundColor // Set the background color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final gradientPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw the remaining segment in the background color
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + progressSweepAngle,
      fullSweepAngle - progressSweepAngle,
      false,
      backgroundPaint,
    );

    // Draw the completed segment with a gradient and rounded stroke caps
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progressSweepAngle,
      false,
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Always repaint to reflect progress changes (inputs are not compared)
    return true;
  }
}
