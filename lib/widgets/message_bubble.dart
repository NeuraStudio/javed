import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/chat_message.dart';
import '../services/audio_service.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == Sender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary.withOpacity(0.85)
              : Colors.grey[850],
          borderRadius: BorderRadius.circular(14),
        ),
        child: _buildContent(context, isUser),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isUser) {
    if (message.type == 'image' && message.mediaUrl != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              message.mediaUrl!,
              errorBuilder: (_, __, ___) => const Text('Image failed to load'),
            ),
          ),
          if (message.text.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(message.text, style: const TextStyle(color: Colors.white)),
          ],
        ],
      );
    }

    if (message.type == 'audio' && message.mediaUrl != null) {
      return _AudioBubble(url: message.mediaUrl!, text: message.text);
    }

    return isUser
        ? Text(message.text, style: const TextStyle(color: Colors.white))
        : MarkdownBody(
            data: message.text,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(color: Colors.white),
              code: TextStyle(backgroundColor: Colors.black54, color: Colors.greenAccent[100]),
            ),
          );
  }
}

class _AudioBubble extends StatefulWidget {
  final String url;
  final String text;
  const _AudioBubble({required this.url, required this.text});

  @override
  State<_AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<_AudioBubble> {
  final AudioService _audio = AudioService();
  bool _playing = false;

  Future<void> _toggle() async {
    if (_playing) {
      await _audio.stop();
      setState(() => _playing = false);
    } else {
      await _audio.playUrl(widget.url);
      setState(() => _playing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(_playing ? Icons.stop_circle : Icons.play_circle, color: Colors.white),
          onPressed: _toggle,
        ),
        Flexible(child: Text(widget.text, style: const TextStyle(color: Colors.white))),
      ],
    );
  }
}
