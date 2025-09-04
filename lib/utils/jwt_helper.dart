import 'package:jwt_decoder/jwt_decoder.dart';

// Utility wrapper around `jwt_decoder` to check expiration and decode payload
class JWTHelper {
  // Returns true if the JWT is expired (compares `exp` claim with current time)
  static bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  // Decode JWT payload into a map of claims (does not verify signature)
  static Map<String, dynamic> decodeToken(String token) {
    return JwtDecoder.decode(token);
  }
}
