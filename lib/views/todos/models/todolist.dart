import 'todo.dart';
import 'package:flutter/material.dart';

class ToDoList extends ChangeNotifier {
  List<ToDo> todoList = [];
  String name;
  int highlighted = -1;

  ToDoList({required this.name});

  ToDo getToDo(int index) {
    return todoList[index];
  }

  ToDo getToDoWithId(int id) {
    return todoList.where((todo) => todo.id == id).first;
  }

  ToDo getToDoWithIndex(int index) {
    return todoList[index];
  }

  List<ToDo> getToDoList() {
    return todoList;
  }

  int count() {
    return todoList.length;
  }

  void add(ToDo todo) {
    todoList.add(todo);
    notifyListeners();
  }

  void remove(ToDo todo) {
    todoList.remove(todo);
    notifyListeners();
  }

  void checkDone(int id, bool done) {
    getToDoWithId(id).isDone = done;
    notifyListeners();
  }

  // void setFocus(int id, bool inFocus) {
  //   getToDoWithId(id).inFocus = inFocus;
  // }

  void highlightTodo(int index) {
    for (int i = 0; i < count(); i++) {
      if (i != index) {
        todoList[i].inFocus = false;
      } else {
        todoList[i].inFocus = true;
      }
    }
    highlighted = index;
    notifyListeners();
  }

  void removeHighlight() {
    for (int i = 0; i < count(); i++) {
      todoList[i].inFocus = true;
    }
    highlighted = -1;
    notifyListeners();
  }
}

class CurrentToDoList extends ToDoList {
  CurrentToDoList() : super(name: "Current") {
    todoList = [ToDo(name: "init current", isDone: false, id: 0)];
  }
}

class DoneToDoList extends ToDoList {
  DoneToDoList() : super(name: "Done") {
    todoList = [ToDo(name: "init done", isDone: true, id: 0)];
  }
}