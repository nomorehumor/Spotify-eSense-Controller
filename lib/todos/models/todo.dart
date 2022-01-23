import 'package:flutter/material.dart';

class ToDo {
  String name;
  bool isDone;
  int id;
  bool inFocus = true;

  set setIsDone(bool isDone) {
    this.isDone = isDone;
  }  

  set setInFocus(bool inFocus) {
    this.inFocus = inFocus;
  }

  get getName => name;
  get getInFocus => inFocus;
  get getIsDone => isDone;

  ToDo({required this.name, required this.isDone, required this.id});
}
