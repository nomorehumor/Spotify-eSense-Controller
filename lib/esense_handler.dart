import 'package:esense_flutter/esense.dart';
import 'dart:async';
import 'dart:developer' as developer;

class EsenseHandler {
  bool connected = false;
  String _deviceName = 'Unknown';
  double _voltage = -1;
  String _deviceStatus = '';
  String _button = 'not pressed';
  bool _sampling = false;
  String _event = '';
  String eSenseName = 'eSense-0099';

  EsenseHandler({required this.onEvent});

  Function(String) onEvent;

  StreamSubscription? subscription;

  Future connectToESense() async {
    developer.log('connecting... connected: $connected');
    if (!connected) connected = await ESenseManager().connect(eSenseName);

    _deviceStatus = connected ? 'connecting' : 'connection failed';
  }

  Future listenToESense() async {
    // if you want to get the connection events when connecting,
    // set up the listener BEFORE connecting...
    ESenseManager().connectionEvents.listen((event) {
      developer.log('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) _listenToESenseEvents();

      connected = false;
      switch (event.type) {
        case ConnectionType.connected:
          _deviceStatus = 'connected';
          connected = true;
          break;
        case ConnectionType.unknown:
          _deviceStatus = 'unknown';
          break;
        case ConnectionType.disconnected:
          _deviceStatus = 'disconnected';
          break;
        case ConnectionType.device_found:
          _deviceStatus = 'device_found';
          break;
        case ConnectionType.device_not_found:
          _deviceStatus = 'device_not_found';
          break;
      }
    });
  }

  void _getESenseProperties() async {
    // get the battery level every 10 secs
    Timer.periodic(
      const Duration(seconds: 10),
      (timer) async =>
          (connected) ? await ESenseManager().getBatteryVoltage() : null,
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

      switch (event.runtimeType) {
        case DeviceNameRead:
          _deviceName = (event as DeviceNameRead).deviceName ?? 'Unknown';
          break;
        case BatteryRead:
          _voltage = (event as BatteryRead).voltage ?? -1;
          break;
        case ButtonEventChanged:
          _button =
              (event as ButtonEventChanged).pressed ? 'pressed' : 'not pressed';
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

  void _startListenToSensorEvents() async {
    // subscribe to sensor event from the eSense device
    subscription = ESenseManager().sensorEvents.listen((event) {
      developer.log('SENSOR event: $event');
      _event = event.toString();
    });
    _sampling = true;
  }

  void pauseListenToSensorEvents() async {
    subscription?.cancel();
    _sampling = false;
  }

  void close() {
    pauseListenToSensorEvents();
    ESenseManager().disconnect();
  }
}
