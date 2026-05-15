import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'widgets/role_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KhelaHobeApp());
}

class KhelaHobeApp extends StatelessWidget {
  const KhelaHobeApp({Key? key}) : super(key: key);

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
        routes: {
          '/': (context) => const RoleRouter(),
        },
      ),
    );
  }
}
