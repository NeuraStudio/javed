import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_session.dart';

class StorageService {
  static const _sessionsKey = 'neuraaster_sessions';
  static const _voiceGenderKey = 'neuraaster_voice_gender';
  static const _voiceLangKey = 'neuraaster_voice_lang';
  static const _themeModeKey = 'neuraaster_theme_mode'; // system | light | dark
  static const _accentKey = 'neuraaster_accent'; // hex string

  // ---------------- Chat sessions (real local history) ----------------
  Future<List<ChatSession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_sessionsKey) ?? [];
    return raw
        .map((s) => ChatSession.fromJson(Map<String, dynamic>.from(jsonDecode(s))))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveSessions(List<ChatSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_sessionsKey, raw);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionsKey);
  }

  // ---------------- Settings ----------------
  Future<String> getVoiceGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_voiceGenderKey) ?? 'female';
  }

  Future<void> setVoiceGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_voiceGenderKey, gender);
  }

  Future<String> getVoiceLang() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_voiceLangKey) ?? 'hindi';
  }

  Future<void> setVoiceLang(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_voiceLangKey, lang);
  }

  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey) ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode);
  }

  Future<String> getAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accentKey) ?? '#5B8DEF';
  }

  Future<void> setAccentColor(String hex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accentKey, hex);
  }
}
