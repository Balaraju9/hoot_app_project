// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hoot/Constants/Colors.dart';
import 'package:hoot/Constants/loaders.dart';
import 'package:hoot/Utils/google_tts.dart';
import 'package:hoot/Utils/google_stt.dart';
import 'package:hoot/Utils/single_review.dart';
import 'package:http/http.dart' as http;

//Global Variable
List<dynamic> globalAttempts = [];

//IOS PLATFORM
class ShortAnswerAndroid extends StatefulWidget {
  const ShortAnswerAndroid({super.key});

  @override
  State<ShortAnswerAndroid> createState() => _ShortAnswerAndroidState();
}

//ENTIRE CODE
class _ShortAnswerAndroidState extends State<ShortAnswerAndroid> {
  late GoogleSTT speechService;
  List<dynamic> apiMAPS = [];
  List<String> apiONLYQUESTIONS = [];
  List<String> apiONLYCORRECTANSWERS = [];
  List<String> apiONLYANSWERS = [];
  late final int finalDURATION;
  late int totalquestion;
  late int timerSecond_container;
  bool isLoading = true;
  bool isCompleted = false;
  bool isCompletedButton = false;
  //APP INTIALIZATIONS
  int currentquestion = 1;
  int indexOfSpeechQuestion = 0;
  bool isFirstContainerActive = true;
  bool isSecondContainerActive = false;
  Timer? _secondContainerTimer;
  int _countdownValue = 0;
  Timer? _timer;
  bool _isBlurred = false;
  late GoogleTextToSpeechService ttsService;
  List<String> second_container_list = [];
  List<int> accuracyList = [];
  List<int> fluencyList = [];
  List<int> vocabularyList = [];
  String setid = '';
  String averageAccuracy = '';
  String averageFluency = '';
  String averageVocabulary = '';
  String durationOfQuestions = '';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _secondContainerTimer?.cancel();
    speechService.dispose();
    super.dispose();
  }

  //init state with async
  void initializeData() async {
    await getQuestionData();
    ttsService = GoogleTextToSpeechService(
      onStart: () {
        setState(() {
          isFirstContainerActive = true;
          isSecondContainerActive = false;
        });
      },
      onCompletion: () {
        setState(() {
          isFirstContainerActive = false;
        });
        _startCountdown();
      },
    );
    speechService = GoogleSTT(
      second_container_list: second_container_list,
      currentquestion: currentquestion,
    );

    // Listen for changes
    speechService.addListener(() {
      setState(() {});
    });
    speak();
    if (currentquestion <= totalquestion) {
      second_container_list.add(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? noData() : yesData(context);
  }

  Scaffold noData() {
    return Scaffold(
      body: Center(
        child: Loaders.circleLottieLoader(),
      ),
    );
  }

  Scaffold yesData(BuildContext context) {
    return Scaffold(
      //APPBAR
      appBar: AppBar(
        title: const Text(
          "Short Answer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.logoGreen,
      ),
      //ENTIRE BODY
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //INSTRUCTIONS
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Instructions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "You will listen to a question and you must answer in 1 or 2 words",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
              ],
            ),
            //QUESTIONS FOR PROGRESS BAR
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Questions: ",
                        style: TextStyle(
                            color: Colors
                                .black), // Default color for "Questions: "
                      ),
                      TextSpan(
                        text:
                            // "${currentquestion.toString().padLeft(2, '0')}/$totalquestion",
                            '$currentquestion/$totalquestion',
                        style: const TextStyle(
                            color: Color(0xFF3C8844), // Green color for "1/10"
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
            //PROGRESS BAR
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: SizedBox(
                          height: 10,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                                begin: 0, end: currentquestion / totalquestion),
                            duration: const Duration(seconds: 1),
                            builder: (context, value, _) =>
                                LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.orange[300],
                              color: const Color.fromARGB(255, 60, 136, 68),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
            //BIG GREEN CONTAINER
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.lighterShade, // Light green background
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.logoGreen,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FIRST CONTAINER
                  Padding(
                    padding: const EdgeInsets.only(left: 5, bottom: 5),
                    child: Text('Listen',
                        style: TextStyle(
                            color: AppColors.coolgrey,
                            fontWeight: FontWeight.bold)),
                  ),
                  AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: isFirstContainerActive
                          ? Border.all(color: Colors.grey)
                          : Border.all(color: Colors.grey),
                      boxShadow: getBoxShadow(isFirstContainerActive),
                      color: isFirstContainerActive
                          ? const Color(0xFFFDF7FE)
                          : const Color(0xFFFDF7FE),
                    ),
                    duration: const Duration(milliseconds: 1100),
                    height: 50,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Row(
                        children: [
                          isFirstContainerActive
                              ? const SizedBox(
                                  width: 50, child: Icon(Icons.volume_up_sharp))
                              // Image.asset('assets/speaker_bg.png'))
                              : const SizedBox(
                                  width: 50, child: Icon(Icons.volume_off)),
                          Center(
                            child: isFirstContainerActive
                                ? Loaders.audioWaveLottieLoader()
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SECOND CONTAINER WITH BLUR
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                        child: Text('Speak',
                            style: TextStyle(
                                color: AppColors.coolgrey,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      //TIMER ICON

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 90,
                          padding: const EdgeInsets.only(
                              top: 3, bottom: 3, left: 5, right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.logoGreen,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.timer, color: Colors.white),
                              const SizedBox(width: 5),
                              (_countdownValue > 0 ||
                                      isFirstContainerActive ||
                                      isSecondContainerActive == false)
                                  ? RichText(
                                      text: const TextSpan(
                                        children: [
                                          // TextSpan(
                                          //   text: '00',
                                          //   style: TextStyle(
                                          //     color: Colors.red,
                                          //   ),
                                          // ),
                                          TextSpan(
                                            text: '    -',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          // TextSpan(
                                          //   text: '00',
                                          //   style: TextStyle(
                                          //     color: Colors.red,
                                          //   ), // Color for the last '00'
                                          // ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      '00:${timerSecond_container.toString().padLeft(2, '0')}',
                                      style:
                                          const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SECOND CONTAINER
                  AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: isSecondContainerActive
                          ? Border.all(color: Colors.grey)
                          : Border.all(color: Colors.grey),
                      boxShadow: getBoxShadow(isSecondContainerActive),
                      color: isSecondContainerActive
                          ? const Color(0xFFFDF7FE)
                          : const Color(0xFFFDF7FE),
                    ),
                    duration: const Duration(milliseconds: 0),
                    height: 280,
                    width: double.infinity,
                    //BLUR
                    child: Stack(
                      children: [
                        // Countdown Overlay
                        if (_countdownValue > 0) // Show only during countdown
                          const Center(
                            child: AnimatedOpacity(
                              opacity: 1,
                              duration: Duration(milliseconds: 500),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 6),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: _isBlurred ? 2 : 0,
                              sigmaY: _isBlurred ? 2 : 0,
                            ),
                            child: Container(
                              height: 45,
                              width: double.infinity,
                              color: Colors.transparent,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: Row(
                                  children: [
                                    (_isBlurred == false &&
                                            isFirstContainerActive == false &&
                                            isSecondContainerActive == true)
                                        ? const SizedBox(
                                            width: 40, child: Icon(Icons.mic))
                                        // Image.asset('assets/mic_bg.png'))
                                        : const SizedBox(
                                            width: 40,
                                            child: Icon(Icons.mic_off)),
                                    (_isBlurred == false &&
                                            isFirstContainerActive == false &&
                                            isSecondContainerActive == true)
                                        ? Loaders.audioWaveLottieLoader()
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 51,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: 300,
                            //LIST OF ANSWERS LISTENED
                            child: ListView.builder(
                              physics: _isBlurred
                                  ? const NeverScrollableScrollPhysics()
                                  : null,
                              itemCount: second_container_list.length,
                              itemBuilder: (context, index) {
                                debugPrint('$second_container_list');
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: ImageFiltered(
                                    imageFilter: ImageFilter.blur(
                                      sigmaX: _isBlurred ? 2 : 0,
                                      sigmaY: _isBlurred ? 2 : 0,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 13),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "${index + 1}. ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            TextSpan(
                                              text:
                                                  (currentquestion - 1 == index)
                                                      ? second_container_list[
                                                              index] +
                                                          speechService
                                                              .pendingTranscript
                                                      : second_container_list[
                                                          index],
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

            ),
            //BUTTON
            isCompleted
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isCompletedButton = true;
                          });

                          await getAnalysisData();
                          await completeSubmit();

                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SingleReview(setid: setid)),
                          );
                          isCompletedButton = false;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.logoGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          elevation: 3,
                        ),
                        child: SizedBox(
                          width: 55,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: isCompletedButton
                                    ? SizedBox(
                                        height: 50,
                                        width: 30,
                                        child: Loaders.circleLottieLoader())
                                    : const Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
//---------------------------------------------------

//---------------------------------------------------
//--------------------------------------------------------
  //Getting the Data from API
  getQuestionData() async {
    String url =
        'http://node.technicalhub.io:4001/api/shortanswer-random-question';
    final response =
        await http.post(Uri.parse(url), body: {"roll_no": "2000000018"});
    final body = jsonDecode(response.body);
    setState(() {
      apiMAPS = body['set'];
      finalDURATION = body['duration'];
      setid = body['_id'];
    });
    for (var item in apiMAPS) {
      apiONLYQUESTIONS.add(item['Q']);
      apiONLYCORRECTANSWERS.add(item['A']);
    }
    totalquestion = apiONLYQUESTIONS.length;
    timerSecond_container = finalDURATION;
    isLoading = false;
  }

  getAnalysisData() async {
    String url = 'http://node.technicalhub.io:4001/api/shortanswer-analysis';
    final response = await http.post(Uri.parse(url), body: {
      "question": apiONLYQUESTIONS[indexOfSpeechQuestion],
      "answer": second_container_list[indexOfSpeechQuestion]
    });
    final body = jsonDecode(response.body);
    accuracyList.add(body['accuracy']);
    vocabularyList.add(body['vocabulary']);
    fluencyList.add(body['fluency']);
  }

  putSubmitData() async {
    String url = 'http://node.technicalhub.io:4001/api/shortanswer-submitTest';
    final response = await http.post(Uri.parse(url), body: {
      "set_id": setid,
      "roll_no": "22A86A6720",
      "accuracy": averageAccuracy,
      "vocabulary": averageVocabulary,
      "grammatical_errors": "0",
      "fluency": averageFluency,
      "duration": durationOfQuestions
    });
    debugPrint(response.body);
    debugPrint(accuracyList.toString());
  }

  completeSubmit() async {
    int length = accuracyList.length;
    int a_sum = 0;
    int f_sum = 0;
    int v_sum = 0;
    for (int i = 0; i < length; i++) {
      a_sum += accuracyList[i];
      f_sum += fluencyList[i];
      v_sum += vocabularyList[i];
    }
    averageAccuracy = (a_sum / length).toStringAsFixed(2);
    averageFluency = (f_sum / length).toStringAsFixed(2);
    averageVocabulary = (v_sum / length).toStringAsFixed(2);
    durationOfQuestions = (finalDURATION * length).toString();
    debugPrint(
        'Set ID = $setid \nAverage Accuracy = $averageAccuracy\nAverage Fluency = $averageFluency\nAverage Vocabulary = $averageVocabulary');
    await putSubmitData();
  }

//--------------------------------------------------------
  //Text To Speech(Google_TTs)
  speak() async {
    speechService.transcriptionHistory = "";
    await ttsService.speak(apiONLYQUESTIONS[indexOfSpeechQuestion]);
    _secondContainerTimer?.cancel();
  }

  //3 second timer
  void _startCountdown() {
    setState(() {
      _countdownValue = 3;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownValue > 1) {
        setState(() {
          _isBlurred = true;
          _countdownValue--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isBlurred = false;
          _countdownValue = 0;
          isSecondContainerActive = true;
        });
        //After timer is done start listening to the user
        _startSecondContainerTimer();
        speechService.startTranscribingStream();
      }
    });
  }

  //10 second timer
  void _startSecondContainerTimer() {
    setState(() {
      //resetting each time before using
      timerSecond_container = finalDURATION;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (timerSecond_container > 0) {
        setState(() {
          timerSecond_container--;
        });
      } else {
        timer.cancel();
        setState(() {
          isSecondContainerActive = false;
        });

        await speechService.stopTranscribingStream(); //Stop listening
        Future.delayed(const Duration(seconds: 1));
        autoNextQuestion(); //Move to the next question
      }
    });
  }

  // Method to move to the next question after a delay
  Future<void> autoNextQuestion() async {
    if (currentquestion == totalquestion) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _isBlurred = true;
        isCompleted = true;
      });
    }

    if (currentquestion < totalquestion) {
      getAnalysisData();
      Future.delayed(const Duration(seconds: 1), () {
        nextQuestion();
      });
    }
  }

  //changing question
  void nextQuestion() {
    setState(() {
      if (indexOfSpeechQuestion < apiONLYQUESTIONS.length - 1) {
        indexOfSpeechQuestion++;
      } else {
        indexOfSpeechQuestion = 0;
      }
      if (currentquestion < totalquestion) {
        currentquestion++;
        if (currentquestion <= totalquestion) {
          second_container_list.add('-');
        }
        second_container_list[currentquestion - 1] = '';
      }
    });
    speechService = GoogleSTT(
      second_container_list: second_container_list,
      currentquestion: currentquestion,
    );
    speak();
  }

  //Box Shadow Widget
  List<BoxShadow> getBoxShadow(bool isActiveContainer) {
    return [
      BoxShadow(
        color: isActiveContainer ? Colors.grey : Colors.transparent,
        offset: isActiveContainer ? const Offset(0.0, 2.0) : const Offset(0, 0),
        blurRadius: isActiveContainer ? 3.0 : 0,
        spreadRadius: isActiveContainer ? 2.0 : 0,
      ),
    ];
  }
}
