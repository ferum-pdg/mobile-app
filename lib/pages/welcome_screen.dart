import 'package:flutter/material.dart';

import '../widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 8,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 90,
                  horizontal: 40
                ),
                child: Center(
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Bienvenue !\n',
                              style: TextStyle(
                                fontSize: 45.0,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 79, 54, 240),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/img/f.png',
                        width: 100,
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Expanded(
                      child: WelcomeButton(buttonText: 'Sign in',),
                    ),
                    Expanded(
                      child: WelcomeButton(buttonText: 'Sign up',)
                    )
                  ],
                ),
              )
            )
          ]
        ),
      )
    );
  }
}