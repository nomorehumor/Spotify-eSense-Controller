import 'dart:developer' as dev;
import 'dart:core';
import 'dart:math';

import 'package:esense_flutter/esense.dart';
import 'package:vector_math/vector_math.dart';
import '../models/gesture.dart';
import 'package:statistics/statistics.dart';

extension VectorOperations on List<Vector3> {

  Vector3 sum() {
    Vector3 sum = Vector3(0,0,0);
    forEach((element) {
      sum += element;
    });
    return sum;
  }

  Vector3 mean() {
    Vector3 vectorSum = sum();
    return Vector3(vectorSum.x / length.toDouble(),
                    vectorSum.y / length.toDouble(),
                    vectorSum.z / length.toDouble());
  }

  Vector3 std() {
    Vector3 vectorMean = mean();
    Vector3 squaredSum = Vector3(0,0,0);
    forEach((element) {
      Vector3 demeaned = element - vectorMean;
      squaredSum += Vector3(demeaned.x.square, demeaned.y.square, demeaned.z.square);
    });

    Vector3 variance = squaredSum / length.toDouble();
    return Vector3(variance.x.squareRoot, variance.y.squareRoot, variance.z.squareRoot);
  }
}

class EsenseGestureClassifier {
  EsenseGestureClassifier({
    required this.maxHistoryLength,
    this.onGestureClassified
  });

  Function? onGestureClassified;

  final maxHistoryLength;
  List<Vector3> accelerometerHistory = [];
  List<Vector3> gyroscopeHistory = [];
  Vector3 movingAccelMean = Vector3(0,0,0);
  Vector3 movingGyroMean = Vector3(0,0,0);
  Vector3 movingAccelStdDeviation = Vector3(0,0,0);
  Vector3 movingGyroStdDeviation = Vector3(0,0,0);

  void handleEvent(SensorEvent event) {

    // Check history length
    if (accelerometerHistory.length == maxHistoryLength) {
      accelerometerHistory.removeFromBegin(1);
    }
    if (gyroscopeHistory.length == maxHistoryLength) {
      gyroscopeHistory.removeFromBegin(1);
    }

    // Add values to the history
    if (event.accel != null) {
      Vector3 vector = Vector3(
        event.accel![0].toDouble(),
        event.accel![1].toDouble(),
        event.accel![2].toDouble(),
      );
      accelerometerHistory.add(vector);
    }

    if (event.gyro != null) {
      Vector3 vector = Vector3(
        event.gyro![0].toDouble(),
        event.gyro![1].toDouble(),
        event.gyro![2].toDouble(),
      );
      gyroscopeHistory.add(vector);
    }

    // Calculate stats
    movingAccelMean = accelerometerHistory.mean();
    movingGyroMean = gyroscopeHistory.mean();
    movingAccelStdDeviation = accelerometerHistory.std();
    movingGyroStdDeviation = gyroscopeHistory.std();

    dev.log("Accel mean: $movingAccelMean,"
            "Gyro mean: $movingGyroMean, "
            "Accel std: $movingAccelStdDeviation,"
            "Gyro std: $movingGyroStdDeviation");


    classifyNod();
    classifyRotateRight();
  }

  void classifyNod() {
    if (gyroscopeHistory.isNotEmpty && gyroscopeHistory.last.z.abs() > movingGyroStdDeviation.z*3) {
      if (onGestureClassified != null){ 
        dev.log("RECOGNIZED NOD");
        Gesture gesture = Gesture(timestamp: DateTime.now(), type: GestureType.nod);
        onGestureClassified!(gesture);
      }
    }
  }

  void classifyRotateRight() {
    if (gyroscopeHistory.isNotEmpty && gyroscopeHistory.last.x > movingGyroStdDeviation.x*2) {
      if (onGestureClassified != null){ 
        dev.log("RECOGNIZED ROTATE RIGHT");
        Gesture gesture = Gesture(timestamp: DateTime.now(), type: GestureType.rorateRight);
        onGestureClassified!(gesture);
      }
    }
  }
}
