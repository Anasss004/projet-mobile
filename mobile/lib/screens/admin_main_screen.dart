import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'admin_costumes_screen.dart';
import 'admin_rental_requests_screen.dart';
import 'login_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();

  final List<String> _titles = [
    'Gestion des Costumes',
    'Demandes de Location',
  ];

  final List<Widget> _screens = [
    const AdminCostumesScreen(),
    const AdminRentalRequestsScreen(),
  ];

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Theme.of(context).primaryColor,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Costumes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Demandes',
          ),
        ],
      ),
    );
  }
}
