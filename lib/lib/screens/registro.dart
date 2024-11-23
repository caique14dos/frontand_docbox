import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://localhost:3000";

  Future<String?> login(String cpf, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cpf': cpf, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // Salvar o token localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return token;
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  Future<void> register(Map<String, String> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
