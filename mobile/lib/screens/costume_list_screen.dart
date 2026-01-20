// lib/screens/costume_list_screen.dart

import 'package:flutter/material.dart';
import '../models/costume.dart';
import '../services/costume_api_service.dart';
import 'rental_request_screen.dart';
import '../widgets/costume_card_widget.dart';

class CostumeListScreen extends StatefulWidget {
  const CostumeListScreen({super.key});

  @override
  State<CostumeListScreen> createState() => _CostumeListScreenState();
}

class _CostumeListScreenState extends State<CostumeListScreen> with SingleTickerProviderStateMixin {
  late Future<List<Costume>> _futureCostumes;
  final CostumeApiService _apiService = CostumeApiService();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _futureCostumes = _apiService.fetchCostumes();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Total animation time for the whole grid
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshCostumes() async {
    setState(() {
      _futureCostumes = _apiService.fetchCostumes();
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Costume>>(
        future: _futureCostumes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } 
          else if (snapshot.hasData) {
            final costumes = snapshot.data!;
            if (costumes.isEmpty) {
              return const Center(child: Text('Aucun costume trouvé.'));
            }

            // Start animation if not already running and we have data
            if (!_controller.isAnimating && !_controller.isCompleted) {
              _controller.forward();
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6, // Taller cards to prevent overflow
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: costumes.length,
              itemBuilder: (context, index) {
                // Calculate staggered delay
                // Use a curve that creates a "wave" effect
                // Total duration is 1500ms.
                const int columnCount = 2;
                final int row = index ~/ columnCount;
                final int col = index % columnCount;
                final int waveIndex = row + col; // Simple wave diagonal Logic (row + col)

                final double start = (waveIndex * 0.1).clamp(0.0, 0.8);
                final double end = (start + 0.4).clamp(0.0, 1.0);

                final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(start, end, curve: Curves.easeOutQuart),
                  ),
                );

                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: animation.value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - animation.value)), // Slide up 50px
                        child: child,
                      ),
                    );
                  },
                  child: CostumeCardWidget(costume: costumes[index]),
                );
              },
            );
          }

          return const Center(child: Text('Prêt à charger le catalogue.'));
        },
      );
  }
}