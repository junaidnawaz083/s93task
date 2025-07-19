import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class TextToSpeech {
  final _stt = SpeechToText();
  Future<void> init() async {
    if (!await requestMicrophonePermission()) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Denied',
          message: 'The user has denied the use of speech recognition.',
        ),
      );
      return;
    }
    bool res = await _stt.initialize();
    if (!res) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Denied',
          message: 'The user has denied the use of speech recognition.',
        ),
      );
      return;
    }
    _startListening();
  }

  Future<void> _startListening() async {
    await _stt.listen(onResult: _onSpeechResult);
  }

  Future<void> _stopListening() async {
    await _stt.stop();
  }

  _onSpeechResult(SpeechRecognitionResult result) {
    print(result.recognizedWords);
  }

  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      PermissionStatus newStatus = await Permission.microphone.request();
      if (newStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Opens the app settings for the user to manually enable.
    } else if (status.isRestricted) {
      return false;
    }
    return false;
  }
}
