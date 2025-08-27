import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/goal_model.dart';

class TrainingPlanService {
  final Dio _dio = Dio();
  final String baseUrl = "http://localhost:8080";
  SharedPreferences? prefs;

  Future<Map<String, dynamic>> _buildTrainingPlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Gets end date.
    final String? endDate = prefs.getString('endDate');

    // Gets days of the week.
    final List<String> daysOfWeek = prefs.getStringList('selectedDays') ?? [];

    // Gets goals
    final List<String> goals = [];
    
    final String? selectedRunningGoal = prefs.getString('selectedRunningGoal');
    final String? selectedSwimmingGoal = prefs.getString('selectedSwimmingGoal');
    final String? selectedCyclingGoal = prefs.getString('selectedCyclingGoal');

    if (selectedRunningGoal != null){
      goals.add(selectedRunningGoal);
    }

    if (selectedSwimmingGoal != null){
      goals.add(selectedSwimmingGoal);
    }

    if (selectedCyclingGoal != null){
      goals.add(selectedCyclingGoal);
    }

    return {
      "endDate": endDate,
      "daysOfWeek": daysOfWeek,
      "goals": goals
    };
  }

  Future<void> createTrainingPlan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null){
        print("Pas de token trouvé");
        return null;
      }

      final trainingPlanInfo = await _buildTrainingPlan();
      
      final response = await _dio.post(
        "$baseUrl/training-plan",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          }
        ),        
        data: trainingPlanInfo,
      );

      print(response.data);

    } catch (e) {
      print("User storage failed: $e");
    }
  }
}
