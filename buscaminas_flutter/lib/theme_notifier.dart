import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier global para el tema de la app.
/// Escuchar con [ValueListenableBuilder] o [ListenableBuilder].
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  /// Carga la preferencia guardada desde SharedPreferences.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme') ?? 'Automático';
    _themeMode = _fromString(saved);
    notifyListeners();
  }

  /// Aplica y persiste un nuevo tema.
  Future<void> setTheme(String label) async {
    _themeMode = _fromString(label);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', label);
  }

  static ThemeMode _fromString(String label) {
    switch (label) {
      case 'Claro':
        return ThemeMode.light;
      case 'Oscuro':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

/// Instancia singleton accesible desde cualquier parte de la app.
final themeNotifier = ThemeNotifier();