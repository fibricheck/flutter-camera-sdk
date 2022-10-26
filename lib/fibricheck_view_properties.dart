class FibriCheckViewProperties {
  final String graphBackgroundColor;
  final bool drawGraph;
  final String lineColor;
  final int lineThickness;
  final bool drawBackground;
  final int sampleTime;
  final bool flashEnabled;
  final bool gravEnabled;
  final bool gyroEnabled;
  final bool accEnabled;
  final bool rotationEnabled;
  final bool movementDetectionEnabled;
  final int fingerDetectionExpiryTime;
  final int pulseDetectionExpiryTime;
  final bool waitForStartRecordingSignal;

  FibriCheckViewProperties(
      {this.graphBackgroundColor = "",
      this.drawGraph = true,
      this.lineColor = "#63b3a6",
      this.lineThickness = 8,
      this.drawBackground = true,
      this.sampleTime = 60,
      this.flashEnabled = true,
      this.gravEnabled = false,
      this.gyroEnabled = false,
      this.accEnabled = false,
      this.rotationEnabled = false,
      this.movementDetectionEnabled = true,
      this.fingerDetectionExpiryTime = -1,
      this.pulseDetectionExpiryTime = 10,
      this.waitForStartRecordingSignal = false});
}
