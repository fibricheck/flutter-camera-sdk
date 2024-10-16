import 'dart:convert';

import 'package:flutter/services.dart';

import 'fibricheck_view.dart';

class FibriCheckViewEventController {
  static const String type = "eventType";

  static const String eventSampleReady = "onSampleReady";
  static const String eventFingerDetected = "onFingerDetected";
  static const String eventFingerRemoved = "onFingerRemoved";
  static const String eventCalibrationReady = "onCalibrationReady";
  static const String eventHeartBeat = "onHeartBeat";
  static const String eventTimeRemaining = "onTimeRemaining";
  static const String eventMeasurementFinished = "onMeasurementFinished";
  static const String eventMeasurementStart = "onMeasurementStart";
  static const String eventFingerDetectionTimeExpired = "onFingerDetectionTimeExpired";
  static const String eventPulseDetected = "onPulseDetected";
  static const String eventPulseDetectionTimeExpired = "onPulseDetectionTimeExpired";
  static const String eventMovementDetected = "onMovementDetected";
  static const String eventMeasurementProcessed = "onMeasurementProcessed";
  static const String eventMeasurementError = "onMeasurementError";

  static const String keySampleReadyPPG = "ppg";
  static const String keySampleReadyRaw = "raw";
  static const String keyFingerRemovedY = "y";
  static const String keyFingerRemovedV = "v";
  static const String keyFingerRemovedStdDevY = "stdDevY";
  static const String keyHeartBeatHeartRate = "heartRate";
  static const String keyEventTimeRemaining = "seconds";
  static const String keyMeasurementProcessedMeasurement = "measurement";
  static const String keyMeasurementErrorMessage = "message";
  static const String keyMeasurementTimestamp = "measurement_timestamp";

  late final EventChannel _channel;

  FibriCheckViewState? _fibriCheckViewState;

  FibriCheckViewEventController(String id, FibriCheckViewState this._fibriCheckViewState) {
    _channel = EventChannel("com.fibricheck.camera_sdk/flutterFibriCheckView_${id}_event");
  }

  void subscribe() {
    _channel.receiveBroadcastStream().listen(_onEventReceived);
  }

  void dispose() {
    _fibriCheckViewState = null;
  }

  void _onEventReceived(e) {
    if (e == null) return;

    var widget = _fibriCheckViewState?.widget;
    if (widget == null) return;

    var event = Map<String, dynamic>.from(e);

    var eventType = event[type];
    switch (eventType) {
      case eventSampleReady:
        final ppg = event[keySampleReadyPPG] as double;
        final raw = event[keySampleReadyRaw] as double;

        widget.onSampleReady(ppg, raw);
        break;
      case eventFingerDetected:
        widget.onFingerDetected();
        break;
      case eventFingerRemoved:
        final y = event[keyFingerRemovedY] as double;
        final v = event[keyFingerRemovedV] as double;
        final stdDevY = event[keyFingerRemovedStdDevY] as double;

        widget.onFingerRemoved(y, v, stdDevY);
        break;
      case eventCalibrationReady:
        widget.onCalibrationReady();
        break;
      case eventHeartBeat:
        final heartRate = event[keyHeartBeatHeartRate] as int;
        widget.onHeartBeat(heartRate);
        break;
      case eventTimeRemaining:
        final timeRemaining = event[keyEventTimeRemaining] as int;
        widget.onTimeRemaining(timeRemaining);
        break;
      case eventMeasurementFinished:
        widget.onMeasurementFinished();
        break;
      case eventMeasurementStart:
        widget.onMeasurementStart();
        break;
      case eventFingerDetectionTimeExpired:
        widget.onFingerDetectionTimeExpired();
        break;
      case eventPulseDetected:
        widget.onPulseDetected();
        break;
      case eventPulseDetectionTimeExpired:
        widget.onPulseDetectionTimeExpired();
        break;
      case eventMovementDetected:
        widget.onMovementDetected();
        break;
      case eventMeasurementProcessed:
        final measurementJson = jsonDecode(event[keyMeasurementProcessedMeasurement]);
        measurementJson[keyMeasurementTimestamp] = DateTime.now().millisecondsSinceEpoch;
        widget.onMeasurementProcessed(measurementJson);
        break;
      case eventMeasurementError:
        final message = event[keyMeasurementErrorMessage] as String;
        widget.onMeasurementError(message);
        break;
    }
  }
}
