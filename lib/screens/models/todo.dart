import 'package:flutter/material.dart';

class ToDo {
  String name;
  bool isDone;
  int id;
  bool inFocus = true;


  get getIsDone => isDone;

  set setIsDone( isDone) {
    this.isDone = isDone;
  }  

  get getInFocus => inFocus;

  set setInFocus( inFocus) {
    this.inFocus = inFocus;
  }

  ToDo({required this.name, required this.isDone, required this.id});
}
