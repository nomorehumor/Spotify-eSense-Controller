import 'dart:async';

import 'package:esense_todos/headset/esense_handler.dart';
import 'package:esense_todos/headset/gesture_classifier.dart';
import 'package:esense_todos/headset/models/gesture.dart';
import 'package:esense_todos/views/todos/todolistview.dart';

class ToDoGestureHandler {
  late EsenseGestureClassifier gestureClassifier;
  late EsenseHandler esenseHandler;

  List<Gesture> recognizedGestures = [];

  ToDoGestureHandler() {
    gestureClassifier = EsenseGestureClassifier(maxHistoryLength: 200, onGestureClassified: addGesture);
    EsenseHandler.instance.onEvent = gestureClassifier.handleEvent;
  }

  Future<ToDoAction> waitForActions(int durationMilliseconds) async {
    recognizedGestures = [];
    EsenseHandler.instance.startListenToSensorEvents();
    Future.delayed(Duration(milliseconds: durationMilliseconds));
    EsenseHandler.instance.pauseListenToSensorEvents();
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