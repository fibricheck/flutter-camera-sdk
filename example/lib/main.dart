import 'package:camera_sdk/fibri_check_view.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void>? _requestCameraPermission;

  bool _hasCameraPermission = false;

  @override
  initState() {
    super.initState();
    _requestCameraPermission = _requestCameraPermissionImpl();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fibricheck example app'),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _requestCameraPermission,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Requiring camera permission");
                  }

                  if (!_hasCameraPermission) {
                    return const Text("Camera permission not granted");
                  }

                  return FibriCheckView(
                    fibriCheckViewProperties: FibriCheckViewProperties(
                      flashEnabled: true,
                      lineThickness: 4,
                    ),
                    onCalibrationReady: () => debugPrint("Flutter onCalibrationReady"),
                    onFingerDetected: () => debugPrint("Flutter onFingerDetected"),
                    onFingerDetectionTimeExpired: () => debugPrint("Flutter onFingerDetectionTimeExpired"),
                    onFingerRemoved: () => debugPrint("Flutter onFingerRemoved"),
                    onHeartBeat: (heartbeat) => debugPrint("Flutter onHeartBeat $heartbeat"),
                    onMeasurementFinished: () => debugPrint("Flutter onMeasurementFinished"),
                    onMeasurementProcessed: (measurement) => debugPrint("Flutter onMeasurementProcessed $measurement"),
                    onMeasurementStart: () => debugPrint("Flutter onMeasurementStart"),
                    onMovementDetected: () => debugPrint("Flutter onMovementDetected"),
                    onPulseDetected: () => debugPrint("Flutter onPulseDetected"),
                    onPulseDetectionTimeExpired: () => debugPrint("Flutter onPulseDetectionTimeExpired"),
                    onSampleReady: (ppg, raw) => debugPrint("Flutter onSampleReady $ppg $raw"),
                    onTimeRemaining: (seconds) => debugPrint("Flutter onTimeRemaining $seconds"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestCameraPermissionImpl() async {
    var result = await Permission.camera.request();

    _hasCameraPermission = result.isGranted;
    setState(() {});
  }
}
