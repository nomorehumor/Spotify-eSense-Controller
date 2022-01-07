import 'package:esense_todos/headset/esense_handler.dart';
import 'package:esense_todos/headset/gesture_classifier.dart';
import 'package:esense_todos/todo_gestures_handler.dart';
import 'views/todos/models/todolist.dart';
import 'views/todos/todolistview.dart';
import 'todo_tts.dart';
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

  String eSenseName = 'eSense-0099';

  late TodoTts tts;
  late TodoListView listView;
  ToDoGestureHandler toDoGestureHandler = ToDoGestureHandler();

  @override
  void initState() {
    super.initState();
    tts = TodoTts();
    listView = TodoListView(processText: speakText, todoActionDetector: recognizeActionFromGesture);

    EsenseHandler.instance.startListenToESense();
    EsenseHandler.instance.esenseName = eSenseName;
    EsenseHandler.instance.connectToESense();
  }

  void speakText(String text) async {
    await tts.awaitCompletion();
    print("Processing $text");
    tts.setVoiceText(text);
    await tts.speak();
  }

  Future<ToDoAction> recognizeActionFromGesture() async {
    return await toDoGestureHandler.waitForActions(2000);
  }

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
