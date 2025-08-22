import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HKWorkoutService {
  final Dio _dio = Dio();
  final String baseUrl = "http://127.0.0.1:8080";

  Future<bool> sendWorkout(Map<String, dynamic> workout) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("jwt_token");

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
