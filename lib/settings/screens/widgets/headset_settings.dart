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
  String _headsetName = 'eSense-0382';

  @override
  void initState() {
    EsenseController.instance.esenseName = _headsetName;
    EsenseController.instance.startListenToESense();
    EsenseController.instance.setConnectionHandler((event) => {
      setState(() {
        _connected = (event.type == ConnectionType.connected);
      })
    });

  }

  void connect() {
    EsenseController.instance.esenseName = _headsetName;
    EsenseController.instance.connectToESense();
  }

  void onHeadsetNameChange(String text) {
    setState(() {
      _headsetName = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8.0, left: 14.0, right: 14.0), 
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text("Headset Settings", style: TextStyle(fontSize: 30),),
        ),
        Text("Connected: " + (_connected ? "✅" : "❌")),
        Text("Headset name: $_headsetName"),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: TextFormField(
            initialValue: _headsetName,
            onChanged: onHeadsetNameChange,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.black87),
            onPressed: connect,
            child: const Text("CONNECT")),
        )
      ],
    );
  }
}