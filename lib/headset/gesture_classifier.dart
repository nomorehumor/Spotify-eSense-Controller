import 'package:esense_flutter/esense.dart';
import 'package:vector_math/vector_math.dart';

class EsenseGestureClassifier {
  EsenseGestureClassifier({
    required this.maxHistoryLength,
  });

  Function? onNodClassified;

  final maxHistoryLength;
  List<Vector3> accelerometerHistory = [];
  List<Vector3> gyroscopeHistory = [];

  void handleEvent(SensorEvent event) {
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
      accelerometerHistory.add(vector);
    }

    classifyNod();
  }

  void classifyNod() {
    bool classified = false;
    if (accelerometerHistory.last.x >= 15000) {
      if (onNodClassified != null) onNodClassified!();
    }
  }
}
