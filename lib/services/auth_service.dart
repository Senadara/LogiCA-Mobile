import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://your-backend-url/api";

  Future<Map<String, dynamic>> register(String name, String email, String password, String role) async {
    final url = Uri.parse('$baseUrl/http://10');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password,
        "role": role
      }),
    );

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/loginapi');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );

    return json.decode(response.body);
  }
}
