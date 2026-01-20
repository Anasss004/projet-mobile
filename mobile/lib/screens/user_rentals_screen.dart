import 'package:flutter/material.dart';
import '../services/rental_service.dart';

class UserRentalsScreen extends StatefulWidget {
  const UserRentalsScreen({super.key});

  @override
  State<UserRentalsScreen> createState() => _UserRentalsScreenState();
}

class _UserRentalsScreenState extends State<UserRentalsScreen> {
  final RentalService _rentalService = RentalService();
  late Future<List<dynamic>> _futureRentals;

  @override
  void initState() {
    super.initState();
    _futureRentals = _rentalService.getMyRentals();
  }

  Future<void> _refreshRentals() async {
    setState(() {
      _futureRentals = _rentalService.getMyRentals();
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'Aucune location',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _refreshRentals,
                      child: const Text('Actualiser'),
                    ),
                  ],
                ),
              );
            }

            final rentals = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rentals.length,
              itemBuilder: (context, index) {
                final rental = rentals[index];
                final costume = rental['costume'] as Map<String, dynamic>;
                final status = rental['status'] as String;

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
                              child: Text(
                                costume['nom'] ?? 'Costume',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
                        const SizedBox(height: 12),
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
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.euro, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Prix/jour: ${costume['prix_journalier']} €',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
  }
}

