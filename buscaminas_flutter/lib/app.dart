
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/game_screen.dart';
import 'screens/instructions.dart';
import 'screens/scores_screen.dart';
import 'screens/about_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.blue),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/menu': (context) => const MenuScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/game': (context) => const GameScreen(),
        '/instructions': (context) => const InstructionsScreen(),
        '/scores': (context) => const ScoresScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}