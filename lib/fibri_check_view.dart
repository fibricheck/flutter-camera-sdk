import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'fibri_check_view_properties.dart';
export 'fibri_check_view_properties.dart';

class FibriCheckView extends StatefulWidget {
  late final FibriCheckViewProperties _fibriCheckViewProperties;
  late final Function onFingerDetected;
  late final Function onFingerRemoved;
  late final Function onFingerDetectionTimeExpired;
  late final Function onCalibrationReady;
  late final Function(int heartRate) onHeartBeat;
  late final Function onMeasurementFinished;
  late final Function onMeasurementStart;
  late final Function(int seconds) onTimeRemaining;
  late final Function(double ppg, double raw) onSampleReady;
  late final Function onPulseDetected;
  late final Function onPulseDetectionTimeExpired;
  late final Function onMovementDetected;
  late final Function(String measurementJson) onMeasurementProcessed;

  FibriCheckView(
      {Key? key,
      FibriCheckViewProperties? fibriCheckViewProperties,
      Function? onFingerDetected,
      Function? onFingerRemoved,
      Function? onFingerDetectionTimeExpired,
      Function? onCalibrationReady,
      Function(int heartRate)? onHeartBeat,
      Function? onMeasurementFinished,
      Function? onMeasurementStart,
      Function(int seconds)? onTimeRemaining,
      Function(double ppg, double raw)? onSampleReady,
      Function? onPulseDetected,
      Function? onPulseDetectionTimeExpired,
      Function? onMovementDetected,
      Function(String measurement)? onMeasurementProcessed})
      : super(key: key) {
    _fibriCheckViewProperties = fibriCheckViewProperties ?? FibriCheckViewProperties();

    this.onFingerDetected = onFingerDetected ?? () => {};
    this.onFingerRemoved = onFingerRemoved ?? () => {};
    this.onFingerDetectionTimeExpired = onFingerDetectionTimeExpired ?? () => {};
    this.onCalibrationReady = onCalibrationReady ?? () => {};
    this.onHeartBeat = onHeartBeat ?? (heartRate) => {};
    this.onMeasurementFinished = onMeasurementFinished ?? () => {};
    this.onMeasurementStart = onMeasurementStart ?? () => {};
    this.onTimeRemaining = onTimeRemaining ?? (seconds) => {};
    this.onSampleReady = onSampleReady ?? (ppg, raw) => {};
    this.onPulseDetected = onPulseDetected ?? () => {};
    this.onPulseDetectionTimeExpired = onPulseDetectionTimeExpired ?? () => {};
    this.onMovementDetected = onMovementDetected ?? () => {};
    this.onMeasurementProcessed = onMeasurementProcessed ?? (measurement) => {};
  }

  @override
  _FibriCheckViewState createState() => _FibriCheckViewState();
}

class _FibriCheckViewState extends State<FibriCheckView> {
  // This is used in the platform side to register the view.
  static const String viewType = 'fibricheckview';

  _FibriCheckViewState();

  String get graphBackgroundColor => widget._fibriCheckViewProperties.graphBackgroundColor;

  bool get drawGraph => widget._fibriCheckViewProperties.drawGraph;

  String get lineColor => widget._fibriCheckViewProperties.lineColor;

  int get lineThickness => widget._fibriCheckViewProperties.lineThickness;

  bool get drawBackground => widget._fibriCheckViewProperties.drawBackground;

  int get sampleTime => widget._fibriCheckViewProperties.sampleTime;

  bool get flashEnabled => widget._fibriCheckViewProperties.flashEnabled;

  bool get gravEnabled => widget._fibriCheckViewProperties.gravEnabled;

  bool get gyroEnabled => widget._fibriCheckViewProperties.gyroEnabled;

  bool get accEnabled => widget._fibriCheckViewProperties.accEnabled;

  bool get rotationEnabled => widget._fibriCheckViewProperties.rotationEnabled;

  bool get movementDetectionEnabled => widget._fibriCheckViewProperties.movementDetectionEnabled;

  int get pulseDetectionExpiryTime => widget._fibriCheckViewProperties.pulseDetectionExpiryTime;

  int get fingerDetectionExpiryTime => widget._fibriCheckViewProperties.fingerDetectionExpiryTime;

  bool get waitForStartRecordingSignal => widget._fibriCheckViewProperties.waitForStartRecordingSignal;

  late String _channelId;
  final Map<String, dynamic> _creationParams = <String, dynamic>{};

  FibriCheckViewEventController? _fibriCheckViewEventController;
  FibriCheckViewMethodController? _fibriCheckViewMethodController;

  @override
  void initState() {
    var uuid = const Uuid();
    _channelId = uuid.v1().toString();
    _creationParams["channelId"] = _channelId;
    super.initState();
  }

  @override
  void dispose() {
    _fibriCheckViewEventController?.dispose();
    _fibriCheckViewMethodController?.resetModule();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget view;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        view = IgnorePointer(
          child: AndroidView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            onPlatformViewCreated: _onPlatformViewCreated,
            creationParams: _creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          ),
        );
        break;
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: _creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
        break;
      default:
        throw UnsupportedError('Unsupported platform view');
    }

    _setupProperties();

    return view;
  }

  Future<void> _onPlatformViewCreated(int id) async {
    _fibriCheckViewEventController = FibriCheckViewEventController._(_channelId, this);
    _fibriCheckViewMethodController = FibriCheckViewMethodController._(_channelId);

    await _setupProperties();

    _fibriCheckViewEventController!.subscribe();
    _fibriCheckViewMethodController!.allPropertiesInitialized();
  }

  Future<void> _setupProperties() async {
    final methodController = _fibriCheckViewMethodController;

    if (methodController == null) {
      return;
    }

    await methodController.setGraphBackgroundColor(graphBackgroundColor);
    await methodController.setDrawGraph(drawGraph);
    await methodController.setLineColor(lineColor);
    await methodController.setLineThickness(lineThickness);
    await methodController.setDrawBackground(drawBackground);
    await methodController.setSampleTime(sampleTime);
    await methodController.setFlashEnabled(flashEnabled);
    await methodController.setGravEnabled(gravEnabled);
    await methodController.setGyroEnabled(gyroEnabled);
    await methodController.setAccEnabled(accEnabled);
    await methodController.setRotationEnabled(rotationEnabled);
    await methodController.setMovementDetectionEnabled(movementDetectionEnabled);
    await methodController.setPulseDetectionExpiryTime(pulseDetectionExpiryTime);
    await methodController.setFingerDetectionExpiryTime(fingerDetectionExpiryTime);
    await methodController.setWaitForStartRecordingSignal(waitForStartRecordingSignal);
  }
}

class FibriCheckViewEventController {
  static const String EVENT_TYPE = "eventType";

  static const String EVENT_SAMPLE_READY = "onSampleReady";
  static const String EVENT_FINGER_DETECTED = "onFingerDetected";
  static const String EVENT_FINGER_REMOVED = "onFingerRemoved";
  static const String EVENT_CALIBRATION_READY = "onCalibrationReady";
  static const String EVENT_HEARTBEAT = "onHeartBeat";
  static const String EVENT_TIME_REMAINING = "onTimeRemaining";
  static const String EVENT_MEASUREMENT_FINISHED = "onMeasurementFinished";
  static const String EVENT_MEASUREMENT_START = "onMeasurementStart";
  static const String EVENT_FINGER_DETECTION_TIME_EXPIRED = "onFingerDetectionTimeExpired";
  static const String EVENT_PULSE_DETECTED = "onPulseDetected";
  static const String EVENT_PULSE_DETECTION_TIME_EXPIRED = "onPulseDetectionTimeExpired";
  static const String EVENT_MOVEMENT_DETECTED = "onMovementDetected";
  static const String EVENT_MEASUREMENT_PROCESSED = "onMeasurementProcessed";

  final EventChannel _channel;

  _FibriCheckViewState? _fibriCheckViewState;

  FibriCheckViewEventController._(String id, _FibriCheckViewState this._fibriCheckViewState) : _channel = EventChannel('com.fibricheck.camera_sdk/flutterFibriCheckView_${id}_event');

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

    var eventType = event[EVENT_TYPE];
    switch (eventType) {
      case EVENT_SAMPLE_READY:
        var ppg = event["ppg"] as double;
        var raw = event["raw"] as double;

        widget.onSampleReady(ppg, raw);
        break;
      case EVENT_FINGER_DETECTED:
        widget.onFingerDetected();
        break;
      case EVENT_FINGER_REMOVED:
        widget.onFingerRemoved();
        break;
      case EVENT_CALIBRATION_READY:
        widget.onCalibrationReady();
        break;
      case EVENT_HEARTBEAT:
        var heartRate = event["heartRate"] as int;
        widget.onHeartBeat(heartRate);
        break;
      case EVENT_TIME_REMAINING:
        var timeRemaining = event["seconds"] as int;
        widget.onTimeRemaining(timeRemaining);
        break;
      case EVENT_MEASUREMENT_FINISHED:
        widget.onMeasurementFinished();
        break;
      case EVENT_MEASUREMENT_START:
        widget.onMeasurementStart();
        break;
      case EVENT_FINGER_DETECTION_TIME_EXPIRED:
        widget.onFingerDetectionTimeExpired();
        break;
      case EVENT_PULSE_DETECTED:
        widget.onPulseDetected();
        break;
      case EVENT_PULSE_DETECTION_TIME_EXPIRED:
        widget.onPulseDetectionTimeExpired();
        break;
      case EVENT_MOVEMENT_DETECTED:
        widget.onMovementDetected();
        break;
      case EVENT_MEASUREMENT_PROCESSED:
        var measurementJson = event["measurement"] as String;
        widget.onMeasurementProcessed(measurementJson);
        break;
    }
  }
}

class FibriCheckViewMethodController {
  // Commands
  static const String ALL_PROPERTIES_INITIALIZED = "allPropertiesInitialized";
  static const String RESET_MODULE = "resetModule";

  //Properties
  static const String SET_DRAWGRAPH = "setDrawGraph";
  static const String SET_DRAWBACKGROUND = "setDrawBackground";
  static const String SET_LINECOLOR = "setLineColor";
  static const String SET_LINETHICKNESS = "setLineThickness";
  static const String SET_GRAPHBACKGROUNDCOLOR = "setGraphBackgroundColor";
  static const String SET_SAMPLETIME = "setSampleTime";
  static const String SET_ACCENABLED = "setAccEnabled";
  static const String SET_FINGERDETECTIONEXPIRYTIME = "setFingerDetectionExpiryTime";
  static const String SET_FLASHENABLED = "setFlashEnabled";
  static const String SET_GRAVENABLED = "setGravEnabled";
  static const String SET_GYROENABLED = "setGyroEnabled";
  static const String SET_MOVEMENTDETECTIONENABLED = "setMovementDetectionEnabled";
  static const String SET_ROTATIONENABLED = "setRotationEnabled";
  static const String SET_WAITFORSTARTRECORDINGSIGNAL = "setWaitForStartRecordingSignal";
  static const String SET_PULSEDETECTIONEXPIRYTIME = "setPulseDetectionExpiryTime";

  final MethodChannel _channel;

  FibriCheckViewMethodController._(String id) : _channel = MethodChannel('com.fibricheck.camera_sdk/flutterFibriCheckView_${id}_method');

  Future<void> allPropertiesInitialized() async {
    return _channel.invokeMethod(ALL_PROPERTIES_INITIALIZED);
  }

  Future<void> resetModule() async {
    return _channel.invokeMethod(RESET_MODULE);
  }

  Future<void> setDrawGraph(bool drawGraph) {
    return _channel.invokeMethod(SET_DRAWGRAPH, drawGraph);
  }

  Future<void> setDrawBackground(bool drawBackground) {
    return _channel.invokeMethod(SET_DRAWBACKGROUND, drawBackground);
  }

  Future<void> setLineColor(String lineColor) {
    return _channel.invokeMethod(SET_LINECOLOR, lineColor);
  }

  Future<void> setLineThickness(int lineThickness) {
    return _channel.invokeMethod(SET_LINETHICKNESS, lineThickness);
  }

  Future<void> setGraphBackgroundColor(String graphBackgroundColor) {
    return _channel.invokeMethod(SET_GRAPHBACKGROUNDCOLOR, graphBackgroundColor);
  }

  Future<void> setSampleTime(int sampleTime) {
    return _channel.invokeMethod(SET_SAMPLETIME, sampleTime);
  }

  Future<void> setAccEnabled(bool accEnabled) {
    return _channel.invokeMethod(SET_ACCENABLED, accEnabled);
  }

  Future<void> setFingerDetectionExpiryTime(int fingerDetectionExpiryTime) {
    return _channel.invokeMethod(SET_FINGERDETECTIONEXPIRYTIME, fingerDetectionExpiryTime);
  }

  Future<void> setFlashEnabled(bool flashEnabled) {
    return _channel.invokeMethod(SET_FLASHENABLED, flashEnabled);
  }

  Future<void> setGravEnabled(bool gravEnabled) {
    return _channel.invokeMethod(SET_GRAVENABLED, gravEnabled);
  }

  Future<void> setGyroEnabled(bool gyroEnabled) {
    return _channel.invokeMethod(SET_GYROENABLED, gyroEnabled);
  }

  Future<void> setMovementDetectionEnabled(bool movementDetectionEnabled) {
    return _channel.invokeMethod(SET_MOVEMENTDETECTIONENABLED, movementDetectionEnabled);
  }

  Future<void> setRotationEnabled(bool rotationEnabled) {
    return _channel.invokeMethod(SET_ROTATIONENABLED, rotationEnabled);
  }

  Future<void> setPulseDetectionExpiryTime(int pulseDetectionExpiryTime) {
    return _channel.invokeMethod(SET_PULSEDETECTIONEXPIRYTIME, pulseDetectionExpiryTime);
  }

  Future<void> setWaitForStartRecordingSignal(bool waitForStartRecordingSignal) {
    return _channel.invokeMethod(SET_WAITFORSTARTRECORDINGSIGNAL, waitForStartRecordingSignal);
  }
}
