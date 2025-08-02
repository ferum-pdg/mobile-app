import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center( // Centre le contenu verticalement et horizontalement
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [          
            Text(
              'Bienvenue !',
              style: TextStyle(
                fontSize: 45.0,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 79, 54, 240),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8), // petit espace entre texte et image
            Image.asset(
              'assets/img/ferum-full.png',
              width: 200,
              height: 50,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}