import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service responsible for synchronizing data with the backend.
class SyncService {
  final Dio _dio = Dio();

  /// Sends a sync request to the backend.
  ///
  /// Returns:
  /// - A true if the sync was successfull
  /// - otherwise returns false.
  ///
  /// Throws Exception if:
  /// - BackendURL is missing,
  /// - JWT token is missing,
  /// - API returns an unexpected error.
  Future<bool> sync() async {
    try {
      // Retrieve shared preferences (persistent storage on device).
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get token and backend URL from preferences.
      final token = prefs.getString('jwt_token');
      final String? baseUrl = prefs.getString("BackendURL");

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("BackendURL not set in SharedPreferences.");
      }

      final response = await _dio.post(
        "$baseUrl/sync",
        options: Options(
          headers: {
            "Authorization": "Bearer $token"            
            },
            // Allow Dio to return 4xx errors instead of throwing.
            validateStatus: (status) => status != null && status < 500,
          ),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception("Sync failed: $e");
    }
    return false;
  }
}
