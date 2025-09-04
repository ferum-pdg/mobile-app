import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ferum/models/workout_model.dart';

/// Service responsible for fetching workout data from the backend.
class WorkoutService {
  final Dio _dio = Dio();

  /// Fetch a workout by its id.
  /// 
  /// Returns:
  /// - A WorkoutClass object if available,
  /// 
  /// Throws Exception if:
  /// - BackendURL is missing,
  /// - JWT token is missing,
  /// - The HTTP request fails or returns an unexpected format.
  Future<WorkoutClass> fetchWorkoutById({required String id}) async {
    try {
      // Retrieve shared preferences (persistent storage on device).
      final prefs = await SharedPreferences.getInstance();

      // Get token and backend URL from preferences.
      String? token = prefs.getString("jwt_token");
      final String? baseUrl = prefs.getString("BackendURL");

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("BackendURL not set in SharedPreferences.");
      }

      if (token == null) {
        throw Exception("No token found. Please log in again.");
      }

      final response = await _dio.get(
        "$baseUrl/workouts/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          // Allow Dio to return 4xx errors instead of throwing.
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          "HTTP ${response.statusCode}: Failed to fetch workouts.",
        );
      }

      final data = response.data;

      // Validate response format.
      if (data is Map<String, dynamic>) {
        return WorkoutClass.fromJson(data);
      } else {
        throw Exception("Unexpected response format: ${data.runtimeType}");
      }
    } catch (e) {
      throw Exception("Error while fetching workout: $e");      
    }
  }
}
