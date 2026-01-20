import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Get stored token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  // Store token
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  // Store user data
  Future<void> saveUser(Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user));
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return jsonDecode(userJson) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null;
  }

  // Reactive Auth State
  final _authStateController = StreamController<Map<String, dynamic>?>.broadcast();
  Stream<Map<String, dynamic>?> get authStateChanges => _authStateController.stream;

  // Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'mot_de_passe': password,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final token = body['access_token'] as String;
        final user = body['user'] as Map<String, dynamic>;

        // Save token and user data
        await saveToken(token);
        await saveUser(user);

        // Notify stream
        _authStateController.add(user);

        return {
          'success': true,
          'token': token,
          'user': user,
        };
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Erreur de connexion',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  // Register
  Future<Map<String, dynamic>?> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'mot_de_passe': password,
        }),
      );

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final token = body['access_token'] as String;
        final user = body['user'] as Map<String, dynamic>;

        // Save token and user data
        await saveToken(token);
        await saveUser(user);

        // Notify stream (Auto-login on register)
        _authStateController.add(user);

        return {
          'success': true,
          'token': token,
          'user': user,
        };
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Erreur d\'enregistrement',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  // Clear token and user data (logout)
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
      
      // Notify stream
      _authStateController.add(null);
    } catch (e) {
      print('Error logging out: $e');
    }
  }
  
  // Initialize Auth State (Check at startup)
  Future<void> initAuth() async {
    final user = await getUser();
    _authStateController.add(user);
  }
}

