import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://localhost:3000"; // Substitua pela URL do seu back-end

  // Função de registro
  Future<void> register(Map<String, String> formData) async {
    final url = Uri.parse("$baseUrl/auth/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(formData),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao registrar: ${json.decode(response.body)['error']}");
    }
  }

  // Função de login
  Future<void> login(String cpf, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"cpf": cpf, "password": password}),
    );

    if (response.statusCode == 200) {
      // Salve o token usando SharedPreferences
      final token = json.decode(response.body)['token'];
      print("Token recebido: $token");

      // Armazenando o token
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', token);
    } else {
      throw Exception("Erro ao fazer login: ${json.decode(response.body)['error']}");
    }
  }

  // Função para obter o token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Retorna o token armazenado
  }

  // Função para remover o token (logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token'); // Remove o token do armazenamento
  }
}
