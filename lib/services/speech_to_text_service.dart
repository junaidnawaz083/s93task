import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final _stt = SpeechToText();

  Future<void> initSTT() async {
    bool res = await _stt.initialize(onStatus: (status) {});
  }

  Future<void> startListening(
    Function(SpeechRecognitionResult) _onSpeechResult,
  ) async {
    await _stt.listen(onResult: _onSpeechResult);
  }

  Future<void> stopListening() async {
    await _stt.stop();
  }

  Future<bool> isListining() async {
    return _stt.isListening;
  }
}
