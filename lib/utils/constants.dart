// Constantes del juego: dificultades, claves de preferencias, estilos de números

class Difficulty {
  final String name;
  final int rows;
  final int cols;
  final int mineCount;

  const Difficulty({
    required this.name,
    required this.rows,
    required this.cols,
    required this.mineCount,
  });

  static const List<Difficulty> levels = [
    Difficulty(name: 'Fácil', rows: 6, cols: 6, mineCount: 10),
    Difficulty(name: 'Medio', rows: 8, cols: 8, mineCount: 20),
    Difficulty(name: 'Difícil', rows: 10, cols: 10, mineCount: 30),
  ];

  static Difficulty fromName(String name) {
    return levels.firstWhere((d) => d.name == name);
  }
}

class PrefsKeys {
  static const String difficulty = 'difficulty';
  static const String themeMode = 'themeMode';
  static const String soundEnabled = 'soundEnabled';
  static const String animationsEnabled = 'animationsEnabled';
  static const String numberStyle = 'numberStyle';
}

class NumberStyle {
  static const String classic = 'classic';
  static const String colorful = 'colorful';
  static const String retro = 'retro';
  static const String minimal = 'minimal';
}