import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncService {
  final Dio _dio = Dio();
  Future<bool> sync() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final String? baseUrl = prefs.getString("BackendURL");
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("BackendURL not set in SharedPreferences.");
      }
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
