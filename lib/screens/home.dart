import 'package:bonga_nami/services/speechToText.dart';
import 'package:bonga_nami/services/textToSpeech.dart';
import 'package:bonga_nami/utils/colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String spokenWords = ''; // String to store recognized words
  bool isListening = false;
  Color screenColor = Colors.white;
  String colorName = 'white';
  String errorMessage = '';
  late SpeechRecognition speechRecognition;
  late TextToSpeech textToSpeech;

  @override
  void initState() {
    super.initState();
    speechRecognition = SpeechRecognition();
    textToSpeech = TextToSpeech();
    _initializeSpeechRecognition();
  }

  // Initialize speech recognition and handle errors
  Future<void> _initializeSpeechRecognition() async {
    try {
      await speechRecognition.initializeSpeechRecognition();
    } catch (error) {
      setState(() {
        errorMessage = 'Error : $error';
        spokenWords = '';
        isListening = false;
      });
    }
  }

  // Start speech recognition and get the result
  Future<void> _startRecognition() async {
    setState(() {
      isListening = true;
      spokenWords = '';
      errorMessage = '';
    });

    // Await the result of the speech recognition (Future<String>)
    try {
      final result = await speechRecognition.startSpeechRecognition();

      setState(() {
        spokenWords = result;
        isListening = false;
        screenColor = splitInputAndColor(spokenWords.toLowerCase())["color"];
        colorName = splitInputAndColor(spokenWords.toLowerCase())["name"];
      });
      textToSpeech.speak(colorName);
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isListening = false;
      });
    }
  }

  // Stop speech recognition
  void _stopRecognition() async {
    await speechRecognition.stopSpeechRecognition();
    setState(() {
      isListening = false;
    });
  }

  void _wrongTap() {
    setState(() {
      spokenWords = '';
      errorMessage = '';
    });
  }

  Color _getTextColor(Color screenColor) {
    switch (screenColor) {
      case Colors.red:
        return Colors.white;
      case Colors.white:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: Row(
          children: [
            Expanded(
              child: Container(
                color: spokenWords.isNotEmpty ? screenColor : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onLongPress:
                              _startRecognition, // Start listening when button is pressed
                          onLongPressUp:
                              _stopRecognition, // Stop listening when button is released
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: ElevatedButton(
                              onPressed: _wrongTap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(75),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                height: 120,
                                child: const Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Icon(
                                      Icons.mic,
                                      color: Colors.white,
                                      size: 45.0,
                                    ),
                                    Text(
                                      'Speak',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Display the spoken words immediately
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        errorMessage.isNotEmpty
                            ? spokenWords
                            : spokenWords.isNotEmpty
                                ? 'You said: $spokenWords'
                                : isListening
                                    ? 'Listening...'
                                    : 'Press and hold to speak',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: errorMessage.isNotEmpty
                              ? Colors.red
                              : spokenWords.isNotEmpty
                                  ? _getTextColor(screenColor)
                                  : Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.black,
    elevation: 0,
    title: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: const Text(
            'IHearYou',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
