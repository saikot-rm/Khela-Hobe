import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'role_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KhelaHobeApp());
}

class KhelaHobeApp extends StatelessWidget {
  const KhelaHobeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'KhelaHobe!',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          fontFamily: 'Roboto',
        ),
        home: const RoleRouter(),
      ),
    );
  }
}
