import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/costume.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator to access localhost
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'mot_de_passe': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['access_token'];
    }
    return null;
  }

  Future<List<Costume>> getCostumes(String? token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/costumes'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token', // Not strictly needed for public route per requirements, but good practice
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Costume.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load costumes');
    }
  }

  // Add other methods (register, reservations) as needed
}
