

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  static Future<void> playButton() async {
    final prefs = await SharedPreferences.getInstance();
    final soundEnabled = prefs.getBool('sound') ?? true; // misma key que tu settings
    
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.click);
      HapticFeedback.lightImpact();
    }
  }
}