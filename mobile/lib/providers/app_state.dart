import 'package:flutter/material.dart';
import '../models/costume.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';

class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Costume> _costumes = [];
  bool _isLoading = false;
  String? _token;

  List<Costume> get costumes => _costumes;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _apiService.login(email, password);
      if (token != null) {
        _token = token;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> fetchCostumes() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Try fetching from API
      final remoteCostumes = await _apiService.getCostumes(_token);
      _costumes = remoteCostumes;
      
      // Cache to local DB
      int assetIndex = 0;
      List<Costume> patchedCostumes = []; // New list to hold modified objects

      for (var costume in remoteCostumes) {
        // PATCH: Blindly assign assets text if API returns no image
        if (costume.imageUrl == null || costume.imageUrl!.isEmpty) {
           // Cycle through suit1.jpeg to suit4.jpeg
           int suitNumber = (assetIndex % 4) + 1; 
           String newUrl = 'assets/images/suit$suitNumber.jpeg';
           
           print('DEBUG: Patching ${costume.nom} with $newUrl');
           
           costume = costume.copyWith(imageUrl: newUrl);
           assetIndex++;
        } else {
           print('DEBUG: ${costume.nom} already has URL: ${costume.imageUrl}');
        }
        await _dbHelper.insertCostume(costume);
        patchedCostumes.add(costume); // Add to new list
      }
      
      print('DEBUG: Final list count: ${patchedCostumes.length}');
      
      // Update the list with the patched costumes
      _costumes = patchedCostumes;
    } catch (e) {
      // If API fails, load from local DB
      print('API Error: $e. Loading from local DB.');
      _costumes = await _dbHelper.readAllCostumes();
    }

    _isLoading = false;
    notifyListeners();
  }
}
