import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class CategoryService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  final AuthService _authService = AuthService();

  // Note: Si vous n'avez pas d'endpoint categories, on peut utiliser une liste statique
  // ou créer l'endpoint dans le backend
  Future<List<Map<String, dynamic>>> getCategories() async {
    // Pour l'instant, retournons une liste statique basée sur le seeder
    // TODO: Créer endpoint GET /api/categories dans le backend si nécessaire
    return [
      {'id': 1, 'nom': 'Super-héros'},
      {'id': 2, 'nom': 'Personnages historiques'},
      {'id': 3, 'nom': 'Animaux'},
      {'id': 4, 'nom': 'Fantastique'},
      {'id': 5, 'nom': 'Horreur'},
    ];
  }
}

