import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/goal_model.dart';

class GoalService {
  final Dio _dio = Dio();
  final String baseUrl = "http://localhost:8080";
  SharedPreferences? prefs;

  /// Fetches all goals for a given sport from the API.
  Future<GoalsList?> getGoalsBySport(String sport) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null){
        throw Exception("No token found. Please log in again.");
      }

      final response = await _dio.get(
        "$baseUrl/goals/$sport",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          // Allow Dio to return 4xx errors instead of throwing.
          validateStatus: (status) => status != null && status < 500,
        )
      );

      if (response.statusCode == 200) {
        return GoalsList.fromJson(response.data);
      } else if (response.statusCode == 404) {
        return null; // No goals found for this sport
      } else {
        throw Exception("Error while fetching goals: ${response.data}");
      }
    } on DioException catch (e) {
      final message = e.response?.data['details'] ?? "Unable to fetch goals. Please try again.";
      throw Exception(message);
    } catch (e) {
      throw Exception("Goal retrieval failed: $e");
    }
  }
}
