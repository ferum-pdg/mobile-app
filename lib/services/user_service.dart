import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  Future<User> getUser() async {
    final response = await http.get(Uri.parse("backend"));

    if(response.statusCode == 200){
      return User.fromJson(jsonDecode(response.body));
    } else{
      throw Exception("Error during the user loading.");
    }
  }
}