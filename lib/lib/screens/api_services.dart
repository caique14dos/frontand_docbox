import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';  // Certifique-se de importar o AuthService

class ApiService {
  final String baseUrl = 'https://example.com/api'; // URL base da sua API

  Future<void> fetchDocuments(String category) async {
    final token = await AuthService().getToken();  // Recupera o token de autenticação

    final response = await http.get(
      Uri.parse('$baseUrl/category/$category'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Processar os dados recebidos
      print('Dados recebidos: ${response.body}');
    } else {
      throw Exception('Erro: ${jsonDecode(response.body)['error']}');
    }
  }

  Future<void> uploadFile(String filePath) async {
    final token = await AuthService().getToken();
    final file = await http.MultipartFile.fromPath('file', filePath);

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload'),
    );
    
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(file);

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Upload bem-sucedido!');
    } else {
      throw Exception('Erro ao fazer upload');
    }
  }
}
