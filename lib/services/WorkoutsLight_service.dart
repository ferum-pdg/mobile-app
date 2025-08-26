import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ferum/models/workoutLight_model.dart';

class WorkoutLightService {
  final Dio _dio = Dio();
  final String baseUrl = "http://127.0.0.1:8080";

  Future<List<WorkoutLightClass>> fetchWorkoutsLight() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("jwt_token");

      if (token == null) {
        throw Exception("Token manquant, utilisateur non connecté");
      }

      final response = await _dio.get(
        "$baseUrl/workouts/",
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

      if (data is List) {
        // data attendu: List<Map<String, dynamic>>
        return WorkoutLightClass.fromJsonList(
          data.map((e) => e as Map<String, dynamic>).toList(),
        );
      } else if (data is Map<String, dynamic> && data['items'] is List) {
        // fallback si l'API renvoie un wrapper { items: [...] }
        final items = (data['items'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        return WorkoutLightClass.fromJsonList(items);
      } else {
        throw Exception("Format de réponse inattendu: ${data.runtimeType}");
      }
    } catch (e) {
      print("❌ Erreur récupération workouts light: $e");
      rethrow;
    }
  }
}
