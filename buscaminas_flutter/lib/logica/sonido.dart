import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  // ── Helper interno para no repetir la lectura de prefs ──────────────────
  static Future<bool> _isSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('sound') ?? true;
  }

  // ── Botón / navegación ───────────────────────────────────────────────────
  static Future<void> playButton() async {
    if (!await _isSoundEnabled()) return;
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  // ── Revelar casilla normal ───────────────────────────────────────────────
  static Future<void> playReveal() async {
    if (!await _isSoundEnabled()) return;
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.selectionClick();
  }

  // ── Poner / quitar bandera ───────────────────────────────────────────────
  static Future<void> playFlag() async {
    if (!await _isSoundEnabled()) return;
    HapticFeedback.mediumImpact();
  }

  // ── Victoria ─────────────────────────────────────────────────────────────
  static Future<void> playWin() async {
    if (!await _isSoundEnabled()) return;
    HapticFeedback.heavyImpact();
  }

  // ── Derrota (pisaste una mina) ───────────────────────────────────────────
  static Future<void> playLose() async {
    if (!await _isSoundEnabled()) return;
    SystemSound.play(SystemSoundType.alert);
    HapticFeedback.heavyImpact();
  }
}
