import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  late final Function(String message) onMeasurementError;

  FibriCheckView({
    Key? key,
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
    Function(String measurement)? onMeasurementProcessed,
    Function(String message)? onMeasurementError,
  }) : super(key: key) {
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
    this.onMeasurementError = onMeasurementError ?? (message) => {};
  }

  @override
  FibriCheckViewState createState() => FibriCheckViewState();
}

class FibriCheckViewState extends State<FibriCheckView> with WidgetsBindingObserver {
  // This is used in the platform side to register the view.
  static const String viewType = 'fibricheckview';

  int _counter = 0;
  Key? _key;

  FibriCheckViewState() {
    _key = Key(_counter.toString());
  }

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

  String _channelId = '';
  final Map<String, dynamic> _creationParams = <String, dynamic>{};

  FibriCheckViewEventController? _fibriCheckViewEventController;
  FibriCheckViewMethodController? _fibriCheckViewMethodController;

  @override
  void initState() {
    _setupChannelId();

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    _fibriCheckViewEventController?.dispose();
    _fibriCheckViewEventController = null;

    _fibriCheckViewMethodController?.resetModule();
    _fibriCheckViewMethodController = null;

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _fibriCheckViewEventController?.dispose();
      _fibriCheckViewEventController = null;

      _fibriCheckViewMethodController?.resetModule();
      _fibriCheckViewMethodController = null;

      _counter++;
      _key = Key(_counter.toString());
      _setupChannelId();
    } else if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    Widget view;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        view = IgnorePointer(
          child: AndroidView(
            key: _key,
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
          key: _key,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParams: _creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        throw UnsupportedError('Unsupported platform view');
    }

    _setupProperties();

    return view;
  }

  void _setupChannelId() {
    const uuid = Uuid();
    _channelId = uuid.v1().toString();
    _creationParams["channelId"] = _channelId;
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

  final EventChannel _channel;

  FibriCheckViewState? _fibriCheckViewState;

  FibriCheckViewEventController._(String id, FibriCheckViewState this._fibriCheckViewState) : _channel = EventChannel('com.fibricheck.camera_sdk/flutterFibriCheckView_${id}_event');

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
        final ppg = event["ppg"] as double;
        final raw = event["raw"] as double;

        widget.onSampleReady(ppg, raw);
        break;
      case eventFingerDetected:
        widget.onFingerDetected();
        break;
      case eventFingerRemoved:
        widget.onFingerRemoved();
        break;
      case eventCalibrationReady:
        widget.onCalibrationReady();
        break;
      case eventHeartBeat:
        final heartRate = event["heartRate"] as int;
        widget.onHeartBeat(heartRate);
        break;
      case eventTimeRemaining:
        final timeRemaining = event["seconds"] as int;
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
        final measurementJson = event["measurement"] as String;
        widget.onMeasurementProcessed(measurementJson);
        break;
      case eventMeasurementError:
        final message = event["message"] as String;
        widget.onMeasurementError(message);
        break;
    }
  }
}

class FibriCheckViewMethodController {
  // Commands
  static const String commandAllPropertiesInitialized = "allPropertiesInitialized";
  static const String commandResetModule = "resetModule";

  //Properties
  static const String setPropertyDrawGraph = "setDrawGraph";
  static const String setPropertyDrawBackground = "setDrawBackground";
  static const String setPropertyLineColor = "setLineColor";
  static const String setPropertyLineThickness = "setLineThickness";
  static const String setPropertyGraphBackgroundColor = "setGraphBackgroundColor";
  static const String setPropertySampleTime = "setSampleTime";
  static const String setPropertyAccEnabled = "setAccEnabled";
  static const String setPropertyFingerDetectionExpiryTime = "setFingerDetectionExpiryTime";
  static const String setPropertyFlashEnabled = "setFlashEnabled";
  static const String setPropertyGravEnabled = "setGravEnabled";
  static const String setPropertyGyroEnabled = "setGyroEnabled";
  static const String setPropertyMovementDetectionEnabled = "setMovementDetectionEnabled";
  static const String setPropertyRotationEnabled = "setRotationEnabled";
  static const String setPropertyWaitForStartRecordingSignal = "setWaitForStartRecordingSignal";
  static const String setPropertyPulseDetectionExpiryTime = "setPulseDetectionExpiryTime";

  final MethodChannel _channel;

  // Backing fields
  bool? _drawGraph;
  bool? _drawBackground;
  String? _lineColor;
  int? _lineThickness;
  String? _graphBackgroundColor;
  int? _sampleTime;
  bool? _accEnabled;
  int? _fingerDetectionExpiryTime;
  bool? _flashEnabled;
  bool? _gravEnabled;
  bool? _gyroEnabled;
  bool? _movementDetectionEnabled;
  bool? _rotationEnabled;
  int? _pulseDetectionExpiryTime;
  bool? _waitForStartRecordingSignal;

  FibriCheckViewMethodController._(String id) : _channel = MethodChannel('com.fibricheck.camera_sdk/flutterFibriCheckView_${id}_method');

  Future<void> allPropertiesInitialized() async {
    return _channel.invokeMethod(commandAllPropertiesInitialized);
  }

  Future<void> resetModule() async {
    return _channel.invokeMethod(commandResetModule);
  }

  Future<void> setDrawGraph(bool drawGraph) {
    if (_drawGraph == drawGraph) return Future.value();

    _drawGraph = drawGraph;

    return _channel.invokeMethod(setPropertyDrawGraph, drawGraph);
  }

  Future<void> setDrawBackground(bool drawBackground) {
    if (_drawBackground == drawBackground) return Future.value();

    _drawBackground = drawBackground;

    return _channel.invokeMethod(setPropertyDrawBackground, drawBackground);
  }

  Future<void> setLineColor(String lineColor) {
    if (_lineColor == lineColor) return Future.value();

    _lineColor = lineColor;

    return _channel.invokeMethod(setPropertyLineColor, lineColor);
  }

  Future<void> setLineThickness(int lineThickness) {
    if (_lineThickness == lineThickness) return Future.value();

    _lineThickness = lineThickness;

    return _channel.invokeMethod(setPropertyLineThickness, lineThickness);
  }

  Future<void> setGraphBackgroundColor(String graphBackgroundColor) {
    if (_graphBackgroundColor == graphBackgroundColor) return Future.value();

    _graphBackgroundColor = graphBackgroundColor;

    return _channel.invokeMethod(setPropertyGraphBackgroundColor, graphBackgroundColor);
  }

  Future<void> setSampleTime(int sampleTime) {
    if (_sampleTime == sampleTime) return Future.value();

    _sampleTime = sampleTime;

    return _channel.invokeMethod(setPropertySampleTime, sampleTime);
  }

  Future<void> setAccEnabled(bool accEnabled) {
    if (_accEnabled == accEnabled) return Future.value();

    _accEnabled = accEnabled;

    return _channel.invokeMethod(setPropertyAccEnabled, accEnabled);
  }

  Future<void> setFingerDetectionExpiryTime(int fingerDetectionExpiryTime) {
    if (_fingerDetectionExpiryTime == fingerDetectionExpiryTime) return Future.value();

    _fingerDetectionExpiryTime = fingerDetectionExpiryTime;

    return _channel.invokeMethod(setPropertyFingerDetectionExpiryTime, fingerDetectionExpiryTime);
  }

  Future<void> setFlashEnabled(bool flashEnabled) {
    if (_flashEnabled == flashEnabled) return Future.value();

    _flashEnabled = flashEnabled;

    return _channel.invokeMethod(setPropertyFlashEnabled, flashEnabled);
  }

  Future<void> setGravEnabled(bool gravEnabled) {
    if (_gravEnabled == gravEnabled) return Future.value();

    _gravEnabled = gravEnabled;

    return _channel.invokeMethod(setPropertyGravEnabled, gravEnabled);
  }

  Future<void> setGyroEnabled(bool gyroEnabled) {
    if (_gyroEnabled == gyroEnabled) return Future.value();

    _gyroEnabled = gyroEnabled;

    return _channel.invokeMethod(setPropertyGyroEnabled, gyroEnabled);
  }

  Future<void> setMovementDetectionEnabled(bool movementDetectionEnabled) {
    if (_movementDetectionEnabled == movementDetectionEnabled) return Future.value();

    _movementDetectionEnabled = movementDetectionEnabled;

    return _channel.invokeMethod(setPropertyMovementDetectionEnabled, movementDetectionEnabled);
  }

  Future<void> setRotationEnabled(bool rotationEnabled) {
    if (_rotationEnabled == rotationEnabled) return Future.value();

    _rotationEnabled = rotationEnabled;

    return _channel.invokeMethod(setPropertyRotationEnabled, rotationEnabled);
  }

  Future<void> setPulseDetectionExpiryTime(int pulseDetectionExpiryTime) {
    if (_pulseDetectionExpiryTime == pulseDetectionExpiryTime) return Future.value();

    _pulseDetectionExpiryTime = pulseDetectionExpiryTime;

    return _channel.invokeMethod(setPropertyPulseDetectionExpiryTime, pulseDetectionExpiryTime);
  }

  Future<void> setWaitForStartRecordingSignal(bool waitForStartRecordingSignal) {
    if (_waitForStartRecordingSignal == waitForStartRecordingSignal) return Future.value();

    _waitForStartRecordingSignal = waitForStartRecordingSignal;

    return _channel.invokeMethod(setPropertyWaitForStartRecordingSignal, waitForStartRecordingSignal);
  }
}
