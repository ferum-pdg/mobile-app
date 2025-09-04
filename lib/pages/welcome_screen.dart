import 'package:ferum/pages/signin_screen.dart';
import 'package:ferum/pages/signup_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/welcome_button.dart';

// Initial landing screen: shows app logo and buttons to sign in or sign up
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
                padding: EdgeInsets.symmetric(vertical: 250, horizontal: 40),
                child: Center(
                  child: Column(
                    children: [
                      // App logo (centered)
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
                // Bottom row with two navigation buttons
                child: Row(
                  children: [
                    Expanded(
                      // Navigate to Sign In screen
                      child: WelcomeButton(
                        buttonText: 'Sign in',
                        onTap: SignInScreen(),
                        colors: [Colors.transparent],
                        textColor: Colors.black,
                      ),
                    ),
                    Expanded(
                      // Navigate to Sign Up screen
                      child: WelcomeButton(
                        buttonText: 'Sign up',
                        onTap: SignUpScreen(),
                        colors: [Color(0xFF0D47A1), Colors.purple],
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
