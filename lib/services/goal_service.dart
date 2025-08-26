import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/goal_model.dart';

class GoalService {
  final Dio _dio = Dio();
  final String baseUrl = "http://localhost:8080";
  SharedPreferences? prefs;

  Future<GoalsList?> getGoalsBySport(String sport) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null){
        print("Pas de token trouvé");
        return null;
      }

      final response = await _dio.get(
        "$baseUrl/goals/$sport",
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          }
        )
      );

      if (response.statusCode == 200) {        
        final goals = jsonDecode(response.data);           
        return GoalsList.fromJson(goals);
      }

      return null;
    } catch (e) {
      print("User storage failed: $e");
    }
  }
}
