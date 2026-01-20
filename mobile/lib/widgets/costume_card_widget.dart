import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/costume.dart';
import '../screens/detail_screen.dart';
import '../utils/animation_utils.dart'; // Import the new utils

class CostumeCardWidget extends StatefulWidget {
  final Costume costume;

  const CostumeCardWidget({super.key, required this.costume});

  @override
  State<CostumeCardWidget> createState() => _CostumeCardWidgetState();
}

class _CostumeCardWidgetState extends State<CostumeCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // Quick response
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: AnimationUtils.scaleOnTap).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        // Wait for the tap up animation to start before navigating, or navigate immediately.
        // Navigating immediately feels snappier, the reversal happens on return or visually before push.
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailScreen(costume: widget.costume),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        // The Scale logic wraps the entire glass card
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // Dark Grey Background
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Darker shadow for depth
                blurRadius: 15,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.05)), // Subtle border
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              Expanded(
                flex: 4, // More space for image
                child: Builder(
                  builder: (context) {
                    print('DEBUG: Costume ${widget.costume.nom} URL: ${widget.costume.imageUrl}');
                    return Hero(
                  tag: 'costume-image-${widget.costume.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: widget.costume.imageUrl != null && widget.costume.imageUrl!.isNotEmpty
                        ? (widget.costume.imageUrl!.startsWith('assets/')
                            ? Image.asset(
                                widget.costume.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(color: Colors.grey[900], child: const Icon(Icons.broken_image, color: Colors.grey)),
                              )
                            : Image.network(
                                widget.costume.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(color: Colors.grey[900], child: const Icon(Icons.broken_image, color: Colors.grey)),
                              ))
                        : Container(color: Colors.grey[900], child: const Icon(Icons.image, color: Colors.grey)),
                  ),
                );
              },
            ),
          ),
              
              // Details Section
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Text(
                        widget.costume.nom,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white, // White text
                        ),
                      ),
                      
                      // Price
                      Text(
                        '${widget.costume.prixJournalier.toStringAsFixed(2)} €/day',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor, // Orange/Amber
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      
                      const Spacer(),

                      // Book Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(costume: widget.costume),
                                ),
                              );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.black, // Text on Orange
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
