import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  late FlutterTts _flutterTts;

  TextToSpeech() {
    _flutterTts = FlutterTts();
  }

  Future<void> speak(String text) async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak('Here is your $text screen.');
    } catch (e) {
      print('Error: $e');
    }
  }
}
