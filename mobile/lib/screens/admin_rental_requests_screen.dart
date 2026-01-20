import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminRentalRequestsScreen extends StatefulWidget {
  const AdminRentalRequestsScreen({super.key});

  @override
  State<AdminRentalRequestsScreen> createState() => _AdminRentalRequestsScreenState();
}

class _AdminRentalRequestsScreenState extends State<AdminRentalRequestsScreen> {
  final AuthService _authService = AuthService();
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  late Future<List<dynamic>> _futureRentals;
  String _filterStatus = 'Tous';

  @override
  void initState() {
    super.initState();
    _futureRentals = _fetchRentals();
  }

  Future<List<dynamic>> _fetchRentals() async {
    try {
      final token = await _authService.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Non authentifié.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/rentals'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as List;
        return body;
      } else {
        throw Exception('Erreur lors du chargement des demandes');
      }
    } catch (e) {
      throw Exception('Erreur: ${e.toString()}');
    }
  }

  Future<void> _approveRental(int rentalId) async {
    try {
      final token = await _authService.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Non authentifié.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/rentals/$rentalId/approve'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Demande approuvée avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _futureRentals = _fetchRentals();
          });
        }
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorBody['message'] ?? 'Erreur lors de l\'approbation');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectRental(int rentalId) async {
    try {
      final token = await _authService.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Non authentifié.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/rentals/$rentalId/reject'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Demande refusée avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _futureRentals = _fetchRentals();
          });
        }
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorBody['message'] ?? 'Erreur lors du refus');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateRentalStatus(int rentalId, String status) async {
    try {
      final token = await _authService.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Non authentifié.');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/rentals/$rentalId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Statut mis à jour: $status'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _futureRentals = _fetchRentals();
          });
        }
      } else {
        throw Exception('Erreur lors de la mise à jour');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshRentals() async {
    setState(() {
      _futureRentals = _fetchRentals();
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Returned':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Confirmed':
        return 'Confirmé';
      case 'Pending':
        return 'En attente';
      case 'Returned':
        return 'Retourné';
      case 'Cancelled':
        return 'Annulé';
      default:
        return status;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshRentals,
        child: FutureBuilder<List<dynamic>>(
          future: _futureRentals,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Erreur: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshRentals,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Aucune demande de location.'),
              );
            }

            List<dynamic> rentals = snapshot.data!;

            // Appliquer le filtre
            if (_filterStatus != 'Tous') {
              rentals = rentals.where((rental) {
                return rental['status'] == _filterStatus;
              }).toList();
            }

            return Column(
              children: [
                // Filtres
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text('Filtre: '),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _filterStatus,
                          isExpanded: true,
                          items: ['Tous', 'Pending', 'Confirmed', 'Returned', 'Cancelled']
                              .map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(_getStatusText(status)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _filterStatus = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Liste des rentals
                Expanded(
                  child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rentals.length,
              itemBuilder: (context, index) {
                final rental = rentals[index];
                final user = rental['user'] as Map<String, dynamic>;
                final costume = rental['costume'] as Map<String, dynamic>;
                final status = rental['status'] as String;
                final isPending = status == 'Pending';

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    costume['nom'] ?? 'Costume',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Client: ${user['name'] ?? 'N/A'} (${user['email'] ?? 'N/A'})',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Chip(
                              label: Text(
                                _getStatusText(status),
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: _getStatusColor(status),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Du ${_formatDate(rental['start_date'])} au ${_formatDate(rental['end_date'])}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (isPending) ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _approveRental(rental['id']),
                                  icon: const Icon(Icons.check),
                                  label: const Text('Approuver'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _rejectRental(rental['id']),
                                  icon: const Icon(Icons.close),
                                  label: const Text('Refuser'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else if (status == 'Confirmed') ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _updateRentalStatus(rental['id'], 'Returned'),
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Marquer comme retourné'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
          },
        ),
      );
  }
}

