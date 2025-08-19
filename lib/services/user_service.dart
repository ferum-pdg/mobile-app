import 'dart:convert';
import 'package:ferum/services/auth_service.dart';

import '../models/user_model.dart';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Dio _dio = Dio();
  final String baseUrl = "http://localhost:8080";
  SharedPreferences? prefs;

  Future<void> getUser() async {
    try {
      SharedPreferences p = await SharedPreferences.getInstance();
      final response = await _dio.get(
        "$baseUrl/auth/me",
        data: {"Authorization": AuthService().getToken()}
      );

      if (response.statusCode == 200) {
        String user = response.data;
        //await saveToken(token);
        //return User(id: , name: name, email: email, imagePath: imagePath);
      }
    } catch (e) {
      print("Login failed: $e");
    }
    //return false;
  }
}