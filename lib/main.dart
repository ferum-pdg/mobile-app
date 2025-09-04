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

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static Future<void> initPrefs() async {
    // Initialize default preferences on first launch
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
      // Wait for bootstrap to finish before showing the correct screen
      home: FutureBuilder<_BootstrapResult>(
        future: bootstrap(),
        builder: (context, snapshot) {
          // Show a loading spinner while waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // Show WelcomeScreen if bootstrap failed
          if (snapshot.hasError || !snapshot.hasData) {
            return const WelcomeScreen();
          }
          final res = snapshot.data!;
          // Redirect to WelcomeScreen if user is not authenticated
          if (!res.isAuthentified || res.user == null) {
            return const WelcomeScreen();
          }
          // Otherwise, show the main app with bottom navigation
          return BottomNav(user: res.user);
        },
      ),
    );
  }
}

// Helper class to hold bootstrap results
class _BootstrapResult {
  final SharedPreferences prefs;
  final bool isAuthentified;
  final User? user;
  _BootstrapResult(this.prefs, this.isAuthentified, this.user);
}

// Bootstrap logic: check authentication and fetch user
Future<_BootstrapResult> bootstrap() async {
  final prefs = await SharedPreferences.getInstance();
  final isAuthentified = prefs.getBool('isAuthentified') ?? false;
  User? user;
  if (isAuthentified) {
    // Try to fetch user data if authenticated
    try {
      user = await UserService().getUser();
    } catch (_) {
      // If fetching the user fails (e.g. 401), return WelcomeScreen
      return _BootstrapResult(prefs, false, null);
    }
  }
  return _BootstrapResult(prefs, isAuthentified, user);
}
