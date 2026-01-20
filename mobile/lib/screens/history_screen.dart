import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des Réservations')),
      body: const Center(
        child: Text('Votre historique de réservations apparaitra ici.'),
      ),
    );
  }
}
