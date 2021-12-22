import 'package:flutter/material.dart';
import 'package:esense_flutter/esense.dart';
import '../stream_chart/chart_legend.dart';
import '../stream_chart/stream_chart.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ChartsWidget extends StatefulWidget {
  const ChartsWidget({Key? key}) : super(key: key);

  @override
  _ChartsWidgetState createState() => _ChartsWidgetState();
}

class _ChartsWidgetState extends State<ChartsWidget> {

  List<double> _handleAccelerator(SensorEvent event) {
    if (event.accel != null) {
      return [
        event.accel![0].toDouble(),
        event.accel![1].toDouble(),
        event.accel![2].toDouble(),
      ];
    } else {
      return [];
    }
  }

  List<double> _handleGyroscope(SensorEvent event) {
    if (event.gyro != null) {
      return [
        event.gyro![0].toDouble(),
        event.gyro![1].toDouble(),
        event.gyro![2].toDouble(),
      ];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: StreamChart<SensorEvent>(
          stream: ESenseManager().sensorEvents,
          handler: _handleAccelerator,
          maxValue: 10000,
          minValue: -10000,
          timeRange: const Duration(seconds: 10),
        ),
      ),
    );
  }
}
