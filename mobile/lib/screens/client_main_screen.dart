import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'costume_list_screen.dart';
import 'user_rentals_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'client_home_screen.dart';

class ClientMainScreen extends StatefulWidget {
  const ClientMainScreen({super.key});

  @override
  State<ClientMainScreen> createState() => _ClientMainScreenState();
}


class _ClientMainScreenState extends State<ClientMainScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();

  // List of titles corresponding to the tabs
  final List<String> _titles = [
    'Accueil', // Home Title
    'Catalogue',
    'Mes Locations',
    'Profil',
  ];

  late final List<Widget> _screens; // Use late final to access methods

  @override
  void initState() {
    super.initState();
    _screens = [
      ClientHomeScreen(onSeeAllTap: () => _navigateToTab(1)), // Home with callback
      const CostumeListScreen(),
      const UserRentalsScreen(),
      const ProfileScreen(),
    ];
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    // No manual navigation needed; StreamBuilder in AuthWrapper will handle it
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for glass effect to float over content
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black, // Match Scaffold
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1), // Subtle accent glow
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1E1E1E), // Dark Grey
          elevation: 0,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey[600],
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false, // Cleaner look
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Catalogue',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'Mes Locations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
