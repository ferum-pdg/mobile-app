import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ferum/models/goal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/training_plan_model.dart';

class TrainingPlanService {
  final Dio _dio = Dio();
  SharedPreferences? prefs;
  String? baseUrl;

  /// Builds the request payload for training plan creation.
  Future<Map<String, dynamic>> _buildTrainingPlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve end date.
    final String? endDate = prefs.getString('endDate');

    // Retrieve selected days of the week.
    final List<String> daysOfWeek = prefs.getStringList('selectedDays') ?? [];

    // Retrieve selected goals.
    final List<String> goals = [];

    final String? selectedRunningGoalString = prefs.getString(
      'selectedRunningGoal',
    );
    final String? selectedSwimmingGoalString = prefs.getString(
      'selectedSwimmingGoal',
    );
    final String? selectedCyclingGoalString = prefs.getString(
      'selectedCyclingGoal',
    );

    if (selectedRunningGoalString != null) {
      final selectedRunningGoal = Goal.fromJson(
        jsonDecode(selectedRunningGoalString),
      );
      goals.add(selectedRunningGoal.id);
    }

    if (selectedSwimmingGoalString != null) {
      final selectedSwimmingGoal = Goal.fromJson(
        jsonDecode(selectedSwimmingGoalString),
      );
      goals.add(selectedSwimmingGoal.id);
    }

    if (selectedCyclingGoalString != null) {
      final selectedCyclingGoal = Goal.fromJson(
        jsonDecode(selectedCyclingGoalString),
      );
      goals.add(selectedCyclingGoal.id);
    }

    return {"endDate": endDate, "daysOfWeek": daysOfWeek, "goals": goals};
  }

  /// Fetches the current training plan from the API.
  Future<TrainingPlan?> getTrainingPlan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      baseUrl = prefs.getString("BackendURL");
      if (baseUrl == null || baseUrl!.isEmpty) {
        throw Exception("BackendURL not set in SharedPreferences.");
      }

      if (token == null) {
        throw Exception("No token found. Please log in again.");
      }

      final response = await _dio.get(
        "$baseUrl/training-plan",
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          // Allow Dio to return 4xx errors instead of throwing.
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        // Handle empty body (no plan available).
        if (response.data == null || response.data.toString().isEmpty) {
          return null;
        }
        final trainingPlan = TrainingPlan.fromJson(jsonDecode(response.data));
        await prefs.setString(
          'trainingPlan',
          jsonEncode(trainingPlan.toJson()),
        );
        print(response.data);
        return trainingPlan;
      } else if (response.statusCode == 404) {
        // No training plan exists yet.
        return null;
      } else {
        throw Exception("Error while fetching training plan: ${response.data}");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['details'] ??
          "Unable to fetch training plan. Please try again.";
      throw Exception(message);
    } catch (e) {
      throw Exception("Training plan fetch failed: $e");
    }
  }

  /// Creates a new training plan and returns it.
  Future<TrainingPlan?> createTrainingPlan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      baseUrl = prefs.getString("BackendURL");
      if (baseUrl == null || baseUrl!.isEmpty) {
        throw Exception("BackendURL not set in SharedPreferences.");
      }

      if (token == null) {
        throw Exception("No token found. Please log in again.");
      }

      final trainingPlanInfo = await _buildTrainingPlan();

      final response = await _dio.post(
        "$baseUrl/training-plan",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          // Allow Dio to return 4xx errors instead of throwing.
          validateStatus: (status) => status != null && status < 500,
        ),
        data: trainingPlanInfo,
      );

      if (response.statusCode == 201) {
        final trainingPlan = await getTrainingPlan();
        return trainingPlan;
      } else {
        throw Exception("Error while creating training plan: ${response.data}");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['details'] ??
          "Unable to create training plan. Please try again.";
      throw Exception(message);
    } catch (e) {
      throw Exception("Training plan creation failed: $e");
    }
  }
}
