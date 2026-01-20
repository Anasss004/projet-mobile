import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch costumes on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).fetchCostumes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue Costumes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          )
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (appState.costumes.isEmpty) {
            return const Center(child: Text('Aucun costume disponible.'));
          }

          return ListView.builder(
            itemCount: appState.costumes.length,
            itemBuilder: (context, index) {
              final costume = appState.costumes[index];
              return ListTile(
                leading: costume.imageUrl != null 
                  ? Image.network(costume.imageUrl!, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.error)) 
                  : const Icon(Icons.checkroom),
                title: Text(costume.nom),
                subtitle: Text('${costume.prixJournalier} €/jour'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(costume: costume),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
