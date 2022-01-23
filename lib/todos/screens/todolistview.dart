import 'package:esense_todos/headset/screens/headset_settings.dart';
import 'package:esense_todos/utils/text_speaker.dart';
import 'package:esense_todos/todos/models/todolist.dart';
import 'package:flutter/material.dart';
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

enum ToDoAction {done, notDone}

class _TodoListViewState extends State<TodoListView> {

  // bool _playingTodos = false;
  // int _playingIndex = -1;

  TextSpeaker textSpeaker = TextSpeaker();
  ToDoGestureHandler toDoGestureHandler = ToDoGestureHandler();


  void _showTextField(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ToDoTextField(onFinish: _addCurrentToDo);
      },
    );
  }

  void _onSettingsCalled() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HeadsetSettings()));
  }

  void _addCurrentToDo(ToDo newToDo) {
    if (newToDo.name.isEmpty) return;
    Provider.of<CurrentToDoList>(context, listen: false).add(newToDo);
  }

  void _onCheck(bool check, int id) {
    CurrentToDoList currentToDoList = Provider.of<CurrentToDoList>(context, listen: false);
    currentToDoList.checkDone(id, true);

    ToDo checked = currentToDoList.getToDoWithId(id);
    currentToDoList.remove(checked);
    Provider.of<DoneToDoList>(context, listen: false).add(checked);
  }

  void _onUncheck(bool check, int id) {
    DoneToDoList doneToDoList = Provider.of<DoneToDoList>(context, listen: false);
    doneToDoList.checkDone(id, false);

    ToDo unchecked = doneToDoList.getToDoWithId(id);
    doneToDoList.remove(unchecked);
    Provider.of<CurrentToDoList>(context, listen: false).add(unchecked);
  }


  void _onStartPlay() {    
    _playTodos();
  }

  void _playTodos() async {                 
    ToDoList todoList = Provider.of<CurrentToDoList>(context, listen: false);
    
    for (int i = 0; i < todoList.count(); i++) {
      ToDo todo = todoList.getToDoWithIndex(i);
      dev.log("Playing todo with index $i");
      
      todoList.highlightTodo(i);
      await speakText(todo.name);
      ToDoAction action = await toDoGestureHandler.waitForActions(3000);
      
      if (action == ToDoAction.done) {
        _onCheck(true, todo.id);
        i -= 1;
      } else if (action == ToDoAction.notDone) {

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
            Consumer<CurrentToDoList>(
              builder: (context, list, child) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: list.count(),
                  itemBuilder: (BuildContext context, int index) {
                    return ToDoListTile(
                      todo: list.getToDo(index),
                      onCheck: _onCheck,
                    );
                  }
                );
              },
            ),
            Consumer<DoneToDoList>(
              builder: (context, list, child) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: list.count(),
                  itemBuilder: (BuildContext context, int index) {
                    return ToDoListTile(
                      todo: list.getToDo(index),
                      onCheck: _onUncheck,
                    );
                  }
                );
              },
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