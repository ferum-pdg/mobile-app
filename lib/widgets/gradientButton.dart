import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final bool enabled;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.colors = const [Color(0xFF0D47A1), Colors.purple],
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.textStyle,
    this.width,
    this.height,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: begin, end: end),
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Text(
          text,
          style:
              (textStyle ??
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ))
                  // dim le texte si disabled
                  .copyWith(
                    color: (textStyle?.color ?? Colors.white).withValues(
                      alpha: enabled ? 1.0 : 0.6,
                    ),
                  ),
        ),
      ),
    );

    // Material + InkWell pour un ripple propre au-dessus du gradient
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: enabled ? onTap : null,
        child: Padding(padding: EdgeInsets.zero, child: child),
      ),
    );
  }
}
