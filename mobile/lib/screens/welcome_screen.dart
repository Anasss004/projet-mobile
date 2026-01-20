import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/costume_api_service.dart';
import '../models/costume.dart';
import '../widgets/costume_card_widget.dart';
import 'client_main_screen.dart';
import 'admin_main_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  final AuthService _authService = AuthService();
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

  void _handleExplore() async {
      // navigation logic (kept same as before)
      final isAuthenticated = await _authService.isAuthenticated();
      if (!mounted) return;
      if (isAuthenticated) {
        final isAdmin = await _authService.isAdmin();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => isAdmin ? const AdminMainScreen() : const ClientMainScreen()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // Minimalist Transparent App Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
                onPressed: () {}, 
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
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
                height: 220, // Increased to prevent overflow
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
                            onPressed: _handleExplore,
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
                    onPressed: _handleExplore, 
                    child: Text('See All', style: TextStyle(color: primaryColor)) // Accent Color
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                height: 320, // Increased to prevent card overflow
                child: FutureBuilder<List<Costume>>(
                  future: _futureTeaserCostumes,
                  builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No items yet', style: TextStyle(color: Colors.grey[600])));
                      }

                      final items = snapshot.data!.take(4).toList();
                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          // Note: CostumeCardWidget needs to respond to dark mode correctly
                          return SizedBox(width: 200, child: CostumeCardWidget(costume: items[index]));
                        },
                      );
                  }
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
