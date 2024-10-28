// import 'package:bonga_nami/utils/permissions.dart';
// import 'package:speech_to_text/speech_to_text.dart';
//
// class SpeechRecognition {
//   final SpeechToText _speech = SpeechToText();
//   String recognized_words = '';
//
//   Future<void> initializeSpeechRecognition() async {
//     try {
//       bool isPermissionGranted = await _getMicrophonePermission();
//       print('Permission microphone $isPermissionGranted');
//       await _handlePermissionResponse(isPermissionGranted);
//     } catch (error) {
//       print('Error in initializing $error');
//     }
//   }
//
//   Future<bool> _getMicrophonePermission() async {
//     try {
//       bool hasPermission = await _speech.initialize();
//       bool isPermissionGranted = false;
//       if (!hasPermission) {
//         final permission = Permissions();
//         isPermissionGranted = await permission.listenForPermissions();
//
//         if (!isPermissionGranted) {
//           print('Microphone permission not granted');
//         }
//       }
//
//       return hasPermission ?? isPermissionGranted;
//     } catch (error) {
//       print('Error initializing speech recognition $error');
//       return false;
//     }
//   }
//
//   Future<void> _handlePermissionResponse(bool isPermissionGranted) async {
//     if (isPermissionGranted) {
//       // Permission granted, continue with voice recognition
//
//       // ...
//     } else {
//       // Permission not granted, show error message or ask the user to grant permission manually
//
//       // ...
//     }
//   }
//
//   bool isSpeechRecognitionAvailable() {
//     return _speech.isAvailable;
//   }
//
//   Future<String> startSpeechRecognition() async {
//     await _speech.listen(
//         onResult: (result) {
//           recognized_words = result.recognizedWords;
//           print('Recognition result: ${result.recognizedWords}');
//         },
//         listenFor: const Duration(minutes: 1),
//         localeId: "en_En",
//         listenOptions: SpeechListenOptions(
//             partialResults: false, listenMode: ListenMode.confirmation));
//     return Future.value(recognized_words);
//   }
//
//   void stopSpeechRecognition() {
//     _speech.stop();
//   }
//
//   void disposeSpeechRecognition() {
//     _speech.cancel();
//   }
//
//   // void _onSpeechResult(SpeechRecognitionResult result){
//   //
//   // }
// }

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
      print('Error in initializing $error');
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
      print('Error initializing speech recognition $error');
      return false;
    }
  }

  Future<void> _handlePermissionResponse(bool isPermissionGranted) async {
    if (!isPermissionGranted) {
      print('Microphone permission not granted');
    }
  }

  Future<String> startSpeechRecognition() async {
    if (!_speech.isAvailable) {
      return Future.error("Speech recognition unavailable");
    }

    // Create a Completer to return the recognized words once available
    final Completer<String> completer = Completer<String>();

    await _speech.listen(
      onResult: (result) {
        print(result);
        recognizedWords = result.recognizedWords;
        print('Recognition result: ${result.recognizedWords}');

        // Complete the completer with the recognized words once available
        completer.complete(recognizedWords);
      },
      listenFor: const Duration(minutes: 1),
      localeId: "en_En",
      listenOptions: SpeechListenOptions(
        partialResults: false,
        listenMode: ListenMode.confirmation,
      ),
    );

    // Wait for the completer to complete with the result
    return completer.future;
  }

  Future<void> stopSpeechRecognition() async {
    _speech.stop();
  }
}
