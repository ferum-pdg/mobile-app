import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncService {
  final Dio _dio = Dio();
  final String baseUrl = "http://127.0.0.1:8080";

  Future<bool> sync() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      final response = await _dio.post(
        "$baseUrl/sync",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print("Sync failed: $e");
    }
    return false;
  }
}
