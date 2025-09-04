import 'package:flutter/material.dart';

// Custom welcome screen button with optional solid color or gradient background
class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key,
    this.buttonText,
    this.onTap,
    this.colors,
    this.textColor,
  });

  final String? buttonText;
  final Widget? onTap;
  final List<Color>? colors;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    // Decide whether to render with a solid color or a gradient
    final hasSingleColor = colors != null && colors!.length == 1;
    final hasGradient = colors != null && colors!.length >= 2;

    // GestureDetector wraps the button to handle navigation on tap
    return GestureDetector(
      onTap: () {
        // Navigate to the widget provided in onTap
        Navigator.push(context, MaterialPageRoute(builder: (e) => onTap!));
      },
      child: Container(
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: hasSingleColor ? colors!.first : null,
          gradient: hasGradient
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colors!,
                )
              : null,
          // Rounded corner only on the top-left side
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        child: Text(
          buttonText!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: textColor!,
          ),
        ),
      ),
    );
  }
}
