import 'package:flutter/material.dart';
import '../models/costume.dart';
import 'rental_request_screen.dart';

class DetailScreen extends StatelessWidget {
  final Costume costume;

  const DetailScreen({super.key, required this.costume});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allow image to go behind app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Explicit White Back Button
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'costume-image-${costume.id}',
              child: costume.imageUrl != null && costume.imageUrl!.isNotEmpty
                  ? (costume.imageUrl!.startsWith('assets/')
                      ? Image.asset(costume.imageUrl!, height: 400, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(height: 400, color: Colors.grey[900], child: const Icon(Icons.broken_image, size: 80, color: Colors.grey)),
                        )
                      : Image.network(costume.imageUrl!, height: 400, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(height: 400, color: Colors.grey[900], child: const Icon(Icons.broken_image, size: 80, color: Colors.grey)),
                        ))
                  : Container(
                      height: 400,
                      color: Colors.grey[900],
                      child: const Icon(Icons.image, size: 80, color: Colors.grey),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    costume.nom, 
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${costume.prixJournalier.toStringAsFixed(2)} € / day',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor, // Orange
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Info tags
                  Wrap(
                    spacing: 12,
                    children: [
                      Chip(
                        label: Text('Size: ${costume.taille ?? "N/A"}'),
                        backgroundColor: Colors.white10,
                        labelStyle: const TextStyle(color: Colors.white),
                        side: BorderSide.none,
                      ),
                      Chip(
                        label: Text(costume.stock > 0 ? 'In Stock' : 'Unavailable'),
                        backgroundColor: costume.stock > 0 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: costume.stock > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    costume.description ?? 'No description available for this costume.',
                    style: const TextStyle(
                      fontSize: 16, 
                      height: 1.6,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 80), // Space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Dark Background
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: costume.stock > 0
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RentalRequestScreen(costume: costume),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.black, // Text on Orange
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            costume.stock > 0 ? 'Book Now' : 'Out of Stock',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
