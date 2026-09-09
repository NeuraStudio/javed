import 'package:talk_it/talk_it.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  final TalkIt _talk = TalkIt();
  bool _ready = false;

  Future<bool> init() async {
    if (!await Permission.microphone.request().isGranted) return false;
    _ready = await _talk.initialize();
    return _ready;
  }

  Future<void> listen({
    required void Function(String text, bool isFinal) onResult,
  }) async {
    if (!_ready) {
      final ok = await init();
      if (!ok) return;
    }
    await _talk.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.isFinal);
      },
    );
  }

  Future<void> stop() async {
    await _talk.stop();
  }

  Future<void> cancel() async {
    await _talk.cancel();
  }
}
