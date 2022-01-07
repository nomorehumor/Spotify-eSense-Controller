import 'package:esense_application/screens/models/todolist.dart';
import 'package:esense_application/screens/todolistview.dart';
import 'package:esense_application/todo_tts.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late TodoTts tts;
  late TodoListView listView;

  @override
  void initState() {
    super.initState();
    tts = TodoTts();
    listView = TodoListView(processText: speakText);
  }

  void speakText(String text) async {
    await tts.awaitCompletion();
    print("Processing $text");
    tts.setVoiceText(text);
    await tts.speak();
  }

  // void continueTodoPlayack() {
  //   listView.
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => CurrentToDoList(),
            ),
            ChangeNotifierProvider(
              create: (_) => DoneToDoList(),
            )
          ],
          child: listView
        )
      );
  }

  /// current position.
}
