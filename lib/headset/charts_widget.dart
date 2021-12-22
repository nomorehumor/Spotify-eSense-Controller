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
  List<double> zero = [0.0, 0.0, 0.0];
  List<double> currentAbsPosition = [0.0, 0.0, 0.0];
  List<double> currentPosition = [0.0, 0.0, 0.0];

  List<double> _handleAccelerator(SensorEvent event) {
    if (event.accel != null) {
      currentAbsPosition = [
        event.accel![0].toDouble(),
        event.accel![1].toDouble(),
        event.accel![2].toDouble(),
      ];

      return currentAbsPosition;
    } else {
      return [];
    }
  }

  List<double> _handleGyroscope(SensorEvent event) {
    if (event.gyro != null) {
      currentAbsPosition = [
        event.gyro![0].toDouble(),
        event.gyro![1].toDouble(),
        event.gyro![2].toDouble(),
      ];

      return currentAbsPosition;
    } else {
      return [];
    }
  }

  void calibrate() {
    setState(() {
      zero = currentAbsPosition;
    });
  }

  void getPosition() {
    setState(() {
      currentPosition = [
        currentAbsPosition[0] - zero[0],
        currentAbsPosition[1] - zero[1],
        currentAbsPosition[2] - zero[2]
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
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
      ),
      const ChartLegend(label: "Acceleration"),
    ]);
  }
}
