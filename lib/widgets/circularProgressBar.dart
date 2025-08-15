import 'package:flutter/material.dart';

import 'dart:math';

class circularPogressBar extends StatelessWidget {
  final double totalDone;
  final double total;
  final String label;
  final double size;
  final bool toInt;

  const circularPogressBar({
    super.key,
    required this.totalDone,
    required this.total,
    this.label = "",
    this.size = 100.0,
    this.toInt = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize
          .min, // pour que la colonne prenne juste la place nécessaire
      children: [
        Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.transparent, width: 2.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _GradientCircularProgressPainter(
                  progress: totalDone / total,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade900, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  backgroundColor: Colors.grey.shade400,
                  stroke: 10.0,
                ),
                child: Center(
                  child: Text(
                    toInt
                        ? '${totalDone.toStringAsFixed(0)} / ${total.toStringAsFixed(0)}'
                        : '$totalDone / $total',
                    style: TextStyle(
                      fontSize: toInt ? 14 : 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
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
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }
}

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

    // Draw the background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + progressSweepAngle,
      fullSweepAngle - progressSweepAngle,
      false,
      backgroundPaint,
    );

    // Draw the gradient arc
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
    return true;
  }
}
