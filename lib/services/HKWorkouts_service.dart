import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HKWorkoutService {
  final Dio _dio = Dio();

  Future<bool> sendWorkout(Map<String, dynamic> workout) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("jwt_token");
      final String? baseUrl = prefs.getString("BackendURL");
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("BackendURL not set in SharedPreferences.");
      }

      if (token == null) {
        throw Exception("Token manquant, utilisateur non connecté");
      }

      final response = await _dio.post(
        "$baseUrl/workouts",
        data: workout, // ton JSON
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Erreur envoi workout: $e");
      return false;
    }
  }
}
