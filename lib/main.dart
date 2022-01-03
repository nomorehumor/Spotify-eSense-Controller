import 'dart:async';

import 'package:audio_service/audio_service.dart';
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
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
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
  late EsenseHandler handler = EsenseHandler(
      esenseName: 'eSense-0099',
      onEvent: handleEvent,
      onConnectedChange: onConnectedChange);
  late EsenseGestureClassifier gestureClassifier = EsenseGestureClassifier(
      maxHistoryLength: 200, onGestureClassified: handleGesture);

  bool _connected = false;
  String _event = "No events yet";
  String _info = "no info";

  @override
  void initState() {
    super.initState();
    handler.startListenToESense();
  }

  @override
  void dispose() {
    handler.close();
    super.dispose();
  }

  void onConnectedChange(bool connected) {
    setState(() {
      _connected = connected;
    });
  }

  void handleEvent(SensorEvent event) {
    setState(() {
      _event = event.toString();
    });
    gestureClassifier.handleEvent(event);
  }

  void handleGesture(Gesture gesture) {
    setState(() {
      switch(gesture.type) {
        case GestureType.nod:
          _info = "nod";
          Timer(Duration(seconds: 1), () {
            if (_info != "no info") _info = "no info";
          });
          break;

        case GestureType.rorateRight:
          _info = "rotate right";
          Timer(Duration(seconds: 1), () {
            if (_info != "no info") _info = "no info";
          });
          break;
      }
    });
  }

  IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
        icon: Icon(iconData),
        iconSize: 64.0,
        onPressed: onPressed,
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('eSense Demo App'),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: ListView(
          children: [
            Container(
              height: 80,
              width: 200,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: TextButton.icon(
                onPressed: handler.connectToESense,
                icon: const Icon(Icons.login),
                label: const Text(
                  'CONNECT',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
            Text(_event),
            Text("Connected: $_connected"),
            Text(_info),
            StreamBuilder<bool>(
              stream: _audioHandler.playbackState
                  .map((state) => state.playing)
                  .distinct(),
              builder: (context, snapshot) {
                final playing = snapshot.data ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(Icons.fast_rewind, _audioHandler.rewind),
                    if (playing)
                      _button(Icons.pause, _audioHandler.pause)
                    else
                      _button(Icons.play_arrow, _audioHandler.play),
                    _button(Icons.stop, _audioHandler.stop),
                    _button(Icons.fast_forward, _audioHandler.fastForward),
                  ],
                );
              },
            ),
        ]),
      ),
    ));
  }
}
