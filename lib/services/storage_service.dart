import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Preferencias del jugador
  static String getDifficulty() => _prefs.getString(PrefsKeys.difficulty) ?? 'Medio';
  static Future<void> setDifficulty(String diff) async => await _prefs.setString(PrefsKeys.difficulty, diff);

  static String getThemeMode() => _prefs.getString(PrefsKeys.themeMode) ?? 'system';
  static Future<void> setThemeMode(String mode) async => await _prefs.setString(PrefsKeys.themeMode, mode);

  static bool getSoundEnabled() => _prefs.getBool(PrefsKeys.soundEnabled) ?? true;
  static Future<void> setSoundEnabled(bool enabled) async => await _prefs.setBool(PrefsKeys.soundEnabled, enabled);

  static bool getAnimationsEnabled() => _prefs.getBool(PrefsKeys.animationsEnabled) ?? true;
  static Future<void> setAnimationsEnabled(bool enabled) async => await _prefs.setBool(PrefsKeys.animationsEnabled, enabled);

  static String getNumberStyle() => _prefs.getString(PrefsKeys.numberStyle) ?? NumberStyle.classic;
  static Future<void> setNumberStyle(String style) async => await _prefs.setString(PrefsKeys.numberStyle, style);

  // High scores
  static Future<void> saveHighScore(String difficulty, int timeInSeconds, int attempts, String date) async {
    int? bestTime = _prefs.getInt('highscore_${difficulty}_time');
    int? bestAttempts = _prefs.getInt('highscore_${difficulty}_attempts');
    if (bestTime == null || timeInSeconds < bestTime) {
      await _prefs.setInt('highscore_${difficulty}_time', timeInSeconds);
    }
    if (bestAttempts == null || attempts < bestAttempts) {
      await _prefs.setInt('highscore_${difficulty}_attempts', attempts);
      await _prefs.setString('highscore_${difficulty}_date', date);
    }
  }

  static Map<String, dynamic>? getHighScore(String difficulty) {
    int? time = _prefs.getInt('highscore_${difficulty}_time');
    int? attempts = _prefs.getInt('highscore_${difficulty}_attempts');
    String? date = _prefs.getString('highscore_${difficulty}_date');
    if (time == null || attempts == null) return null;
    return {'time': time, 'attempts': attempts, 'date': date};
  }

  static Future<void> clearAllHighScores() async {
    for (var diff in Difficulty.levels) {
      await _prefs.remove('highscore_${diff.name}_time');
      await _prefs.remove('highscore_${diff.name}_attempts');
      await _prefs.remove('highscore_${diff.name}_date');
    }
  }
}