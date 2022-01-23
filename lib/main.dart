import 'todos/models/todolist.dart';
import 'todos/screens/todolistview.dart';
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
