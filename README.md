---
description: >-
  The camera SDK is a PPG recording module that you can use in combination with
  the FibriCheck Flutter SDK. This page help you to get started with this
  module.
---

# Getting Started

## Intro

A FibriCheck measurement consists of PPG data. To gather this PPG data, the Camera SDK will natively communicate with the underlying iOS/Android camera layer, process this data, and return an object that is ready to be submitted to our backend for analysis. Multiple [properties](properties.md) and [listeners](listeners.md) can be adjusted/attached for improving the visualization/customization of the process.

A FibriCheck Measurement consists of multiple phases:

1. Finger detection
   * Checks for the presence of a finger on the camera. A [timeout](properties.md#fingerdetectionexpirytime) can be set to 0 to skip this phase. By default this is `-1` which means that it will keep checking until a finger has been detected.
2. Pulse detection&#x20;
   * Checks if a pulse is present. When no pulse has been detected for 10 seconds, the calibration phase will start.
3. Calibration
   * When performing a measurement, a baseline needs to be calculated. When this baseline has been calculated, the calibration is ready and recording can commence.
4. Recording
   * The real deal. The recording calculates the PPG data by communicating with the native camera layers. The default length of the recording is 60 seconds, but can be changed by updating the [sampleTime](properties.md#sampletime).
5. Processing&#x20;
   * When the recording is finished, some additional processing needs to be done on the measurement. When done, a measurement object is presented via the [onMeasurementProcessed](listeners.md#onmeasurementprocessed) event.&#x20;

## Installation

To install the Camera SDK, you will need to have access to the [Camera SDK git repository](https://github.com/fibricheck/flutter-camera-sdk).

## Making your first recording

### Permissions

The recording makes use of the device's camera. So to begin, you need to provide camera permissions. Check out https://pub.dev/packages/permission_handler or a similar package on how to accomplish this easily.

### Widget

When the permissions are all set up, you can implement the FibriCheck widget like this:

```
    FibriCheckView(
        fibriCheckViewProperties: 
            FibriCheckViewProperties(
                flashEnabled: true,
                lineThickness: 4,
                ...,
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
    ),
```