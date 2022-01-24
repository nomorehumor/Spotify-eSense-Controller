import 'package:esense_todos/todos/controllers/todo_gestures_handler.dart';
import 'package:esense_todos/utils/text_speaker.dart';
import 'package:esense_todos/todos/models/todo.dart';
import 'package:esense_todos/todos/models/todolist.dart';
import 'dart:developer' as dev;

class TodoController {

  TextSpeaker _tts = TextSpeaker();
  ToDoGestureHandler toDoGestureHandler = ToDoGestureHandler();

  late CurrentToDoList currentToDoList;
  late DoneToDoList doneToDoList;

  TodoController(this.currentToDoList, this.doneToDoList);

  Future speakText(String text) async {
    await _tts!.awaitCompletion();
    dev.log("Processing $text");
    _tts!.setVoiceText(text);
    await _tts!.speak();
  }

  void addToDo(ToDo newToDo) {
    if (newToDo.name.isEmpty) return;
    currentToDoList.add(newToDo);
  }

  void checkToDo(bool check, int id) {
    currentToDoList.checkDone(id, true);

    ToDo checked = currentToDoList.getToDoWithId(id);
    currentToDoList.remove(checked);
    doneToDoList.add(checked);
  }

  void uncheckToDo(bool check, int id) {
    doneToDoList.checkDone(id, false);

    ToDo unchecked = doneToDoList.getToDoWithId(id);
    doneToDoList.remove(unchecked);
    currentToDoList.add(unchecked);
  }

  Future playTodos() async {                 
    // AudioPlayer player = AudioPlayer();
    
    for (int i = 0; i < currentToDoList.count(); i++) {
      ToDo todo = currentToDoList.getToDoWithIndex(i);
      dev.log("Playing todo with index $i");
      
      currentToDoList.highlightTodo(i);
      await speakText(todo.name);
      ToDoAction action = await toDoGestureHandler.waitForActions(3000);
      dev.log("action: $action");

      if (action == ToDoAction.done) {
        checkToDo(true, todo.id);
        await Future.delayed(const Duration(milliseconds: 500), () {});
        i -= 1;
      } 
    }
    currentToDoList.removeHighlight();
  }
}