import 'package:ferum/models/user_model.dart';
import 'package:ferum/pages/welcome_screen.dart';
import 'package:ferum/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/sharedPreferences.dart';

import './widgets/bottomNav.dart';

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
      await defaultSharedPreferences(p);
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
      home: FutureBuilder<_BootstrapResult>(
        future: bootstrap(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const WelcomeScreen();
          }
          final res = snapshot.data!;
          if (!res.isAuthentified || res.user == null) {
            return const WelcomeScreen();
          }
          return BottomNav(user: res.user);
        },
      ),
    );
  }
}

class _BootstrapResult {
  final SharedPreferences prefs;
  final bool isAuthentified;
  final User? user;
  _BootstrapResult(this.prefs, this.isAuthentified, this.user);
}

Future<_BootstrapResult> bootstrap() async {
  final prefs = await SharedPreferences.getInstance();
  final isAuthentified = prefs.getBool('isAuthentified') ?? false;
  User? user;
  if (isAuthentified) {
    try {
      user = await UserService().getUser();
    } catch (_) {
      // Si la récupération du user échoue (ex: 401), on renvoie WelcomeScreen
      return _BootstrapResult(prefs, false, null);
    }
  }
  return _BootstrapResult(prefs, isAuthentified, user);
}
