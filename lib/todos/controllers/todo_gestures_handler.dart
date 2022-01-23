import 'dart:async';
import 'dart:developer' as dev;

import 'package:esense_todos/headset/controllers/esense_handler.dart';
import 'package:esense_todos/headset/controllers/gesture_classifier.dart';
import 'package:esense_todos/headset/models/gesture.dart';
import 'package:esense_todos/todos/screens/todolistview.dart';


enum ToDoAction {done, notDone}

class ToDoGestureHandler {
  late EsenseGestureClassifier gestureClassifier;
  late EsenseController esenseHandler;

  List<Gesture> recognizedGestures = [];

  StreamSubscription? gestureClassifierSubsription;

  ToDoGestureHandler() {
    gestureClassifier = EsenseGestureClassifier(maxHistoryLength: 200, onGestureClassified: addGesture);
  }

  Future<ToDoAction> waitForActions(int durationMilliseconds) async {
    recognizedGestures = [];

    if (EsenseController.instance.isConnected()) {
      gestureClassifierSubsription = EsenseController.instance.setEventHandler(gestureClassifier.handleEvent);
      gestureClassifierSubsription!.resume();
    }

    // Wait for gestures
    await Future.delayed(Duration(milliseconds: durationMilliseconds), () {});

    gestureClassifierSubsription!.cancel();
    return classifyAction();
  }

  ToDoAction classifyAction() {
    dev.log("total ${recognizedGestures.length} recognized");
    for (int i = 0; i < recognizedGestures.length; i++) {
      if (recognizedGestures[i].type == GestureType.nod) {
        return ToDoAction.done;
      }
    }
    return ToDoAction.notDone;
  }

  void addGesture(Gesture gesture) {
    recognizedGestures.add(gesture);
  }

}