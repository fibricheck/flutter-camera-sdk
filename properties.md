---
description: >-
  When you want to override the default settings (not recommended) you can
  adjust some of the module's default parameters. The code samples indicate
  their default values.
---

# Properties

## Measurement Settings

### sampleTime

The duration of the measurement in seconds. Default is set to 1 minute.

```dart
sampleTime = 60;
```

### flashEnabled

When enabled and supported by the device the SDK will turn on the camera flashlight while measuring.

```dart
flashEnabled = true;
```

### gravEnabled

When enabled and supported by the device, the measurement result will hold gravitational data.

```dart
gravEnabled = false;
```

### gyroEnabled

When enabled and supported by the device, the measurement result will hold gyroscope data.

```dart
gyroEnabled = false;
```

### accEnabled

When enabled and supported by the device, the measurement result will hold accelerometer data.

```dart
accEnabled = false;
```

### rotationEnabled

When enabled and supported by the device, the measurement result will hold rotational data.

```dart
rotationEnabled = false;
```

### movementDetectionEnabled

When enabled the `onMovementDetected()` event will be thrown when movement is detected.

The detection will trigger when the movement vector is lower than 6 or higher than 14.

```dart
movementDetectionEnabled = true;
```

### fingerDetectionExpiryTime

The time until the finger detection will trigger the `onFingerDetectionTimeExpired`() event.

By Default this value is `-1`, wich indicates that it will keep waiting untill a finger is detected

```dart
fingerDetectionExpiryTime = -1;
```

### waitForStartRecordingSignal

Normally, when the calibration is ready, the measurement will start recording. When this flag is enabled, the measurement will wait untill the `startRecording()` command has been given.

```dart
waitForStartRecordingSignal = false;
```

## Graph Settings

### graphBackgroundColor

Determines the graphBackground color. By default there is no background color

```dart
graphBackgroundColor = "";
```

### drawGraph

When enabled the component draws a graph of the recorded PPG signal.

```dart
drawGraph = true;
```

### lineColor

Determines the color of the graph line.

```dart
lineColor = "#63b3a6";
```

### lineThickness

Determines the thickness of the graph line.

```dart
lineThickness = 8;
```

### drawBackground

When enabled, the component will draw a background for the graph

```dart
drawBackground = true;
```