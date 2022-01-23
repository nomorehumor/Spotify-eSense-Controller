import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'todos/models/todolist.dart';
import 'todos/screens/todolistview.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final getIt = GetIt.instance;
  late TodoListView listView;

  @override
  void initState() {
    super.initState();
    listView = const TodoListView();

    getIt.registerSingleton<CurrentToDoList>(CurrentToDoList(), signalsReady: true);
    getIt.registerSingleton<DoneToDoList>(DoneToDoList(), signalsReady: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: listView
      );
  }

  /// current position.
}
