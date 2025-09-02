import 'dart:async';
import 'dart:convert';

import '../models/user_model.dart';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Dio _dio = Dio();

  SharedPreferences? prefs;
  String? baseUrl;

  // Fetches the currently authenticated user from the API.
  Future<User?> getUser() async {
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
        final user = User.fromJson(response.data);
        await prefs.setString('user', jsonEncode(user.toJson()));
        return user;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized. Please log in again.");
      } else {
        throw Exception("Error while fetching user: ${response.data}");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['details'] ??
          "Unable to fetch user. Please try again.";
      throw Exception(message);
    } catch (e) {
      throw Exception("User fetch failed: $e");
    }
  }

  /// Updates the user profile on the API and stores it locally.
  Future<void> setUser(User user) async {
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

      final response = await _dio.put(
        "$baseUrl/auth/me",
        data: user.toJson(),
        options: Options(
          headers: {"Content-Type": "application/json"},
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
          "Unable to update user. Please try again.";
      throw Exception(message);
    } catch (e) {
      throw Exception("User update failed: $e");
    }
  }
}
