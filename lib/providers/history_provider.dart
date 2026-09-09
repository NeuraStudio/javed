import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_session.dart';
import '../services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final _uuid = const Uuid();

  List<ChatSession> sessions = [];
  String searchQuery = '';

  List<ChatSession> get filtered {
    if (searchQuery.trim().isEmpty) return sessions;
    final q = searchQuery.toLowerCase();
    return sessions.where((s) => s.title.toLowerCase().contains(q)).toList();
  }

  Future<void> load() async {
    sessions = await _storage.loadSessions();
    notifyListeners();
  }

  void setSearch(String q) {
    searchQuery = q;
    notifyListeners();
  }

  String newSessionId() => _uuid.v4();

  Future<void> upsertSession(ChatSession session) async {
    final idx = sessions.indexWhere((s) => s.id == session.id);
    if (idx >= 0) {
      sessions[idx] = session;
    } else {
      sessions.insert(0, session);
    }
    await _storage.saveSessions(sessions);
    notifyListeners();
  }

  Future<void> deleteSession(String id) async {
    sessions.removeWhere((s) => s.id == id);
    await _storage.saveSessions(sessions);
    notifyListeners();
  }

  Future<void> clearAllHistory() async {
    sessions.clear();
    await _storage.clearAll();
    notifyListeners();
  }
}
