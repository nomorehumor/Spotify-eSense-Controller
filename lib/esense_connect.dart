import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';

import 'headset/esense_handler.dart';
import 'headset/gesture_classifier.dart';
import 'headset/models/gesture.dart';

class EsenseConnectionWidget extends StatefulWidget {
  const EsenseConnectionWidget({ Key? key }) : super(key: key);

  @override
  _EsenseConnectionWidgetState createState() => _EsenseConnectionWidgetState();
}

class _EsenseConnectionWidgetState extends State<EsenseConnectionWidget> {

  bool _connected = false;
  String _event = "No events yet";
  String _info = "no info";

  late EsenseHandler handler = EsenseHandler(
      esenseName: 'eSense-0099',
      onEvent: handleEvent,
      onConnectedChange: onConnectedChange);
  late EsenseGestureClassifier gestureClassifier = EsenseGestureClassifier(
      maxHistoryLength: 200, onGestureClassified: handleGesture);


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

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 80,
          // width: 200,
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
        
    ]);
  }
}