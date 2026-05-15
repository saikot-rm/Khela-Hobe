import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/dashboards/player_dashboard.dart';
import 'screens/dashboards/landowner_dashboard.dart';
import 'screens/dashboards/investor_dashboard.dart';
import 'screens/auth/login_screen.dart';

class RoleRouter extends StatefulWidget {
  const RoleRouter({Key? key}) : super(key: key);

  @override
  State<RoleRouter> createState() => _RoleRouterState();
}

class _RoleRouterState extends State<RoleRouter> {
  late Future<Widget> _routeFuture;

  @override
  void initState() {
    super.initState();
    _routeFuture = _determineRoute();
  }

  /// Determines which widget to display based on user role
  Future<Widget> _determineRoute() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get stored user data
      final token = prefs.getString('auth_token');
      final userRole = prefs.getString('user_role');
      
      // If no token or role, show login
      if (token == null || userRole == null) {
        return const LoginScreen();
      }

      // Route based on role
      switch (userRole.toLowerCase()) {
        case 'player':
          return const PlayerDashboard();
        case 'landowner':
          return const LandownerDashboard();
        case 'investor':
          return const InvestorDashboard();
        default:
          return const LoginScreen();
      }
    } catch (e) {
      print('Error determining route: $e');
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _routeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Loading KhelaHobe...'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            ),
          );
        }

        return snapshot.data ?? const LoginScreen();
      },
    );
  }
}
