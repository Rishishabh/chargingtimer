
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

void main() {
  runApp(const ChargingTimerApp());
}

class ChargingTimerApp extends StatelessWidget {
  const ChargingTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charging Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChargingTimerHomePage(),
    );
  }
}

class ChargingTimerHomePage extends StatefulWidget {
  const ChargingTimerHomePage({super.key});

  @override
  State<ChargingTimerHomePage> createState() => _ChargingTimerHomePageState();
}

class _ChargingTimerHomePageState extends State<ChargingTimerHomePage> {
  final Battery _battery = Battery();
  BatteryState? _batteryState;
  Timer? _timer;
  int _chargingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
      _handleBatteryState(state);
    });

    _initializeBatteryState();
  }

  Future<void> _initializeBatteryState() async {
    final BatteryState initialState = await _battery.batteryState;
    setState(() {
      _batteryState = initialState;
    });
    _handleBatteryState(initialState);
  }

  void _handleBatteryState(BatteryState state) {
    if (state == BatteryState.charging) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _chargingSeconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final String statusText = _batteryState == BatteryState.charging
        ? "Charging"
        : _batteryState == BatteryState.full
            ? "Full"
            : "Not Charging";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Charging Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Battery Status: $statusText',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            Text(
              'Charging Time:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 10),
            Text(
              _formatDuration(_chargingSeconds),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
