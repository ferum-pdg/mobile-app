import 'dart:async';
import 'dart:convert';
import 'package:ferum/services/auth_service.dart';

import '../models/user_model.dart';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Dio _dio = Dio();
  final String baseUrl = "http://localhost:8080";
  SharedPreferences? prefs;

  Future<void> saveUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await _dio.get(
        "$baseUrl/auth/me",
        options: Options(
          headers: {
            "Authorization": "Bearer ${await AuthService().getToken()}"
          }
        )
      );

      if (response.statusCode == 200) {      
        await prefs.setString('user', jsonEncode(response.data));
      }
    } catch (e) {
      print("User storage failed: $e");
    }
  }
}