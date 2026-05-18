// Modelo compartido entre game_screen.dart y scores_screen.dart
// Ubicación sugerida: lib/logica/score_entry.dart

import 'dart:convert';

class ScoreEntry {
  final String playerName;
  final String difficulty;
  final bool won;
  final int seconds;      // tiempo en segundos
  final DateTime date;

  ScoreEntry({
    required this.playerName,
    required this.difficulty,
    required this.won,
    required this.seconds,
    required this.date,
  });

  // ── Serialización ────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
        'playerName': playerName,
        'difficulty': difficulty,
        'won': won,
        'seconds': seconds,
        'date': date.toIso8601String(),
      };

  factory ScoreEntry.fromMap(Map<String, dynamic> map) => ScoreEntry(
        playerName: map['playerName'] ?? '',
        difficulty: map['difficulty'] ?? 'Fácil',
        won: map['won'] ?? false,
        seconds: map['seconds'] ?? 0,
        date: DateTime.parse(map['date']),
      );

  String toJson() => jsonEncode(toMap());

  factory ScoreEntry.fromJson(String source) =>
      ScoreEntry.fromMap(jsonDecode(source));

  // ── Formato de tiempo legible ─────────────────────────────────────────────

  String get timeFormatted {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m > 0 ? '${m}m ${s.toString().padLeft(2, '0')}s' : '${s}s';
  }
}
