import 'dart:async';
import 'package:audio_manager/audio_manager.dart';
import 'package:audio_service/audio_service.dart';
import 'package:esense_application/esense_connect.dart';
import 'package:flutter/foundation.dart';

import 'package:esense_application/headset/charts_widget.dart';
import 'package:esense_application/headset/gesture_classifier.dart';
import 'package:esense_application/headset/models/gesture.dart';
import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'headset/esense_handler.dart';
import 'player.dart';

late AudioHandler _audioHandler;

void main() async {
  
  _audioHandler = await AudioService.init(
    builder: () => AppAudioHandler(),
    config: const AudioServiceConfig(
      // androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      // androidNotificationChannelName: 'Music playback',
    ),
  );
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String playbackState = "no state";

  void initState() {
    initTts();
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('eSense Demo App'),
          ),
          body: Center(
            child: Column(
              children: [
                const EsenseConnectionWidget(),
                Text(playbackState),
                
              ]
            ),
          )
        ),
    );
  }

  /// current position.
}
