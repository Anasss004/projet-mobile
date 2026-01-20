import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'costume_list_screen.dart';
import 'user_rentals_screen.dart';
import 'admin_costumes_screen.dart';
import 'admin_rental_requests_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final AuthService _authService = AuthService();
  int _currentIndex = 0;
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final isAdmin = await _authService.isAdmin();
    setState(() {
      _isAdmin = isAdmin;
      _isLoading = false;
    });
  }

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
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Define tabs based on user role
    final List<Widget> clientTabs = [
      const CostumeListScreen(),
      const CostumeListScreen(),
      const UserRentalsScreen(),
      const ProfileScreen(),
    ];

    final List<Widget> adminTabs = [
      const AdminCostumesScreen(),
      const AdminRentalRequestsScreen(),
    ];

    final tabs = _isAdmin ? adminTabs : clientTabs;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isAdmin ? 'Administration' : 'Location de Costumes'),
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
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _isAdmin
            ? [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.store),
                  label: 'Gestion Costumes',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Demandes',
                ),
              ]
            : [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.store),
                  label: 'Catalogue',
                ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'Mes Locations',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profil',
                  ),
                ],
      ),
    );
  }
}
