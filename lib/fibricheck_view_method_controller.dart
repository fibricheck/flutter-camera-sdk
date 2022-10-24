import 'package:flutter/services.dart';

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

  late final MethodChannel _channel;

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

  FibriCheckViewMethodController(String id) {
    _channel = MethodChannel('com.fibricheck.camera_sdk/flutterFibriCheckView_${id}_method');
  } 

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