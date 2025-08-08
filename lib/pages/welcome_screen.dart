import 'package:ferum/pages/signin_screen.dart';
import 'package:ferum/pages/signup_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 8,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 250,
                  horizontal: 40
                ),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/img/ferum-full.png',
                        width: 300,
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
                      child: WelcomeButton(
                        buttonText: 'Sign in',
                        onTap: SignInScreen(),
                        colors: [Colors.transparent],
                        textColor: Colors.black
                      ),
                    ),
                    Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign up',
                        onTap: SignUpScreen(),
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                        textColor: Colors.white
                      )
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