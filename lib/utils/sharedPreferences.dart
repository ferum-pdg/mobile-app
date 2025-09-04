import 'package:shared_preferences/shared_preferences.dart';

Future<void> defaultSharedPreferences(SharedPreferences prefs) async {
  await prefs.setString('username', 'Alex');
  await prefs.setInt('age', 25);
  await prefs.setDouble('height', 180);
  await prefs.setDouble('weight', 70);
  await prefs.setBool('hasTrainingPlan', false);
  await prefs.setString('BackendURL', 'http://83.228.200.235');
  await prefs.setBool('isAuthentified', false);
}
