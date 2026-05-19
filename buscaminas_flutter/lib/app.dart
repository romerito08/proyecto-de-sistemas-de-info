import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/game_screen.dart';
import 'screens/instructions.dart';
import 'screens/scores_screen.dart';
import 'screens/about_screen.dart';
import 'theme_notifier.dart'; // ← importa el notifier

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Carga la preferencia guardada antes de pintar la primera frame.
    themeNotifier.load();
    // Cuando el notifier cambie, reconstruye este widget.
    themeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  // ── Tema claro ────────────────────────────────────────────────────────────
  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF1F8E9),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Color(0xFF1B5E20),
    ),
  );

  // ── Tema oscuro ───────────────────────────────────────────────────────────
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Color(0xFF81C784),
    ),
    cardColor: const Color(0xFF1E1E1E),
    dialogBackgroundColor: const Color(0xFF1E1E1E),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas Flutter',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: themeNotifier.themeMode, // ← se actualiza reactivamente
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/menu': (context) => const MainMenuScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/game': (context) => const GameScreen(),
        '/instructions': (context) => const InstructionsScreen(),
        '/scores': (context) => const ScoresScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}