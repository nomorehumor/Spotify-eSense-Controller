import 'dart:async';

import 'package:esense_todos/headset/controllers/esense_handler.dart';
import 'package:esense_todos/headset/controllers/gesture_classifier.dart';
import 'package:esense_todos/headset/models/gesture.dart';
import 'package:esense_todos/todos/screens/todolistview.dart';

class ToDoGestureHandler {
  late EsenseGestureClassifier gestureClassifier;
  late EsenseController esenseHandler;

  List<Gesture> recognizedGestures = [];

  ToDoGestureHandler() {
    gestureClassifier = EsenseGestureClassifier(maxHistoryLength: 200, onGestureClassified: addGesture);
  }

  Future<ToDoAction> waitForActions(int durationMilliseconds) async {
    recognizedGestures = [];
    Future.delayed(Duration(milliseconds: durationMilliseconds));
    return classifyAction();
  }

  ToDoAction classifyAction() {
    for (int i = 0; i < recognizedGestures.length; i++) {
      if (recognizedGestures[i] == GestureType.nod) {
        return ToDoAction.done;
      }
    }
    return ToDoAction.notDone;
  }

  void addGesture(Gesture gesture) {
    recognizedGestures.add(gesture);
  }

}