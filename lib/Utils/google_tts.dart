// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class GoogleTextToSpeechService {
  final String apiKey = 'removed_the_api_cuz_that_is_not_legal_balu';
  final String url =
      'https://texttospeech.googleapis.com/v1beta1/text:synthesize';
  final AudioPlayer _audioPlayer = AudioPlayer();

  Function? onStart;
  Function? onCompletion;

  GoogleTextToSpeechService({this.onStart, this.onCompletion}) {
    //triggering start handler
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        if (onStart != null) onStart!();
      }
    });

    //triggering completion handler
    _audioPlayer.onPlayerComplete.listen((event) {
      if (onCompletion != null) onCompletion!();
    });
  }

  Future<void> speak(String text) async {
    try {
      var uri = Uri.parse('$url?key=$apiKey');
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'input': {'text': text},
          'voice': {
            'languageCode': 'en-US',
            'name': 'en-US-Polyglot-1',
            'ssmlGender': 'MALE',
          },
          'audioConfig': {
            'audioEncoding': 'MP3',
          },
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final audioContent = responseData['audioContent'];
        Uint8List audioBytes = base64Decode(audioContent);
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/temp_audio.mp3';
        File audioFile = File(tempPath);
        await audioFile.writeAsBytes(audioBytes);

        _audioPlayer.onPlayerComplete.listen((event) {
          // Handle completion
        });

        await _audioPlayer.play(DeviceFileSource(audioFile.path));
      } else {
        print('Error: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

/*

  speak() async {
    await _flutterTts.setLanguage('en-US');
    // second_container_list[currentquestion - 1] = '';
    await _flutterTts.speak(DummyData().li[indexOfSpeechQuestion]);
    _flutterTts.setStartHandler(() {
      setState(() {
        isFirstContainerActive = true;
        // second_container_list[currentquestion - 1] = '';
        isSecondContainerActive = false;
      });
    });
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isFirstContainerActive = false;
      });
      _startCountdown(); // Start countdown when speech completes
    });
    _secondContainerTimer?.cancel();
  }
  */
