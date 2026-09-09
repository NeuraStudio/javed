import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/chat_message.dart';

class ApiService {
  Future<ChatResponse> sendChat(String prompt) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/chat');
    final res = await http
        .post(uri, headers: ApiConfig.headers, body: jsonEncode({'prompt': prompt}))
        .timeout(const Duration(seconds: 60));
    if (res.statusCode != 200) {
      throw Exception('Chat API error: ${res.statusCode} ${res.body}');
    }
    return ChatResponse.fromJson(jsonDecode(res.body));
  }

  Future<void> clearMemory() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/clear');
    final res = await http
        .post(uri, headers: ApiConfig.headers, body: jsonEncode({}))
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) {
      throw Exception('Clear API error: ${res.statusCode} ${res.body}');
    }
  }
}
