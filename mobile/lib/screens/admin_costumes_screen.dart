import 'package:flutter/material.dart';
import '../models/costume.dart';
import '../services/costume_api_service.dart';
import 'create_costume_screen.dart';
import 'edit_costume_screen.dart';

class AdminCostumesScreen extends StatefulWidget {
  const AdminCostumesScreen({super.key});

  @override
  State<AdminCostumesScreen> createState() => _AdminCostumesScreenState();
}

class _AdminCostumesScreenState extends State<AdminCostumesScreen> {
  late Future<List<Costume>> _futureCostumes;
  final CostumeApiService _apiService = CostumeApiService();

  @override
  void initState() {
    super.initState();
    _futureCostumes = _apiService.fetchCostumes();
  }

  Future<void> _refreshCostumes() async {
    setState(() {
      _futureCostumes = _apiService.fetchCostumes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshCostumes,
        child: FutureBuilder<List<Costume>>(
          future: _futureCostumes,
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
                      onPressed: _refreshCostumes,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Aucun costume trouvé.'),
              );
            }

            final costumes = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: costumes.length,
              itemBuilder: (context, index) {
                final costume = costumes[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(
                      costume.nom,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Taille: ${costume.taille}'),
                        Text('Prix: ${costume.prixJournalier.toStringAsFixed(2)} €/jour'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              costume.stock > 0 ? Icons.check_circle : Icons.cancel,
                              size: 16,
                              color: costume.stock > 0 ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Stock: ${costume.stock}',
                              style: TextStyle(
                                color: costume.stock > 0 ? Colors.green[700] : Colors.red[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditCostumeScreen(costume: costume),
                          ),
                        ).then((success) {
                          if (success == true) {
                            _refreshCostumes();
                          }
                        });
                      },
                      tooltip: 'Modifier',
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateCostumeScreen(),
            ),
          ).then((success) {
            if (success == true) {
              _refreshCostumes();
            }
          });
        },
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un costume',
      ),
    );
  }
}

