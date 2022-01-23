import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'dart:developer' as dev;


enum TextSpeakerState { playing, stopped, paused, continued }

class TextSpeaker {
  late FlutterTts flutterTts;
  TextSpeakerState state = TextSpeakerState.stopped;
  String? _newVoiceText = "hello";

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  get isPlaying => state == TextSpeakerState.playing;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  TextSpeaker() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage('en');

    flutterTts.setVolume(volume);
    flutterTts.setSpeechRate(rate);
    flutterTts.setPitch(pitch);

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
    }
  }

  void setVoiceText(String text) {
    _newVoiceText = text;
  }

  Future speak() async {
    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }

  void onComplete() {
    dev.log("completed utterance");
  }

  Future awaitCompletion() async {
    flutterTts.setCompletionHandler(onComplete);
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future stop() async {
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
      dev.log(engine);
    }
  }
}
