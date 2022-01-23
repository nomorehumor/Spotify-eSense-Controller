import 'package:esense_flutter/esense.dart';
import 'dart:async';
import 'dart:developer' as developer;

class EsenseController {

  // Singleton class
  EsenseController._privateConstructor();
  static final EsenseController _instance = EsenseController._privateConstructor();
  static EsenseController get instance => _instance;

  String _esenseName = '';
  bool _connected = false;

  StreamSubscription? subscription;

  set esenseName(String esenseName) {
    _esenseName = esenseName;
  }

  bool isConnected() {
    return _connected;
  }

  StreamSubscription setEventHandler(Function(SensorEvent)? onEvent) {
    return ESenseManager().sensorEvents.listen(onEvent);
  }

  StreamSubscription setConnectionHandler(Function(ConnectionEvent)? onConnection) {
    return ESenseManager().connectionEvents.listen(onConnection);
  } 

  Future connectToESense() async {
    developer.log('connecting... connected: $_connected');
    if (!_connected) {
      _connected = await ESenseManager().connect(_esenseName);
    }
  }

  Future startListenToESense() async {
    // if you want to get the connection events when connecting,
    // set up the listener BEFORE connecting...
    ESenseManager().connectionEvents.listen((event) {
      developer.log('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) {
        _connected = true;
      } else {
        _connected = false;
      }
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
