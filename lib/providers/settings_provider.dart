import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  ThemeMode themeMode = ThemeMode.system;
  Color accentColor = const Color(0xFF5B8DEF);
  String voiceGender = 'female'; // male | female
  String voiceLang = 'hindi'; // hindi | english | urdu

  Future<void> load() async {
    final mode = await _storage.getThemeMode();
    themeMode = switch (mode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final hex = await _storage.getAccentColor();
    accentColor = Color(int.parse(hex.replaceFirst('#', '0xFF')));
    voiceGender = await _storage.getVoiceGender();
    voiceLang = await _storage.getVoiceLang();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    await _storage.setThemeMode(mode.name);
    notifyListeners();
  }

  Future<void> setAccentColor(Color color) async {
    accentColor = color;
    final hex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    await _storage.setAccentColor(hex);
    notifyListeners();
  }

  Future<void> setVoiceGender(String gender) async {
    voiceGender = gender;
    await _storage.setVoiceGender(gender);
    notifyListeners();
  }

  Future<void> setVoiceLang(String lang) async {
    voiceLang = lang;
    await _storage.setVoiceLang(lang);
    notifyListeners();
  }

  /// Appended to prompts sent from the Live Session voice mode, so the
  /// backend knows which voice/language to reply in.
  String get voiceHint => ' [speak in $voiceGender $voiceLang voice]';
}
