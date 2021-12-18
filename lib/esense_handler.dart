import 'package:esense_flutter/esense.dart';
import 'dart:async';
import 'dart:developer' as developer;

class EsenseHandler {
  EsenseHandler({required this.esenseName, this.onEvent, this.onConnectedChange});

  Function(String)? onEvent;
  Function(bool)? onConnectedChange;

  String esenseName = '';
  bool _connected = false;

  double _voltage = -1;
  bool _button_pressed = false;

  bool _sampling = false;
  String _event = '';

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
        _listenToESenseEvents();
        _connected = true;
        onConnectedChange!(_connected);
      } else {
        _connected = false;
      }
    });
  }

  void _getESenseProperties() async {
    // get the battery level every 10 secs
    Timer.periodic(
      const Duration(seconds: 10),
      (timer) async =>
          (_connected) ? await ESenseManager().getBatteryVoltage() : null,
    );

    // wait 2, 3, 4, 5, ... secs before getting the name, offset, etc.
    // it seems like the eSense BTLE interface does NOT like to get called
    // several times in a row -- hence, delays are added in the following calls
    Timer(const Duration(seconds: 2),
        () async => await ESenseManager().getDeviceName());
    Timer(const Duration(seconds: 3),
        () async => await ESenseManager().getAccelerometerOffset());
    Timer(
        const Duration(seconds: 4),
        () async =>
            await ESenseManager().getAdvertisementAndConnectionInterval());
    Timer(const Duration(seconds: 5),
        () async => await ESenseManager().getSensorConfig());
  }

  void _listenToESenseEvents() async {
    ESenseManager().eSenseEvents.listen((event) {
      developer.log('ESENSE event: $event');

      onEvent!(event.toString());

      switch (event.runtimeType) {
        // case DeviceNameRead:
        //   _deviceName = (event as DeviceNameRead).deviceName ?? 'Unknown';
        //   break;
        case BatteryRead:
          _voltage = (event as BatteryRead).voltage ?? -1;
          break;
        case ButtonEventChanged:
          _button_pressed = (event as ButtonEventChanged).pressed;

          break;
        case AccelerometerOffsetRead:
          // TODO
          break;
        case AdvertisementAndConnectionIntervalRead:
          // TODO
          break;
        case SensorConfigRead:
          // TODO
          break;
      }
    });

    _getESenseProperties();
  }

  // void _startListenToSensorEvents() async {
  //   // subscribe to sensor event from the eSense device
  //   subscription = ESenseManager().sensorEvents.listen((event) {
  //     developer.log('SENSOR event: $event');
  //     _event = event.toString();
  //   });
  //   _sampling = true;
  // }

  void pauseListenToSensorEvents() async {
    subscription?.cancel();
    _sampling = false;
  }

  void close() {
    pauseListenToSensorEvents();
    ESenseManager().disconnect();
  }
}
