import 'package:ferum/pages/signup_screen.dart';
import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key, 
    this.buttonText, 
    this.onTap, 
    this.colors,
    this.textColor
  });
  
  final String? buttonText;
  final Widget? onTap;
  final List<Color>? colors;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final hasSingleColor = colors != null && colors!.length == 1;
    final hasGradient = colors != null && colors!.length >= 2;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (e) => onTap!,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: hasSingleColor ? colors!.first : null,          
          gradient: hasGradient ? LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors!
          ) : null,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50)
          )
        ),
        child: Text(
          buttonText!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: textColor!
          ),
        )
      ),
    );
  }
}