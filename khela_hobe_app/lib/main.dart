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
    const backgroundColor = Color(0xFF360D3A);
    const cardColor = Color(0xFF4A144D);
    const accentGreen = Color(0xFF00FF85);
    const accentMagenta = Color(0xFFEA047E);
    const accentCyan = Color(0xFF00FFFF);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'KhelaHobe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: backgroundColor,
          colorScheme: const ColorScheme.dark(
            primary: accentGreen,
            secondary: accentMagenta,
            surface: cardColor,
          ),
          fontFamily: 'Montserrat',
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontFamily: 'Oswald',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Oswald',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            titleLarge: TextStyle(
              fontFamily: 'Oswald',
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            bodyLarge: TextStyle(color: Color(0xFFE9ECF8)),
            bodyMedium: TextStyle(color: Color(0xFFB8C1D9)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            color: cardColor,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFF1B2446),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: accentCyan),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: Color(0xFF31406F)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: accentGreen, width: 2),
            ),
            labelStyle: TextStyle(color: Color(0xFFB8C1D9)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: accentMagenta,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        home: const RoleRouter(),
      ),
    );
  }
}
