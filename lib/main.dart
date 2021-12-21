import 'package:esense_application/compass.dart';
import 'package:esense_application/headset/gesture_classifier.dart';
import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'headset/esense_handler.dart';
import 'compass.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late EsenseHandler handler = EsenseHandler(
      esenseName: 'eSense-0099',
      onEvent: onEvent,
      onConnectedChange: onConnectedChange);
  late EsenseGestureClassifier gestureClassifier = EsenseGestureClassifier();

  bool _connected = false;

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

  void onEvent(SensorEvent event) {
    gestureClassifier.handleEvent(event);
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
        child: ListView(children: [
          // Text('eSense Device Status: \t$_deviceStatus'),
          // Text('eSense Device Name: \t$_deviceName'),
          // Text('eSense Battery Level: \t$_voltage'),
          // Text('eSense Button Event: \t$_button'),
          // Text(''),
          Text(_event),
          Text("Connected: $_connected"),
          Container(
            height: 80,
            width: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: TextButton.icon(
              onPressed: handler.connectToESense,
              icon: const Icon(Icons.login),
              label: const Text(
                'CONNECT....',
                style: TextStyle(fontSize: 35),
              ),
            ),
          )
        ]),
      ),
    ));
  }
}
