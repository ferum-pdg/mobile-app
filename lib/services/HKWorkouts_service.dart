import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service responsible for sending workouts to the backend.
class HKWorkoutService {
  final Dio _dio = Dio();

  /// Sends a workout to the backend API.
  /// 
  /// Returns :
  /// - true if the request was successful, 
  /// - otherwise returns false.
  /// 
  /// Throws Exception if:
  /// - BackendURL is missing,
  /// - JWT token is missing,
  /// - API returns an unexpected error.
  Future<bool> sendWorkout(Map<String, dynamic> workout) async {
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

      final response = await _dio.post(
        "$baseUrl/workouts",
        data: workout,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          // Allow Dio to return 4xx errors instead of throwing.
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Workout submission error: $e");      
    }
  }  
}
