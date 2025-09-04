import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

/// Service responsible for handling user-related API requests.
class UserService {
  final Dio _dio = Dio();

  SharedPreferences? prefs;
  String? baseUrl;

  /// Fetch the currently authenticated user from the backend.
  /// 
  /// Stores the user in SharedPreferences under the key "user".
  /// 
  /// Throws Exception if:
  /// - BackendURL is missing,
  /// - JWT token is missing,
  /// - API returns an unexpected error.
  Future<User?> getUser() async {
    try {
      // Retrieve shared preferences (persistent storage on device).
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get token and backend URL from preferences.
      final token = prefs.getString('jwt_token');
      baseUrl = prefs.getString("BackendURL");
      
      if (baseUrl == null || baseUrl!.isEmpty) {
        throw Exception("BackendURL not set in SharedPreferences.");
      }

      if (token == null) {
        throw Exception("No token found. Please log in again.");
      }

      final response = await _dio.get(
        "$baseUrl/auth/me",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          // Allow Dio to return 4xx errors instead of throwing.
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        // Save the current user authentificated.
        final user = User.fromJson(response.data);
        await prefs.setString('user', jsonEncode(user.toJson()));
        return user;      
      } else {
        throw Exception("Error while fetching user: ${response.data}");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['details'] ??
          "Unable to fetch user : $e. Please try again.";
      throw Exception(message);
    } catch (e) {
      throw Exception("User fetch failed: $e");
    }
  }

  /// Update the user profile on the backend and persist it locally.
  /// 
  /// Saves the updated user in SharedPreferences under the key "user".
  /// 
  /// Throws Exception if:
  /// - BackendURL is missing,
  /// - JWT token is missing,
  /// - API returns an unexpected error.
  Future<void> setUser(User user) async {
    try {
      // Retrieve shared preferences (persistent storage on device).
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get token and backend URL from preferences.
      final token = prefs.getString('jwt_token');
      baseUrl = prefs.getString("BackendURL");

      if (baseUrl == null || baseUrl!.isEmpty) {
        throw Exception("BackendURL not set in SharedPreferences.");
      }

      if (token == null) {
        throw Exception("No token found. Please log in again.");
      }

      final response = await _dio.put(
        "$baseUrl/auth/me",
        data: user.toJson(),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          // Allow Dio to return 4xx errors instead of throwing.
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        // Save the new user with the updated information.
        final newUser = User.fromJson(user.toJson());
        await prefs.setString('user', jsonEncode(newUser.toJson()));
      } else {
        throw Exception("Error while updating user: ${response.data}");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['details'] ??
          "Unable to update user : $e. Please try again.";
      throw Exception(message);
    } catch (e) {
      throw Exception("User update failed: $e");
    }
  }
}
