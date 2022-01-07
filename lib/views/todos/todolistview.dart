import 'package:esense_todos/views/todos/models/todolist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/todo.dart';
import 'models/todolist.dart';
import 'widgets/todo_textfield.dart';
import 'widgets/todo_listtile.dart';
import 'dart:developer' as dev;

class TodoListView extends StatefulWidget {
  const TodoListView({ Key? key, this.processText, this.todoActionDetector}) : super(key: key);

  final Function(String)? processText;
  final Function? todoActionDetector;

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

enum ToDoAction {done, notDone}

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

  void onStartPlay() {    
    playTodos();
  }

  void playTodos() async {
    ToDoList todoList = Provider.of<CurrentToDoList>(context, listen: false);
    for (int i = 0; i < todoList.count(); i++) {
      ToDo todo = todoList.getToDoWithIndex(i);
      dev.log("Playing todo with index $i");
      
      todoList.highlightTodo(i);
      await widget.processText!(todo.name);
      ToDoAction action = widget.todoActionDetector!();
      
      if (action == ToDoAction.done) {
        _onCheck(true, todo.id);
        i -= 1;
      } else if (action == ToDoAction.notDone) {

      }
    }
    todoList.removeHighlight();
  }

  void highlightTodo(ToDo todo) {
    
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
                onTap: onStartPlay,
                child: const Icon(
                  Icons.play_arrow
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