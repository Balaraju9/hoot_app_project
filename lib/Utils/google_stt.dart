// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:record/record.dart';

class GoogleSTT extends ChangeNotifier {
  final AudioRecorder _recordAudio = AudioRecorder();
  StreamSubscription? _audioStreamSubscription;
  late StreamController<List<int>> audioStreamController;

  String transcript = "";
  String pendingTranscript = "";
  String lastTranscript = "";
  String transcriptionHistory = "";
  bool isStreaming = false;

  List<String> second_container_list;
  int currentquestion;

  GoogleSTT({
    required this.second_container_list,
    required this.currentquestion,
  });

  Future<void> startTranscribingStream() async {
    // print('CURRENT QUESTION START - $currentquestion');
    try {
      if (!await _recordAudio.hasPermission()) {
        print("No microphone permission");
        return;
      }

      //old setstate
      isStreaming = true;
      audioStreamController = StreamController<List<int>>.broadcast();
      notifyListeners();

      // Initialize Google Speech-to-Text
      final serviceAccount = ServiceAccount.fromString(
          await rootBundle.loadString('assets/test_service_account.json'));
      SpeechToText speechToText =
          SpeechToText.viaServiceAccount(serviceAccount);

      // Configure recognition
      final config = RecognitionConfig(
        enableAutomaticPunctuation: true,
        enableSpokenPunctuation: true,
        encoding: AudioEncoding.LINEAR16,
        sampleRateHertz: 16000,
        languageCode: 'en-US',
      );
      final streamingConfig = StreamingRecognitionConfig(
        config: config,
        interimResults: true,
      );

      // Get the stream of raw audio data
      final Stream<Uint8List> audioStream =
          await _recordAudio.startStream(const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ));
      final broadcastStream = audioStream.asBroadcastStream();
      await _audioStreamSubscription?.cancel();

      // Listen to the audio stream and send it to Google Speech-to-Text
      _audioStreamSubscription = broadcastStream.listen(
        (data) {
          if (!audioStreamController.isClosed) {
            audioStreamController.add(data.toList());
          }
        },
        onError: (error) {
          print('Audio stream error: $error');
          stopTranscribingStream();
        },
      );

      // Start recognition
      final responseStream = speechToText.streamingRecognize(
        streamingConfig,
        audioStreamController.stream,
      );
      responseStream.listen(
        (data) {
          for (var result in data.results) {
            if (result.isFinal) {
               pendingTranscript = '';
              transcriptionHistory += result.alternatives.first.transcript;
              second_container_list[currentquestion - 1] = transcriptionHistory;

              transcript = '';
            } else {
              pendingTranscript = '...';
              transcript = result.alternatives.first.transcript;
            }
            notifyListeners();
          }
        },
        onError: (error) {
          print('Recognition error: $error');
          stopTranscribingStream();
        },
      );
    } catch (e) {
      print('Error starting transcription: $e');
      await stopTranscribingStream();
    }
  }

  Future<void> stopTranscribingStream() async {
    // print('CURRENT QUESTION STOP - $currentquestion');
    try {
      isStreaming = false;
      transcriptionHistory += transcript;
      second_container_list[currentquestion - 1] = transcriptionHistory;
      transcript = "";
      pendingTranscript = '';
      notifyListeners();

      await _audioStreamSubscription?.cancel();
      await _recordAudio.stop();

      if (!audioStreamController.isClosed) {
        await audioStreamController.close();
      }
    } catch (e) {
      print('Error stopping transcription: $e');
    }
  }
}

double getRandomValue() {
  Random random = Random();
  return double.parse((1 + random.nextDouble() * 99).toStringAsFixed(2));
}
