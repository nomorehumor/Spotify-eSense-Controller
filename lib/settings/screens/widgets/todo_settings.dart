import 'package:flutter/material.dart';

class ToDoSettings extends StatefulWidget {
  const ToDoSettings({ Key? key }) : super(key: key);

  @override
  _ToDoSettingsState createState() => _ToDoSettingsState();
}

class _ToDoSettingsState extends State<ToDoSettings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        // Text("Todosettings here")
      ],
    );
  }
}