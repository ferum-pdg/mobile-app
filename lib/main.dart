import 'package:ferum/pages/home.dart';
import 'package:ferum/pages/welcome_screen.dart';
import 'package:ferum/pages/workoutDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/sharedPreferences.dart';

import './widgets/bottomNav.dart';
import './pages/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyApp.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static Future<void> initPrefs() async {
    SharedPreferences p = await SharedPreferences.getInstance();

    bool isFirstLaunch = p.getBool('isFirstLaunch') ?? true;
    if (isFirstLaunch) {
      defaultSharedPreferences(p);
      await p.setBool('isFirstLaunch', false);
    }
  }

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
