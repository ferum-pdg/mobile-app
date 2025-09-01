import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ferum/models/goal_model.dart';
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
    
    final String? selectedRunningGoalString = prefs.getString('selectedRunningGoal');
    final String? selectedSwimmingGoalString = prefs.getString('selectedSwimmingGoal');
    final String? selectedCyclingGoalString = prefs.getString('selectedCyclingGoal');

    if (selectedRunningGoalString != null){
      final selectedRunningGoal = Goal.fromJson(jsonDecode(selectedRunningGoalString));
      goals.add(selectedRunningGoal.id);
    }

    if (selectedSwimmingGoalString != null){
      final selectedSwimmingGoal = Goal.fromJson(jsonDecode(selectedSwimmingGoalString));
      goals.add(selectedSwimmingGoal.id);
    }

    if (selectedCyclingGoalString != null){
      final selectedCyclingGoal = Goal.fromJson(jsonDecode(selectedCyclingGoalString));
      goals.add(selectedCyclingGoal.id);
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
        throw Exception("Pas de token trouvé");
      }

      final response = await _dio.get(
        "$baseUrl/training-plan",
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          validateStatus: (status) => status! < 500,          
        )
      );

      if (response.statusCode == 200) {
        if (response.data == null || response.data.toString().isEmpty) {
          return null;
        }
        final trainingPlan = TrainingPlan.fromJson(jsonDecode(response.data));
        await prefs.setString('trainingPlan', jsonEncode(trainingPlan.toJson()));    
        print(response.data);
        return trainingPlan;
      } else if (response.statusCode == 404){
        return null;
      } else {
        throw Exception("Erreur lors de la récupération du plan : ${response.data}");
      }
    } catch (e) {
      throw Exception("Training plan fetch failed: $e");
    }
  }

  Future<TrainingPlan?> createTrainingPlan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null){
        throw Exception("No token found.");      
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
      if (e is DioException){
        final response = e.response;
        final message = response?.data['details'] ?? "Impossible de créer le plan. Réessayez.";
        throw Exception(message);
      }
      throw Exception("Training plan creation failed: $e");
    }
  }
}
