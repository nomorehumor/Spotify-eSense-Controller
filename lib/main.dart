import 'package:esense_todos/headset/controllers/esense_handler.dart';
import 'package:esense_todos/headset/controllers/gesture_classifier.dart';
import 'package:esense_todos/todos/controllers/todo_gestures_handler.dart';
import 'todos/models/todolist.dart';
import 'todos/screens/todolistview.dart';
import 'text_to_speech/text_speaker.dart';
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

  late TodoListView listView;

  @override
  void initState() {
    super.initState();
    listView = const TodoListView();
  }

  // Future<ToDoAction> recognizeActionFromGesture() async {
  //   // return await toDoGestureHandler.waitForActions(2000);
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
