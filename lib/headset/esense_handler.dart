import 'package:esense_flutter/esense.dart';
import 'dart:async';
import 'dart:developer' as developer;

class EsenseHandler {
  EsenseHandler(
      {required this.esenseName, this.onEvent, this.onConnectedChange});

  Function(SensorEvent)? onEvent;
  Function(bool)? onConnectedChange;

  String esenseName = '';
  bool _connected = false;

  StreamSubscription? subscription;

  Future connectToESense() async {
    developer.log('connecting... connected: $_connected');
    if (!_connected) {
      _connected = await ESenseManager().connect(esenseName);
    }
    onConnectedChange!(_connected);
  }

  Future startListenToESense() async {
    // if you want to get the connection events when connecting,
    // set up the listener BEFORE connecting...
    ESenseManager().connectionEvents.listen((event) {
      developer.log('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) {
        _listenToSensorEvents();
        _connected = true;
        onConnectedChange!(_connected);
      } else {
        _connected = false;
      }
    });
  }

  void _listenToSensorEvents() async {
    ESenseManager().sensorEvents.listen((event) {
      developer.log('ESENSE event: $event');
      onEvent!(event);
    });
  }

  void pauseListenToSensorEvents() async {
    subscription?.cancel();
  }

  void close() {
    pauseListenToSensorEvents();
    ESenseManager().disconnect();
  }
}
