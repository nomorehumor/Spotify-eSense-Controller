import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

enum TtsState { playing, stopped, paused, continued }

class TodoTts {
  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  String? _newVoiceText;


  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
    }
  }

  Future<dynamic> _getEngines() => flutterTts.getEngines;

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }
}