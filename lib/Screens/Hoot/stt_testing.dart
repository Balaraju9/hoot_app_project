import 'dart:io'show Platform;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

class MyTTSTesting extends StatefulWidget {
  const MyTTSTesting({super.key});

  @override
  State<MyTTSTesting> createState() => _MyTTSTestingState();
}

class _MyTTSTestingState extends State<MyTTSTesting> {
  FlutterTts flutterTts = FlutterTts();

  String numbers = "1 2 3 4 5 6 7 8 9 0";

  String specialChar = "! @ # % ^ & * () . , ? /  \\";

  String errors = "null undefined";

  String script =
      "At Technical Hub, we prioritize excellence in training, offering certification-aligned programs in collaboration with industry-leading vendors. Our tranees benefit from hands-on learning experiences, receiving constant exposure to practical examples across a spectrum of topics. This approach ensures they remain at the forefront of the ever-evolving technological landscape, equipped with the skills and knowledge necessary to excel in their fields.";

  List<String> types = ["numbers", "specialChar", "errors", "script"];

  List<Map<String, dynamic>> voices = [
    {"name": "es-us-x-sfb-local", "locale": "en-US"},
    {"name": "en-us-x-tpf-local", "locale": "en-US"},
    {"name": "en-AU-language", "locale": "en-US"},
    {"name": "en-us-x-sfg-network", "locale": "en-US"},
    {"name": "en-au-x-aud-local", "locale": "en-US"},
    {"name": "en-in-x-ene-network", "locale": "en-US"},
    {"name": "en-au-x-aua-network", "locale": "en-US"},
    {"name": "en-GB-language", "locale": "en-US"},
    {"name": "en-gb-x-gba-network", "locale": "en-US"},
    {"name": "en-us-x-sfg-local", "locale": "en-US"},
    {"name": "en-IN-language", "locale": "en-US"},
    {"name": "en-in-x-enc-network", "locale": "en-US"},
    {"name": "en-gb-x-gbc-network", "locale": "en-US"},
    {"name": "en-gb-x-gbc-local", "locale": "en-US"},
    {"name": "en-US-language", "locale": "en-US"},
    {"name": "en-in-x-end-local", "locale": "en-US"},
    {"name": "en-in-x-end-network", "locale": "en-US"},
    {"name": "en-in-x-enc-local", "locale": "en-US"},
    {"name": "en-in-x-ena-network", "locale": "en-US"},
    {"name": "en-NG-language", "locale": "en-US"},
    {"name": "en-ng-x-tfn-network", "locale": "en-US"},
    {"name": "en-us-x-iob-local", "locale": "en-US"},
    {"name": "en-us-x-iob-network", "locale": "en-US"},
    {"name": "en-us-x-iol-network", "locale": "en-US"},
    {"name": "en-us-x-iom-network", "locale": "en-US"},
    {"name": "en-us-x-iom-local", "locale": "en-US"},
    {"name": "en-gb-x-gba-local", "locale": "en-US"}
  ];

  String typeTag = "script";
  String voiceTag = "en-IN-language";

  @override
  void initState() {
    super.initState();
    configureTts();

    flutterTts.setCompletionHandler(() {
      debugPrint('Speech synthesis completed');
    });

    flutterTts.setErrorHandler((message) {
      debugPrint('Error occurred: $message');
    });
  }

  @override
  void dispose() {
    super.dispose();
    stopSpeaking();
  }

  Future<void> configureTts() async {
    if (Platform.isIOS) {
      debugPrint("IOS config");
      await flutterTts.setSharedInstance(true);
      await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions.allowAirPlay,
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
      );
    }
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setVoice({"name": voiceTag, "locale": "en-US"});
    await flutterTts.setSpeechRate(.5);
    setState(() {});
  }

  void speakText() async {
    await configureTts();
    await flutterTts.speak(scriptSelectionType());
  }

  String scriptSelectionType() {
    if (typeTag == "script") {
      return script;
    } else if (typeTag == "errors") {
      return errors;
    } else if (typeTag == "special characters") {
      return specialChar;
    } else if (typeTag == "numbers") {
      return numbers;
    }
    return script;
  }

  void stopSpeaking() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: DropdownMenu(
              dropdownMenuEntries: types
                  .map<DropdownMenuEntry>(
                      (e) => DropdownMenuEntry(value: e, label: e))
                  .toList(),
              onSelected: (val) {
                setState(() {
                  typeTag = "$val";
                  voiceTag = "";
                });
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          DropdownMenu(
            dropdownMenuEntries: voices
                .map<DropdownMenuEntry>((e) => DropdownMenuEntry(
                    value: "${e["name"]}", label: "${e["name"]}"))
                .toList(),
            onSelected: (val) {
              setState(() {
                voiceTag = val;
                debugPrint(typeTag);
                debugPrint(voiceTag);
              });
              speakText();
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            speakText();
          },
          child: const Icon(Icons.play_arrow)),
    );
  }
}
