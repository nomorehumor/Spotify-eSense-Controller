import 'dart:async';

import 'package:esense_application/headset/charts_widget.dart';
import 'package:esense_application/headset/gesture_classifier.dart';
import 'package:esense_application/headset/models/gesture.dart';
import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'headset/esense_handler.dart';

void main() => runApp(MyApp());

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
      if (gesture.type == GestureType.nod) {
        _info = "nod";
        Timer(Duration(seconds: 1), () {
          if (_info != "no info") _info = "no info";
        });
      }
    });
  }

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
        ]),
      ),
    ));
  }
}
