import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'fibricheck_view_event_controller.dart';
import 'fibricheck_view_method_controller.dart';
import 'fibricheck_view_properties.dart';
export 'fibricheck_view_properties.dart';

class MeasurementErrors {
  static const String brokenAccSensorError = "BROKEN_ACC_SENSOR";
}

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
    Function(double y, double v, double stdDevY)? onFingerRemoved,
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
    this.onFingerRemoved = onFingerRemoved ?? (y, v, stdDevY) => {};
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

// WidgetsBindingObserver is an interface to say that that the current class observe the appLifecycle.
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
    super.initState();

    _setupChannelId();

    // Used to observe the app lifecycle and stop the Native-Side FibriChecker.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    Widget view;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        view = AndroidView(
          key: _key,
          viewType: viewType, // To know which native-side factory is used.
          layoutDirection: TextDirection.ltr,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParams: _creationParams,
          creationParamsCodec: const StandardMessageCodec(),
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

    // ignore user inputs.
    return IgnorePointer(child: view);
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _stopNativeSideAndResetTheChannel() async {
    // Let's be sure that the FibriChecker is stopped !
    await _fibriCheckViewMethodController?.resetModule();

    _counter++;
    _key = Key(_counter.toString());
    _setupChannelId();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused: await _stopNativeSideAndResetTheChannel(); break;
      case AppLifecycleState.resumed: setState(() {});
    }

    super.didChangeAppLifecycleState(state);
  }

  void _setupChannelId() {
    const uuid = Uuid();
    _channelId = uuid.v1().toString();
    _creationParams["channelId"] = _channelId;
  }

  Future<void> _onPlatformViewCreated(int id) async {
    _fibriCheckViewEventController = FibriCheckViewEventController(_channelId, this);
    _fibriCheckViewMethodController = FibriCheckViewMethodController(_channelId);

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
