import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/training_plan_model.dart';

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

  Future<TrainingPlan?> getTrainingPlan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null){
        print("Pas de token trouvé");
        return null;
      }

      final response = await _dio.get(
        "$baseUrl/training-plan",
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          }
        )
      );

      if (response.statusCode == 200) {
        final trainingPlan = TrainingPlan.fromJson(response.data);
        await prefs.setString('trainingPlan', jsonEncode(trainingPlan.toJson()));     
        return trainingPlan;
      }

      return null;
    } catch (e) {
      print("TrainingPlan storage failed: $e");
    }
  }

  Future<TrainingPlan?> createTrainingPlan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null){
        print("No token found.");
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

      if(response.statusCode == 201){
        final trainingPlan = await getTrainingPlan();        
        return trainingPlan;
      }
      

    } catch (e) {
      print("Training plan creation failed: $e");
    }
  }
}
