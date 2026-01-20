// lib/services/costume_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/costume.dart';
import 'auth_service.dart';

class CostumeApiService {
  // ATTENTION: 10.0.2.2 est nécessaire si vous utilisez l'émulateur Android standard.
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final AuthService _authService = AuthService();

  Future<List<Costume>> fetchCostumes() async {
    try {
      // Get token from storage
      final token = await _authService.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Non authentifié. Veuillez vous connecter.');
      }

      // Prepare headers with authorization token
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/costumes'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final body = response.body;
        if (body.isEmpty) {
          return []; // Return empty list if response is empty
        }
        final decoded = json.decode(body);
        // Check if response is an error object
        if (decoded is Map && decoded.containsKey('error')) {
          throw Exception(decoded['message'] ?? decoded['error']);
        }
        // Check if it's a list
        if (decoded is List) {
          Iterable list = decoded;
          List<Costume> costumes = list.map((model) => Costume.fromJson(model)).toList();

          // PATCH: Assign fallback images if API returns no image
          int assetIndex = 0;
          for (int i = 0; i < costumes.length; i++) {
             if (costumes[i].imageUrl == null || costumes[i].imageUrl!.isEmpty) {
                 int suitNumber = (assetIndex % 4) + 1;
                 String newUrl = 'assets/images/suit$suitNumber.jpeg';
                 costumes[i] = costumes[i].copyWith(imageUrl: newUrl);
                 assetIndex++;
             }
          }
          
          return costumes;
        }
        throw Exception('Réponse API invalide');
      } else if (response.statusCode == 401) {
        // Unauthorized - token might be invalid
        await _authService.logout();
        throw Exception('Session expirée. Veuillez vous reconnecter.');
      } else {
        // Try to parse error message from JSON response
        try {
          final errorBody = json.decode(response.body);
          if (errorBody is Map && errorBody.containsKey('message')) {
            throw Exception(errorBody['message']);
          }
        } catch (_) {
          // If not JSON, use the raw body
        }
        throw Exception('Erreur HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('Network is unreachable')) {
        throw Exception('Impossible de se connecter au serveur. Vérifiez que le backend est démarré sur http://localhost:8000');
      }
      rethrow;
    }
  }
}