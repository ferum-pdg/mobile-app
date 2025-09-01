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
        throw Exception("Pas de token trouvé. Connectez-vous à nouveau.");        
      }

      final response = await _dio.get(
        "$baseUrl/goals/$sport",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          validateStatus: (status) => status! < 500,
        )
      );

      if (response.statusCode == 200) {        
        return GoalsList.fromJson(response.data);
      } 

      return null;      
    } catch (e) {
      throw Exception("Goal retrieved failed: $e");
    }
  }
}
