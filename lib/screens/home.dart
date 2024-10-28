// import 'package:bonga_nami/services/speechToText.dart';
// import 'package:flutter/material.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late Future<String> spokenWords = Future.value('');
//   late bool showWords = false;
//   late SpeechRecognition speechRecognition;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     speechRecognition = SpeechRecognition();
//     speechRecognition.initializeSpeechRecognition();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: _buildAppBar(),
//         body: Column(
//           children: [
//             Row(
//               // crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                     padding: const EdgeInsets.all(15),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           showWords = true;
//                           spokenWords =
//                               speechRecognition.startSpeechRecognition();
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           elevation: 4,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(75))),
//                       child: Container(
//                         padding: const EdgeInsets.all(5),
//                         alignment: Alignment.center,
//                         height: 120,
//                         child: const Column(children: [
//                           Icon(
//                             Icons.volume_up_outlined,
//                             color: Colors.white,
//                             size: 44.0,
//                           ),
//                           Text(
//                             'Speak',
//                             style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           )
//                         ]),
//                       ),
//                     )),
//               ],
//             ),
//             FutureBuilder(
//                 future: spokenWords,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return Container(
//                       padding: const EdgeInsets.all(15),
//                       child: Text(
//                         showWords
//                             ? 'Nothing Said ${snapshot.data}'
//                             : 'Say something',
//                         style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: showWords ? Colors.blue : Colors.red),
//                       ),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Text(
//                       '${snapshot.error}',
//                       style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red),
//                     );
//                   }
//                   // By default, show a loading spinner.
//                   return Container(
//                       alignment: Alignment.center,
//                       height: 10.0,
//                       child: const CircularProgressIndicator());
//                 }),
//             Expanded(
//                 child: Container(
//               color: showWords ? Colors.blue : Colors.red,
//             ))
//           ],
//         ));
//   }
// }
//
// AppBar _buildAppBar() {
//   return AppBar(
//       backgroundColor: Colors.black,
//       elevation: 0,
//       title: Row(children: [
//         Container(
//           padding: const EdgeInsets.all(15),
//           child: const Text(
//             'Bonga Nami',
//             style: TextStyle(
//                 fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         )
//       ]));
// }

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
  late SpeechRecognition speechRecognition;
  late TextToSpeech textToSpeech;

  @override
  void initState() {
    super.initState();
    speechRecognition = SpeechRecognition();
    speechRecognition.initializeSpeechRecognition();
    textToSpeech = TextToSpeech();
  }

  // Start speech recognition and get the result
  Future<void> _startRecognition() async {
    setState(() {
      isListening = true;
      spokenWords = ''; // Clear previous spoken words
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
        spokenWords = 'Error: $e';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
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
                    onPressed: () {},
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
                            Icons.volume_up_outlined,
                            color: Colors.white,
                            size: 44.0,
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
              spokenWords.isNotEmpty
                  ? 'You said: $spokenWords'
                  : isListening
                      ? 'Listening...'
                      : 'Press and hold to speak',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: spokenWords.isNotEmpty ? screenColor : Colors.red,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: spokenWords.isNotEmpty ? screenColor : Colors.red,
            ),
          ),
        ],
      ),
    );
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
            'Bonga Nami',
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
