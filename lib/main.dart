import 'package:ferum/pages/home.dart';
import 'package:ferum/pages/welcome_screen.dart';
import 'package:ferum/pages/workoutDetailPage.dart';
import 'package:flutter/material.dart';
import 'models/sharedPreferences.dart';

import './widgets/bottomNav.dart';
import './pages/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ferum',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: WelcomeScreen(),
    );
  }
}
