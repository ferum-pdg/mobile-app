import 'dart:async';
import 'dart:convert';

import '../models/user_model.dart';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Dio _dio = Dio();
  final String baseUrl = "http://localhost:8080";
  SharedPreferences? prefs;

  Future<User?> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null){
        throw Exception("Pas de token trouvé");
      }

      final response = await _dio.get(
        "$baseUrl/auth/me",
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          }
        )
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await prefs.setString('user', jsonEncode(user.toJson()));     
        return user;   
      }

      return null;
    } catch (e) {
      throw Exception("User storage failed: $e");
    }
  }

  Future<void> setUser(User user) async {
     try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null){
        print("Pas de token trouvé");
        return;
      }

      final response = await _dio.put(
        "$baseUrl/auth/me",
        data: {user.toJson()},
      );

      if (response.statusCode == 200) {
        // Save the new user with the updated information.
        final newUser = User.fromJson(user.toJson());
        await prefs.setString('user', jsonEncode(newUser.toJson()));  
      }

    } catch (e) {
      print("User storage failed: $e");
    }    
  }
}