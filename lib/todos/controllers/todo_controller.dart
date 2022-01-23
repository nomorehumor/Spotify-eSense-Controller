import 'package:esense_todos/utils/text_speaker.dart';
import 'package:esense_todos/todos/models/todo.dart';
import 'package:esense_todos/todos/models/todolist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoController {

  TextSpeaker? _tts;

  TodoController() {
    _tts = TextSpeaker();
  }

  void speakText(String text) async {
    await _tts!.awaitCompletion();
    print("Processing $text");
    _tts!.setVoiceText(text);
    await _tts!.speak();
  }

  void addCurrentToDo(ToDo newToDo) {
    if (newToDo.name.isEmpty) return;
    // Provider.of<CurrentToDoList>(context, listen: false).add(newToDo);
  }
}