import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service responsible for handling authentification API requests.
class AuthService {
  final Dio _dio = Dio();

  /// Logs in a user using email and password.
  ///
  /// Returns:
  /// - true if login succeeds,
  ///
  /// Throws Exception if:
  /// - BackendURL is missing,
  /// - Token not returned by the server.
  /// - HTTP code 401, if the credentials are wrongs,
  /// - API returns an unexpected error.
  Future<bool> login(String email, String password) async {
    try {
      // Retrieve shared preferences (persistent storage on device).
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Get backend URL from preferences.
      final String? baseUrl = prefs.getString("BackendURL");

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("BackendURL not set in SharedPreferences.");
      }

      final response = await _dio.post(
        "$baseUrl/auth/login",
        data: {"email": email, "password": password},
        options: Options(
          headers: {
            "Content-Type": "application/json"
          },
          // Allow Dio to return 4xx errors instead of throwing.
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        final token = response.data["token"];
        if (token == null || token.isEmpty) {
          throw Exception("No token received from server.");
        }
        await saveToken(token);
        return true;
      } else if (response.statusCode == 401) {
        throw Exception(
          "Invalid credentials. Please check your email and password.",
        );
      } else {
        throw Exception("Login failed: ${response.data}");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?["details"] ??
          "Unable to login : $e. Please try again later.";
      throw Exception(message);
    } catch (e) {
      throw Exception("Login request failed: $e");
    }
  }


  /// Register a new user.
  ///
  /// Returns:
  /// - true if registrations succeeds,
  ///
  /// Throws Exception if:
  /// - BackendURL is missing,
  /// - Token not returned by the server.
  /// - HTTP code 404, if the data enterred are invalid.
  /// - API returns an unexpected error.
  Future<bool> register(String email, String password, String firstName, String lastName, String phoneNumber, String birthDate, double weight, double height, int fcMax) async {
    try {
      // Retrieve shared preferences (persistent storage on device).
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get backend URL from preferences.
      final String? baseUrl = prefs.getString("BackendURL");

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("BackendURL not set in SharedPreferences.");
      }

      final response = await _dio.post(
        "$baseUrl/auth/register",
        data: {
          "email": email,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
          "phoneNumber": phoneNumber,
          "birthDate": birthDate,
          "weight": weight,
          "height": height,
          "fcMax": fcMax
        },
        options: Options(
          headers: {
            "Content-Type": "application/json"
          },
          // Allow Dio to return 4xx errors instead of throwing.
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 201) {
        final token = response.data["token"];
        if (token == null || token.isEmpty) {
          throw Exception("No token received from server.");
        }
        await saveToken(token);
        return true;
      } else if (response.statusCode == 401) {
        throw Exception(
          "Invalid data. Please check your data enterred.",
        );
      } else {
        throw Exception("Registration failed: ${response.data}");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?["details"] ??
          "Unable to Register : $e. Please try again later.";
      throw Exception(message);
    } catch (e) {
      throw Exception("Registration request failed: $e");
    }
  }

  /// Saves the JWT token securely in SharedPreferences.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwt_token", token);
    await prefs.setBool('isAuthentified', true);
  }

  /// Retrieves the JWT token from SharedPreferences.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  /// Removes the JWT token and the user (logout).
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt_token");
    await prefs.remove("user");
  }
}
