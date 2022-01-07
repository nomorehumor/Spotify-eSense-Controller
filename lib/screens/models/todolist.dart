import 'package:esense_application/screens/models/todo.dart';
import 'package:flutter/material.dart';

class ToDoList extends ChangeNotifier {
  List<ToDo> todoList = [];
  String name;

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
    todoList.where((element) => element.id == id).first.isDone = done;
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