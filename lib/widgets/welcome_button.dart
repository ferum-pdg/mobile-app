import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({super.key, this.buttonText});
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50)
          )
        ),
        child: Text(
          buttonText!,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}