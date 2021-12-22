class Gesture {
  DateTime timestamp;
  GestureType type;
  Gesture({required this.timestamp, required this.type});
}

enum GestureType {
  nod,
  rorateRight,
  rotateLeft,
  startLongRotateRight,
  endLongRotateRight,
  startLongRotateLeft,
  endLongRotateLeft,
  tiltRight,
  tiltLeft
}
