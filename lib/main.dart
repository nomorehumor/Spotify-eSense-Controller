import 'package:flutter/material.dart';
import 'esense_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late EsenseHandler handler = EsenseHandler(onEvent: onEvent);

  String _event = "";
  bool connected = false;

  @override
  void initState() {
    super.initState();
    handler.listenToESense();
  }

  @override
  void dispose() {
    handler.close();
    super.dispose();
  }

  void onEvent(String event) {
    setState(() {
      _event = event;
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
            // Text('eSense Device Status: \t$_deviceStatus'),
            // Text('eSense Device Name: \t$_deviceName'),
            // Text('eSense Battery Level: \t$_voltage'),
            // Text('eSense Button Event: \t$_button'),
            // Text(''),
            Text(_event),
            Container(
              height: 80,
              width: 200,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: TextButton.icon(
                onPressed: handler.connectToESense,
                icon: const Icon(Icons.login),
                label: const Text(
                  'CONNECT....',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
