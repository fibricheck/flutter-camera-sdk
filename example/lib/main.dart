import 'package:camera_sdk/fibricheck_view.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:camera_sdk_example/0_design_system/fc_colors.dart';
import 'package:camera_sdk_example/5_ui/widgets/fc_title.dart';
import 'package:camera_sdk_example/5_ui/widgets/fc_metrics.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Start Measurement'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
    title: 'Fibricheck Example',
    home: StartScreen(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void>? _requestCameraPermission;

  bool _hasCameraPermission = false;

  String _timeRemaining = "-";
  String _heartBeat = "-";
  String _status = "Place your finger on the camera";

  @override
  initState() {
    super.initState();
    _requestCameraPermission = _requestCameraPermissionImpl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Measurement'),
        ),
        body: Column(children: [
          Expanded(
            child: FutureBuilder(
              future: _requestCameraPermission,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const DemoTitleWidget(
                      title: "Requiring camera permission");
                }

                if (!_hasCameraPermission) {
                  return const DemoTitleWidget(
                      title: "Camera permission not granted");
                }
                return Column(
                  children: [
                    DemoTitleWidget(title: _status),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: FCColors.lightGray, width: 1),
                          bottom:
                              BorderSide(color: FCColors.lightGray, width: 1),
                        ),
                      ),
                      height: 200,
                      child: FibriCheckView(
                        fibriCheckViewProperties: FibriCheckViewProperties(
                            flashEnabled: true,
                            lineThickness: 2,
                            // graphBackgroundColor: '#${FCColors.green.value.toRadixString(16)}'
                            drawGraph: true,
                            lineColor:
                                '#${FCColors.bordeaux.value.toRadixString(16)}',
                            drawBackground: true,
                            sampleTime: 15,
                            gravEnabled: false,
                            gyroEnabled: false,
                            accEnabled: false,
                            rotationEnabled: false,
                            movementDetectionEnabled: true,
                            fingerDetectionExpiryTime: -1,
                            pulseDetectionExpiryTime: 10,
                            waitForStartRecordingSignal: false),
                        onCalibrationReady: () => {
                          debugPrint("Flutter onCalibrationReady"),
                          setState(() {
                            _status = "Recording heartbeat...";
                          }),
                        },
                        onFingerDetected: () => {
                          WakelockPlus.enable(),
                          debugPrint("Flutter onFingerDetected"),
                          setState(() {
                            _status = "Detecting pulse...";
                          }),
                        },
                        onFingerDetectionTimeExpired: () =>
                            debugPrint("Flutter onFingerDetectionTimeExpired"),
                        onFingerRemoved: (y, v, stdDevY) => {
                          WakelockPlus.disable(),
                          debugPrint(
                              "Flutter onFingerRemoved $y, $v, $stdDevY"),
                        },
                        onHeartBeat: (heartbeat) => {
                          debugPrint("Flutter onHeartBeat $heartbeat"),
                          setState(() {
                            _heartBeat = heartbeat.toString();
                          }),
                        },
                        onMeasurementFinished: () => {
                          debugPrint("Flutter onMeasurementFinished"),
                          setState(() {
                            _status = "Measurement finished!";
                          }),
                        },
                        onMeasurementProcessed: (measurement) => {
                          debugPrint(
                              "Flutter onMeasurementProcessed $measurement"),
                        },
                        onMeasurementStart: () =>
                            debugPrint("Flutter onMeasurementStart"),
                        onMovementDetected: () =>
                            debugPrint("Flutter onMovementDetected"),
                        onPulseDetected: () => {
                          debugPrint("Flutter onPulseDetected"),
                          setState(() {
                            _status = "Calibrating...";
                          }),
                        },
                        onPulseDetectionTimeExpired: () =>
                            debugPrint("Flutter onPulseDetectionTimeExpired"),
                        onSampleReady: (ppg, raw) => {},
                        //debugPrint("Flutter onSampleReady $ppg $raw"), -> prints often. Only uncomment when data is relevant
                        onTimeRemaining: (seconds) => {
                          debugPrint("Flutter onTimeRemaining $seconds"),
                          setState(() {
                            _timeRemaining = seconds.toString();
                          }),
                        },
                        onMeasurementError: (message) =>
                            debugPrint("Flutter onMeasurementError: $message"),
                      ),
                    ),
                    DemoMetricsWidget(
                        timeRemaining: _timeRemaining, heartBeat: _heartBeat),
                  ],
                );
              },
            ),
          ),
        ]));
  }

  Future<void> _requestCameraPermissionImpl() async {
    var result = await Permission.camera.request();
    setState(() {
      _hasCameraPermission = result.isGranted;
    });
  }
}
