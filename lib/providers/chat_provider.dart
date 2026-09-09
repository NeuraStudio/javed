import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../services/api_service.dart';
import 'history_provider.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final HistoryProvider historyProvider;

  ChatProvider({required this.historyProvider});

  String? currentSessionId;
  final List<ChatMessage> messages = [];
  bool isLoading = false;
  String? error;
  bool thinkHarder = false;

  void startNewChat() {
    currentSessionId = historyProvider.newSessionId();
    messages.clear();
    notifyListeners();
  }

  void loadSession(ChatSession session) {
    currentSessionId = session.id;
    messages
      ..clear()
      ..addAll(session.messages);
    notifyListeners();
  }

  Future<void> sendMessage(String text, {String? promptSuffix}) async {
    if (text.trim().isEmpty) return;
    currentSessionId ??= historyProvider.newSessionId();

    messages.add(ChatMessage(sender: Sender.user, text: text));
    isLoading = true;
    error = null;
    notifyListeners();

    final effectivePrompt = [
      if (thinkHarder) '[think step by step, be thorough]',
      text,
      if (promptSuffix != null) promptSuffix,
    ].join(' ');

    try {
      final res = await _api.sendChat(effectivePrompt);
      messages.add(ChatMessage(
        sender: Sender.ai,
        text: res.reply,
        type: res.type,
        mediaUrl: res.mediaUrl,
        files: res.files,
      ));
    } catch (e) {
      error = e.toString();
      messages.add(ChatMessage(
        sender: Sender.ai,
        text: 'Error: could not reach NeuraAster backend.\n$e',
      ));
    } finally {
      isLoading = false;
      await _persist();
      notifyListeners();
    }
  }

  Future<void> _persist() async {
    if (currentSessionId == null || messages.isEmpty) return;
    final title = messages.first.text.length > 40
        ? '${messages.first.text.substring(0, 40)}...'
        : messages.first.text;
    await historyProvider.upsertSession(
      ChatSession(id: currentSessionId!, title: title, messages: List.of(messages)),
    );
  }

  Future<void> clearChat() async {
    try {
      await _api.clearMemory();
    } catch (_) {
      // Non-fatal: still clear local state even if server call fails.
    }
    messages.clear();
    currentSessionId = null;
    notifyListeners();
  }

  void toggleThinkHarder(bool value) {
    thinkHarder = value;
    notifyListeners();
  }
}
