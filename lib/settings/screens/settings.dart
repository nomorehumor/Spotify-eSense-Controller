import 'package:esense_todos/settings/screens/widgets/headset_settings.dart';
import 'package:esense_todos/settings/screens/widgets/todo_settings.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: ListView(
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: HeadsetSettings(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: ToDoSettings(),
            )
          ],
        ),
      ),
    );
  }
}