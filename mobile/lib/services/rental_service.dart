import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class RentalService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> requestRental({
    required int costumeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final token = await _authService.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Non authentifié. Veuillez vous connecter.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/rentals/request'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'costume_id': costumeId,
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
        }),
      );

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': true,
          'message': body['message'] ?? 'Demande de location créée avec succès',
          'rental': body['rental'],
        };
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Erreur lors de la création de la demande',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  Future<List<dynamic>> getMyRentals() async {
    try {
      final token = await _authService.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Non authentifié.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/rentals/my-rentals'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as List;
        return body;
      } else {
        throw Exception('Erreur lors du chargement des locations');
      }
    } catch (e) {
      throw Exception('Erreur: ${e.toString()}');
    }
  }
}

