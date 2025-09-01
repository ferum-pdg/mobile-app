import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ferum/models/workout_model.dart';

class WorkoutService {
  final Dio _dio = Dio();
  final String baseUrl = "http://127.0.0.1:8080";

  Future<WorkoutClass> fetchWorkoutById({required String id}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("jwt_token");

      if (token == null) {
        throw Exception("Token manquant, utilisateur non connecté");
      }

      final response = await _dio.get(
        "$baseUrl/workouts/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          "HTTP ${response.statusCode}: impossible de récupérer les workouts",
        );
      }

      final data = response.data;
      print(data);

      if (data is Map<String, dynamic>) {
        return WorkoutClass.fromJson(data);
      } else {
        throw Exception("Format de réponse inattendu: ${data.runtimeType}");
      }
    } catch (e) {
      print("❌ Erreur récupération workouts light: $e");
      rethrow;
    }
  }
}
