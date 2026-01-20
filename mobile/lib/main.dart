import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/client_main_screen.dart';
import 'screens/admin_main_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location de Costumes',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000), // Pure Black or #121212
        primaryColor: const Color(0xFFFF8C00), // Dark Orange / Amber
        cardColor: const Color(0xFF1E1E1E), // Dark Grey
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF8C00),
          secondary: Color(0xFFFF8C00),
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF000000),
          onPrimary: Colors.white,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -1.0,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.initAuth(); // Initialize auth check
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
           // Show loading while checking initial state
           return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          final role = user['role'];

          if (role == 'admin') {
            return const AdminMainScreen();
          } else {
            return const ClientMainScreen();
          }
        }

        // Not authenticated
        return const LoginScreen();
      },
    );
  }
}