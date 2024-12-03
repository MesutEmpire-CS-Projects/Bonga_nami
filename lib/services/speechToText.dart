import 'dart:async';
import 'package:bonga_nami/utils/permissions.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognition {
  final SpeechToText _speech = SpeechToText();
  String recognizedWords = '';

  Future<void> initializeSpeechRecognition() async {
    try {
      bool isPermissionGranted = await _getMicrophonePermission();
      await _handlePermissionResponse(isPermissionGranted);
    } catch (error) {
      throw Exception('Error in initializing speech recognition : $error');
    }
  }

  Future<bool> _getMicrophonePermission() async {
    try {
      bool hasPermission = await _speech.initialize();
      if (!hasPermission) {
        final permission = Permissions();
        return await permission.listenForPermissions();
      }
      return hasPermission;
    } catch (error) {
      throw Exception('Error getting microphone permission : $error');
      // return false;
    }
  }

  Future<void> _handlePermissionResponse(bool isPermissionGranted) async {
    if (!isPermissionGranted) {
      throw Exception('Microphone permission not granted');
    }
  }

  Future<String> startSpeechRecognition() async {
    try {
      if (!_speech.isAvailable) {
        return Future.error("Speech recognition unavailable");
      }

      // Create a Completer to return the recognized words once available
      final Completer<String> completer = Completer<String>();

      await _speech.listen(
        onResult: (result) {
          recognizedWords = result.recognizedWords;

          // // Complete the completer with the recognized words once available
          // completer.complete(recognizedWords);
          // Check if the result is final (speech input is complete)
          if (result.finalResult) {
            completer.complete(recognizedWords);
          }
        },
        listenFor: const Duration(minutes: 1),
        localeId: "en_En",
        listenOptions: SpeechListenOptions(
          partialResults: true,
          listenMode: ListenMode.confirmation,
        ),
      );

      // Wait for the completer to complete with the result
      return completer.future;
    } catch (error) {
      throw Exception('Error starting speech recognition : $error');
    }
  }

  Future<void> stopSpeechRecognition() async {
    _speech.stop();
  }
}
