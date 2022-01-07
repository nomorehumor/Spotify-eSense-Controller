import 'package:esense_application/screens/models/todolist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/todo.dart';
import 'widgets/todo_textfield.dart';
import 'widgets/todo_listtile.dart';
import 'dart:io';

class TodoListView extends StatefulWidget {
  TodoListView({ Key? key, this.processText}) : super(key: key);

  final Function(String)? processText;

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  // final List<ToDo> _currentTodos = [ToDo(name: "first", isDone: false, id: 0)];
  // final List<ToDo> _doneTodos = [ToDo(name: "first done", isDone: true, id: 0)];

  bool _playingTodos = false;
  int _playingIndex = -1;

  void _showTextField(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ToDoTextField(onFinish: _addCurrentToDo);
      },
    );
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

  // void onStartPlay() {
  //   if (_currentTodos.isEmpty) return;
  //   _playingIndex = 0;   
  //   _playingTodos = true;
    
  //   playTodos(_playingIndex)
  // }

  // bool playNextTodo() {
  //   _playingIndex += 1;

  //   if (_playingIndex == _currentTodos.length) {
  //     _playingTodos = false;
  //     return false;
  //   }
    
  //   playTodo(_playingIndex);
  //   return true;
  // }

  // void playTodos(int index) {
  //   print("playing todo with index $index");
  //   highlightTodo(index);
  //   widget.processText!(_currentTodos[index].name);
  // }

  // void highlightTodo(int index) {
  //   print("highlight $index");

  //   setState(() {
  //     for (int i = 0; i < _currentTodos.length; i++) {
  //       if (i != index) {
  //         _currentTodos[i].inFocus = false;
  //       } else {
  //         _currentTodos[i].inFocus = true;
  //       }
  //     }
  //   });
  // }

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
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 20.0),
          //     child: GestureDetector(
          //       onTap: onStartPlay,
          //       child: const Icon(
          //         Icons.play_arrow
          //       ),
          //     ),
          //   )
          // ],
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