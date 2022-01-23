import 'package:esense_flutter/esense.dart';
import 'package:esense_todos/headset/controllers/esense_handler.dart';
import 'package:flutter/material.dart';

class HeadsetSettings extends StatefulWidget {
  const HeadsetSettings({ Key? key }) : super(key: key);

  @override
  _HeadsetSettingsState createState() => _HeadsetSettingsState();
}

class _HeadsetSettingsState extends State<HeadsetSettings> {

  bool _connected = false;

  @override
  void initState() {
    EsenseController.instance.esenseName = 'eSense-0382';
    EsenseController.instance.startListenToESense();
    EsenseController.instance.setConnectionHandler((event) => {
      setState(() {
        _connected = (event.type == ConnectionType.connected);
      })
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Connected: $_connected"),
            ElevatedButton(
              onPressed: EsenseController.instance.connectToESense,
              child: const Text("CONNECT"))
          ],
        ),
      ),
    );
  }
}