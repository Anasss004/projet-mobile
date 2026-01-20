import 'package:flutter/material.dart';
import '../models/costume.dart';
import '../services/costume_api_service.dart';
import '../widgets/costume_card_widget.dart';
import 'client_main_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientHomeScreen extends StatefulWidget {
  final VoidCallback onSeeAllTap; // Add callback to switch to Catalogue

  const ClientHomeScreen({super.key, required this.onSeeAllTap});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  final CostumeApiService _costumeService = CostumeApiService();
  late Future<List<Costume>> _futureTeaserCostumes;

  // Categories
  final List<String> _categories = ['All', 'Business', 'Wedding', 'Party', 'Casual'];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _futureTeaserCostumes = _costumeService.fetchCostumes();
    
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200),
        vsync: this
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            
            // 1. Hero Section (Animated)
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find your',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      'Ultimate Style',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 42,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 2. Categories
            SizedBox(
              height: 40,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(30),
                        border: isSelected ? null : Border.all(color: Colors.white12),
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // 3. Special Offer Block (Geometric Abstract)
            Container(
              height: 220, // Height fixed in previous overflow measure
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  // Abstract Shapes (CustomPaint-like using Containers)
                  Positioned(
                    right: -30, top: -30,
                    child: Container(
                      width: 150, height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40, bottom: -40,
                    child: Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Special Offer',
                          style: TextStyle(
                            color: Colors.black, // Contrast on Orange
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Summer Collection\n25% OFF',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: widget.onSeeAllTap, // Check it out -> Catalogue
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text('Check it out'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 4. Featured List (Horizontal)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Featured', style: theme.textTheme.titleLarge),
                TextButton(
                  onPressed: widget.onSeeAllTap, // See All -> Catalogue
                  child: Text('See All', style: TextStyle(color: primaryColor)) // Accent Color
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 320, // Height fixed in previous overflow measure
              child: FutureBuilder<List<Costume>>(
                future: _futureTeaserCostumes,
                builder: (context, snapshot) {
                   if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No items yet', style: TextStyle(color: Colors.grey[600])));
                    }

                    final items = snapshot.data!.take(4).toList(); // Only show first 4
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return SizedBox(width: 200, child: CostumeCardWidget(costume: items[index]));
                      },
                    );
                }
              ),
            ),
            const SizedBox(height: 48),

            // 5. Social Section "Style en Action"
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Style en Action',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                Text(
                  'Partagez votre look avec #LuxurySuitRental',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Social Icons
                Row(
                  children: [
                    _SocialIcon(
                      icon: Icons.camera_alt_outlined, 
                      color: primaryColor, 
                      onTap: () => _launchSocial('https://instagram.com')
                    ),
                    const SizedBox(width: 16),
                    _SocialIcon(
                      icon: Icons.music_note_outlined, 
                      color: primaryColor, 
                      onTap: () => _launchSocial('https://tiktok.com')
                    ),
                    const SizedBox(width: 16),
                    _SocialIcon(
                      icon: Icons.facebook_outlined, 
                      color: primaryColor, 
                      onTap: () => _launchSocial('https://facebook.com')
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),

                // Mock Instagram Feed (Horizontal Scroll)
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _launchSocial('https://instagram.com'),
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image: NetworkImage('https://i.pravatar.cc/150?img=12'), // Placeholder
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Center(
                            child: Icon(Icons.favorite, color: Colors.white.withOpacity(0.8), size: 20),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 100), // Extra space for BottomNavBar
          ],
        ),
      ),
    );
  }

  void _launchSocial(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialIcon({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          color: color.withOpacity(0.1),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
