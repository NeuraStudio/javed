enum Sender { user, ai }

class ChatMessage {
  final Sender sender;
  final String text;
  final String type; // text | image | audio
  final String? mediaUrl;
  final List<String> files;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    this.type = 'text',
    this.mediaUrl,
    this.files = const [],
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'sender': sender.name,
        'text': text,
        'type': type,
        'mediaUrl': mediaUrl,
        'files': files,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        sender: json['sender'] == 'user' ? Sender.user : Sender.ai,
        text: json['text'] ?? '',
        type: json['type'] ?? 'text',
        mediaUrl: json['mediaUrl'],
        files: (json['files'] as List?)?.map((e) => e.toString()).toList() ?? [],
        timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      );
}

class ChatResponse {
  final String type;
  final String reply;
  final String? mediaUrl;
  final List<String> files;

  ChatResponse({
    required this.type,
    required this.reply,
    this.mediaUrl,
    this.files = const [],
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      type: json['type'] ?? 'text',
      reply: json['reply'] ?? '',
      mediaUrl: json['media_url'],
      files: (json['files'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
