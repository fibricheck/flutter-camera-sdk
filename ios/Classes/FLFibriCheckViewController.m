#import "FLFibriCheckViewController.h"
#import "FLFibriCheckEventEmitter.h"
#import "FibricheckerComponent/FibriCheckerComponent.h"

@implementation FLFibriCheckViewControllerFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    NSLog(@"FLFibriCheckViewControllerFactory createWithFrame");
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    NSLog(@"FLFibriCheckViewControllerFactory createWithFrame: %@", NSStringFromCGRect(frame));
  return [[FLFibriCheckViewController alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

@end

@interface FLFibriCheckViewController ()
@property (nonatomic, strong) FLFibriChecker *fibrichecker;
@end

@implementation FLFibriCheckViewController{
  UIView *_view;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  NSLog(@"FLFibriCheckViewController initWithFrame: %@", NSStringFromCGRect(frame));

  if (self = [super init]) {
    _view = [[UIView alloc] init];
  }
  [self loadView];
  return self;
}

- (UIView*)view {
  return _view;
}

- (void)fibriCheckViewDidSetSampleTime {
    NSInteger sampleTime = ((FLFibriCheckView*)self.view).sampleTime;
    _fibrichecker.sampleTime = sampleTime;
}

- (void)fibriCheckViewDidSetFlash {
    BOOL flashEnabled = ((FLFibriCheckView*)self.view).flashEnabled;
    _fibrichecker.flashEnabled = flashEnabled;
}

- (void)fibriCheckViewDidSetGrav {
    BOOL gravEnabled = ((FLFibriCheckView*)self.view).gravEnabled;
    _fibrichecker.gravEnabled = gravEnabled;
}

- (void)fibriCheckViewDidSetGyro {
    BOOL gyroEnabled = ((FLFibriCheckView*)self.view).gyroEnabled;
    _fibrichecker.gyroEnabled = gyroEnabled;
}

- (void)fibriCheckViewDidSetAcc {
    BOOL accEnabled = ((FLFibriCheckView*)self.view).accEnabled;
    _fibrichecker.accEnabled = accEnabled;
}

- (void)fibriCheckViewDidSetRotation {
    BOOL rotationEnabled = ((FLFibriCheckView*)self.view).rotationEnabled;
    _fibrichecker.rotationEnabled = rotationEnabled;
}

- (void)fibriCheckViewDidSetMovementDetection {
    BOOL movementDetectionEnabled = ((FLFibriCheckView*)self.view).movementDetectionEnabled;
    _fibrichecker.movementDetectionEnabled = movementDetectionEnabled;
}

- (void)fibriCheckViewDidSetFingerDetectionExpiryTime {
    NSInteger fingerDetectionExpiryTime = ((FLFibriCheckView*)self.view).fingerDetectionExpiryTime;
    _fibrichecker.fingerDetectionExpiryTime = fingerDetectionExpiryTime;
}

- (void)fibriCheckViewDidSetWaitForStartRecordingSignal {
    NSInteger waitForStartRecordingSignal = ((FLFibriCheckView*)self.view).waitForStartRecordingSignal;
    _fibrichecker.waitForStartRecordingSignal = waitForStartRecordingSignal;
}

- (void)stopCamera {
    _fibrichecker.stop;
}

// MARK: - UI
- (void)viewDidLoad {
  //[super viewDidLoad];
  self.fibrichecker = [FLFibriChecker new];
  [self addListeners];
  [self startMeasurement];
}

- (void)startMeasurement {
  NSLog(@"startMeasurement");
  [_fibrichecker startMeasurement];
}

- (void)loadView {
      NSLog(@"loadView");
    FLFibriCheckView *customView = [[FLFibriCheckView alloc] init];
    customView.delegate = self;
    _view = customView;

    [self viewDidLoad];
}

- (void)drawGraphPoint:(double)value {
  [((FLFibriCheckView*)_view) addPoint:[NSNumber numberWithDouble:value]];
  dispatch_async(dispatch_get_main_queue(), ^{
    [(_view) setNeedsDisplay];
  });
}

- (void)addListeners {
  NSLog(@"addListeners");
  __unsafe_unretained typeof(self) weakSelf = self;

  self.fibrichecker.onMeasurementStart = ^{
    NSLog(@"Measurement start");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onMeasurementStart != nil) ((FLFibriCheckView*)weakSelf.view).onMeasurementStart();
    });
  };

  self.fibrichecker.onMeasurementFinished = ^{
    NSLog(@"Measurement Finished");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onMeasurementFinished != nil) ((FLFibriCheckView*)weakSelf.view).onMeasurementFinished();
    });
  };

  self.fibrichecker.onMeasurementProcessed = ^(Measurement* measurement){
    NSLog(@"Measurement processed");
    NSDictionary *data = @{@"measurement":[measurement mapToJson]};
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onMeasurementProcessed != nil) ((FLFibriCheckView*)weakSelf.view).onMeasurementProcessed(data);
    });
  };

  self.fibrichecker.onSampleReady = ^(double ppg, double raw) {
    NSLog(@"OnSample ready");
    BOOL drawGraph = ((FLFibriCheckView*)self.view).drawGraph;
    if(drawGraph) [weakSelf drawGraphPoint:ppg];
    NSDictionary *data = @{@"ppg":[NSNumber numberWithFloat:ppg], @"raw":[NSNumber numberWithFloat:raw]};
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onSampleReady != nil) ((FLFibriCheckView*)weakSelf.view).onSampleReady(ppg, raw);
    });
  };

  self.fibrichecker.onCalibrationReady = ^{
    NSLog(@"Calibration Ready");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onCalibrationReady != nil) ((FLFibriCheckView*)weakSelf.view).onCalibrationReady();
    });
  };

  self.fibrichecker.onFingerRemoved = ^{
    NSLog(@"Finger Removed");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onFingerRemoved != nil) ((FLFibriCheckView*)weakSelf.view).onFingerRemoved();
    });
  };

  self.fibrichecker.onFingerDetected = ^{
    NSLog(@"Finger Detected");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onFingerDetected != nil) ((FLFibriCheckView*)weakSelf.view).onFingerDetected();
    });
  };

  self.fibrichecker.onMovementDetected = ^{
    NSLog(@"Movement Detected");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onMovementDetected != nil) ((FLFibriCheckView*)weakSelf.view).onMovementDetected();
    });
  };

  self.fibrichecker.onPulseDetected = ^{
    NSLog(@"Pulse Detected");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onPulseDetected != nil) ((FLFibriCheckView*)weakSelf.view).onPulseDetected();
    });
  };

  self.fibrichecker.onPulseDetectionTimeExpired = ^{
    NSLog(@"Pulse Detection Time Expired");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onPulseDetectionTimeExpired != nil) ((FLFibriCheckView*)weakSelf.view).onPulseDetectionTimeExpired();
    });
  };

  self.fibrichecker.onFingerDetectionTimeExpired = ^{
    NSLog(@"Finger Detection Time Expired");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onFingerDetectionTimeExpired != nil) ((FLFibriCheckView*)weakSelf.view).onFingerDetectionTimeExpired();
    });
  };

  self.fibrichecker.onHeartBeat = ^(NSUInteger value) {
    NSLog(@"Heart Beat Detected: %lu", value);
    NSDictionary *data = @{@"heartRate":[NSNumber numberWithInteger:value]};
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onHeartBeat != nil) ((FLFibriCheckView*)weakSelf.view).onHeartBeat(data);
    });
  };

  self.fibrichecker.onTimeRemaining = ^(NSUInteger seconds) {
    NSLog(@"Time Remaining: %lu", seconds);
    NSDictionary *data = @{@"seconds":[NSNumber numberWithInteger:seconds]};
    dispatch_async(dispatch_get_main_queue(), ^{
        if(((FLFibriCheckView*)weakSelf.view).onTimeRemaining != nil) ((FLFibriCheckView*)weakSelf.view).onTimeRemaining(data);
    });
  };
}

@end