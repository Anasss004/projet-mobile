import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/costume.dart';
import 'auth_service.dart';

class AdminCostumeService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> createCostume({
    required String nom,
    String? description,
    required double prixJournalier,
    required String taille,
    String statut = 'Disponible',
    required int stock,
    required int categorieId,
    String? imageUrl,
    File? imageFile,
  }) async {
    try {
      final token = await _authService.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Non authentifié.');
      }

      http.Response response;

      if (imageFile != null) {
        var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/costumes'));
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });
        request.fields['nom'] = nom;
        if (description != null) request.fields['description'] = description;
        request.fields['prix_journalier'] = prixJournalier.toString();
        request.fields['taille'] = taille;
        request.fields['statut'] = statut;
        request.fields['stock'] = stock.toString();
        request.fields['categorie_id'] = categorieId.toString();
        if (imageUrl != null) request.fields['image_url'] = imageUrl;

        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        response = await http.post(
          Uri.parse('$baseUrl/costumes'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'nom': nom,
            'description': description,
            'prix_journalier': prixJournalier,
            'taille': taille,
            'statut': statut,
            'stock': stock,
            'categorie_id': categorieId,
            'image_url': imageUrl,
          }),
        );
      }

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': true,
          'message': body['message'] ?? 'Costume créé avec succès',
          'costume': body['costume'],
        };
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Erreur lors de la création',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> updateCostume({
    required int id,
    String? nom,
    String? description,
    double? prixJournalier,
    String? taille,
    String? statut,
    int? stock,
    int? categorieId,
    String? imageUrl,
    File? imageFile,
  }) async {
    try {
      final token = await _authService.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Non authentifié.');
      }

      http.Response response;

      if (imageFile != null) {
        // Laravel requires POST with _method=PUT for multipart updates
        var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/costumes/$id'));
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });
        request.fields['_method'] = 'PUT';
        
        if (nom != null) request.fields['nom'] = nom;
        if (description != null) request.fields['description'] = description;
        if (prixJournalier != null) request.fields['prix_journalier'] = prixJournalier.toString();
        if (taille != null) request.fields['taille'] = taille;
        if (statut != null) request.fields['statut'] = statut;
        if (stock != null) request.fields['stock'] = stock.toString();
        if (categorieId != null) request.fields['categorie_id'] = categorieId.toString();
        if (imageUrl != null) request.fields['image_url'] = imageUrl;

        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        final Map<String, dynamic> body = {};
        if (nom != null) body['nom'] = nom;
        if (description != null) body['description'] = description;
        if (prixJournalier != null) body['prix_journalier'] = prixJournalier;
        if (taille != null) body['taille'] = taille;
        if (statut != null) body['statut'] = statut;
        if (stock != null) body['stock'] = stock;
        if (categorieId != null) body['categorie_id'] = categorieId;
        if (imageUrl != null) body['image_url'] = imageUrl;

        response = await http.put(
          Uri.parse('$baseUrl/costumes/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );
      }

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': true,
          'message': responseBody['message'] ?? 'Costume mis à jour avec succès',
          'costume': responseBody['costume'],
        };
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Erreur lors de la mise à jour',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> deleteCostume(int id) async {
    try {
      final token = await _authService.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Non authentifié.');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/costumes/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': true,
          'message': body['message'] ?? 'Costume supprimé avec succès',
        };
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Erreur lors de la suppression',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }
}

