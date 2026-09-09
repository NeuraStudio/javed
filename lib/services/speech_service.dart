import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _ready = false;

  Future<bool> init() async {
    _ready = await _speech.initialize(
      onError: (e) => print('Speech error: $e'),
      onStatus: (s) => print('Speech status: $s'),
    );
    return _ready;
  }

  bool get isListening => _speech.isListening;

  Future<void> listen({
    required void Function(String text, bool isFinal) onResult,
  }) async {
    if (!_ready) await init();
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
    );
  }

  Future<void> stop() async {
    await _speech.stop();
  }

  Future<void> cancel() async {
    await _speech.cancel();
  }
}
