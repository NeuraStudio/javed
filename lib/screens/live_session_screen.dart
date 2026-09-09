import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/settings_provider.dart';
import '../services/speech_service.dart';
import '../services/audio_service.dart';

class LiveSessionScreen extends StatefulWidget {
  const LiveSessionScreen({super.key});

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> with SingleTickerProviderStateMixin {
  final SpeechService _speech = SpeechService();
  final AudioService _audio = AudioService();
  late final AnimationController _pulse;

  String _liveText = '';
  bool _listening = false;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _startListening();
  }

  Future<void> _startListening() async {
    final ok = await _speech.init();
    if (!ok) return;
    setState(() => _listening = true);
    await _speech.listen(
      onResult: (text, isFinal) {
        setState(() => _liveText = text);
        if (isFinal && text.trim().isNotEmpty) {
          _handleFinal(text);
        }
      },
    );
  }

  Future<void> _handleFinal(String text) async {
    await _speech.stop();
    setState(() {
      _listening = false;
      _processing = true;
    });

    final settings = context.read<SettingsProvider>();
    final chat = context.read<ChatProvider>();
    await chat.sendMessage(text, promptSuffix: settings.voiceHint);

    final last = chat.messages.isNotEmpty ? chat.messages.last : null;
    if (last != null && last.type == 'audio' && last.mediaUrl != null) {
      await _audio.playUrl(last.mediaUrl!);
    }

    setState(() => _processing = false);
    // Resume listening for the next turn.
    if (mounted) _startListening();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _speech.cancel();
    _audio.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) {
                final scale = _listening ? 1.0 + (_pulse.value * 0.25) : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF22D3EE), Color(0xFFA855F7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _processing
                    ? 'Thinking...'
                    : (_liveText.isEmpty ? 'Listening...' : _liveText),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: IconButton(
                icon: Icon(_listening ? Icons.mic : Icons.mic_none, color: Colors.white, size: 36),
                onPressed: () {
                  if (_listening) {
                    _speech.stop();
                    setState(() => _listening = false);
                  } else {
                    _startListening();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
