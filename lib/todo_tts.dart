import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

enum TtsState { playing, stopped, paused, continued }

class TodoTts {
  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  String? _newVoiceText = "hello";

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  get isPlaying => ttsState == TtsState.playing;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  TodoTts(Function completionHandler) {
    flutterTts = FlutterTts();    
    flutterTts.setLanguage('en');

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setCompletionHandler(() {
      completionHandler();
    });
  }

  void setVoiceText(String text) {
    _newVoiceText = text;
  }

  Future speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }

  Future stop() async{
    await flutterTts.stop();
  }

  Future<dynamic> getEngines() => flutterTts.getEngines;
  Future<dynamic> getLanguages() => flutterTts.getLanguages;

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }
}