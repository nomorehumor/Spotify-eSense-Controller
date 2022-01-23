import 'package:esense_todos/settings/screens/widgets/headset_settings.dart';
import 'package:esense_todos/settings/screens/settings.dart';
import 'package:esense_todos/utils/text_speaker.dart';
import 'package:esense_todos/todos/models/todolist.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../controllers/todo_gestures_handler.dart';
import '../models/todo.dart';
import '../models/todolist.dart';
import 'widgets/todo_textfield.dart';
import 'widgets/todo_listtile.dart';
import 'dart:developer' as dev;

class TodoListView extends StatefulWidget {
  const TodoListView({ Key? key }) : super(key: key);


  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {

  final getIt = GetIt.instance;
  TextSpeaker textSpeaker = TextSpeaker();
  ToDoGestureHandler toDoGestureHandler = ToDoGestureHandler();

  @override
  void initState() {
    getIt
        .isReady<CurrentToDoList>()
        .then((_) => getIt<CurrentToDoList>().addListener(update));

    getIt
        .isReady<DoneToDoList>()
        .then((_) => getIt<DoneToDoList>().addListener(update));
  }

  void _showTextField(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ToDoTextField(onFinish: _addCurrentToDo);
      },
    );
  }

  void _onSettingsCalled() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
  }

  void _addCurrentToDo(ToDo newToDo) {
    if (newToDo.name.isEmpty) return;
    getIt<CurrentToDoList>().add(newToDo);
  }

  void _onCheck(bool check, int id) {
    CurrentToDoList currentToDoList = getIt<CurrentToDoList>();
    currentToDoList.checkDone(id, true);

    ToDo checked = currentToDoList.getToDoWithId(id);
    currentToDoList.remove(checked);
    getIt<DoneToDoList>().add(checked);
  }

  void _onUncheck(bool check, int id) {
    DoneToDoList doneToDoList = getIt<DoneToDoList>();
    doneToDoList.checkDone(id, false);

    ToDo unchecked = doneToDoList.getToDoWithId(id);
    doneToDoList.remove(unchecked);
    getIt<CurrentToDoList>().add(unchecked);
  }

  void update() => setState(() => {});

  void _onStartPlay() async{    
    await _playTodos();
  }

  Future _playTodos() async {                 
    ToDoList todoList = getIt.get<CurrentToDoList>();
    
    for (int i = 0; i < todoList.count(); i++) {
      ToDo todo = todoList.getToDoWithIndex(i);
      dev.log("Playing todo with index $i");
      
      todoList.highlightTodo(i);
      await speakText(todo.name);
      ToDoAction action = await toDoGestureHandler.waitForActions(1500);
      print("action: $action");

      if (action == ToDoAction.done) {
        _onCheck(true, todo.id);
        i -= 1;
      } 
    }
    todoList.removeHighlight();
  }

  Future speakText(String text) async {
    await textSpeaker.awaitCompletion();
    print("Processing $text");
    textSpeaker.setVoiceText(text);
    await textSpeaker.speak();
  }

  @override
  Widget build(BuildContext context) {
    final currentTodos = getIt<CurrentToDoList>();
    final doneTodos = getIt<DoneToDoList>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TODOs"),
          backgroundColor: Colors.black87,
          bottom: const TabBar(
            indicatorColor: Color(0xFFBB86FC),
            tabs: [
              Tab(text: "Current"),
              Tab(text: "Done",)
            ]
            // overlayColor: MaterialStateProperty<Color>,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _onStartPlay,
                child: const Icon(
                  Icons.play_arrow
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _onSettingsCalled,
                child: const Icon(
                  Icons.settings
                ),
              ),
            )
          ],
        ),
        body: TabBarView(
          children: [
            ValueListenableBuilder(
              valueListenable: currentTodos,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: getIt.get<CurrentToDoList>().count(),
                itemBuilder: (BuildContext context, int index) {
                  return ToDoListTile(
                    todo: currentTodos.getToDo(index),
                    onCheck: _onCheck,
                  );
                }
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: getIt.get<DoneToDoList>().count(),
              itemBuilder: (BuildContext context, int index) {
                return ToDoListTile(
                  todo: doneTodos.getToDo(index),
                  onCheck: _onUncheck,
                );
              }
            ),
          ]
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _showTextField(context),
          backgroundColor: const Color(0xFFBB86FC),
        ),
      ),
    );
  }
}