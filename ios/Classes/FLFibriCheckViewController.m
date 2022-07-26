#import "FLFibriCheckViewController.h"
#import "FLFibriCheckEventEmitter.h"
#import "FibricheckerComponent/FibriCheckerComponent.h"
#import "FLFibriCheckStreamHandler.h"

@implementation FLFibriCheckViewControllerFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(NSDictionary*)args {
    return [[FLFibriCheckViewController alloc] initWithFrame:frame
                                              viewIdentifier:viewId
                                                   arguments:args
                                             binaryMessenger:_messenger];
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end

@interface FLFibriCheckViewController ()
@property (nonatomic, strong) FLFibriChecker *fibrichecker;
@end

@implementation FLFibriCheckViewController{
    UIView *_view;
    int64_t _viewId;
    FlutterMethodChannel* _methodChannel;
    FlutterEventChannel* _eventChannel;
    FLFibriCheckStreamHandler* _eventHandler;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(NSDictionary*)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self = [super init]) {
        [self loadView];
        
        NSString *channelId = args[@"channelId"];
        NSString *channelName = [NSString stringWithFormat:@"%@%@", @"com.fibricheck.camera_sdk/flutterFibriCheckView_", channelId];
        
        _methodChannel = [FlutterMethodChannel
                          methodChannelWithName:[NSString stringWithFormat:@"%@%@", channelName, @"_method"]
                          binaryMessenger:messenger];
        
        _eventChannel =[FlutterEventChannel
                        eventChannelWithName :[NSString stringWithFormat:@"%@%@", channelName, @"_event"]
                        binaryMessenger:messenger];
        _eventHandler = [FLFibriCheckStreamHandler new];
        
        [_eventChannel setStreamHandler: _eventHandler];
        
        [_methodChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            if ([@"allPropertiesInitialized"  isEqualToString:call.method]) {
                
                [self startMeasurement];
                result(call.arguments);
            }
            else if ([@"resetModule"  isEqualToString:call.method]){
                [self stopMeasurement];
                result(call.arguments);
            }
            else if ([@"setDrawBackground"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                BOOL enabled = arg == [NSNumber numberWithBool:YES];
                [self setDrawBackground:enabled];
                result(call.arguments);
            }
            else if ([@"setDrawGraph"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                BOOL enabled = arg == [NSNumber numberWithBool:YES];
                [self setDrawGraph:enabled];
                result(call.arguments);
            }
            else if ([@"setLineColor"  isEqualToString:call.method]){
                [self setLineColor:call.arguments];
                result(call.arguments);
            }
            else if ([@"setLineThickness"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                NSInteger intValue = [arg integerValue];
                [self setLineThickness:intValue];
                result(call.arguments);
            }
            else if ([@"setGraphBackgroundColor"  isEqualToString:call.method]){
                [self setGraphBackgroundColor:call.arguments];
                result(call.arguments);
            }
            else if ([@"setSampleTime"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                NSInteger intValue = [arg integerValue];
                _fibrichecker.sampleTime = intValue;
                [_fibrichecker updateConfiguration];
                result(call.arguments);
            }
            else if ([@"setAccEnabled"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                BOOL enabled = arg == [NSNumber numberWithBool:YES];
                _fibrichecker.accEnabled = enabled;
                [_fibrichecker updateConfiguration];
                result(call.arguments);
            }
            else if ([@"setFingerDetectionExpiryTime"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                NSInteger intValue = [arg integerValue];
                _fibrichecker.fingerDetectionExpiryTime = intValue;
                [_fibrichecker updateConfiguration];
                result(call.arguments);
            }
            else if ([@"setFlashEnabled"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                BOOL enabled = arg == [NSNumber numberWithBool:YES];
                _fibrichecker.flashEnabled = enabled;
                [_fibrichecker updateConfiguration];
                result(call.arguments);
            }
            else if ([@"setGyroEnabled"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                BOOL enabled = arg == [NSNumber numberWithBool:YES];
                _fibrichecker.gyroEnabled = enabled;
                [_fibrichecker updateConfiguration];
                result(call.arguments);
            }
            else if ([@"setMovementDetectionEnabled"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                BOOL enabled = arg == [NSNumber numberWithBool:YES];
                _fibrichecker.movementDetectionEnabled = enabled;
                [_fibrichecker updateConfiguration];
                result(call.arguments);
            }
            else if ([@"setRotationEnabled"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                BOOL enabled = arg == [NSNumber numberWithBool:YES];
                _fibrichecker.rotationEnabled = enabled;
                [_fibrichecker updateConfiguration];
                result(call.arguments);
            }
            else if ([@"setWaitForStartRecordingSignal"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                BOOL enabled = arg == [NSNumber numberWithBool:YES];
                _fibrichecker.waitForStartRecordingSignal = enabled;
                [_fibrichecker updateConfiguration];
                result(call.arguments);
            }
            else if ([@"setGravEnabled"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                BOOL enabled = arg == [NSNumber numberWithBool:YES];
                _fibrichecker.gravEnabled = enabled;
                [_fibrichecker updateConfiguration];
                result(call.arguments);
            }
            else if ([@"setPulseDetectionExpiryTime"  isEqualToString:call.method]){
                NSNumber *arg = call.arguments;
                NSInteger intValue = [arg integerValue];
                _fibrichecker.pulseDetectionExpiryTime = intValue;
                [_fibrichecker updateConfiguration];
                result(call.arguments);
            }
            else
            {
                result(FlutterMethodNotImplemented);
            }
        }];
    }
    
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
    //[self startMeasurement];
}

- (void)startMeasurement {
    NSLog(@"startMeasurement");
    [_fibrichecker startMeasurement];
}

- (void)stopMeasurement {
    NSLog(@"stopMeasurement");
    [_fibrichecker stop];
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

- (void)setGraphBackgroundColor:(NSString*)value {
    if([value length] == 0){
        [((FLFibriCheckView*)_view) setGraphBackgroundColor:[UIColor clearColor]];
    }
    else{
        UIColor *color = [self colorFromHexString:value];
        [((FLFibriCheckView*)self.view) setGraphBackgroundColor:color];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [(_view) setNeedsDisplay];
    });
}

- (void)setDrawGraph:(BOOL)value {
    ((FLFibriCheckView*)self.view).drawGraph = value;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [(_view) setNeedsDisplay];
    });
}

- (void)setDrawBackground:(BOOL)value {
    ((FLFibriCheckView*)self.view).drawBackground = value;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [(_view) setNeedsDisplay];
    });
}

- (void)setLineColor:(NSString*)value {
    if([value length] == 0){
        [((FLFibriCheckView*)self.view) setGraphLineColor:[UIColor clearColor]];
    }
    else{
        UIColor *color = [self colorFromHexString:value];
        [((FLFibriCheckView*)self.view) setGraphLineColor:color];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [((FLFibriCheckView*)self.view) setNeedsDisplay];
    });
}

- (void)setLineThickness:(NSInteger)value {
    ((FLFibriCheckView*)self.view).lineThickness = value;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [(((FLFibriCheckView*)self.view)) setNeedsDisplay];
    });
}

- (void)setSampleTime:(NSInteger)value {
    _fibrichecker.sampleTime = value;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [(((FLFibriCheckView*)self.view)) setNeedsDisplay];
    });
}

- (void)addListeners {
    NSLog(@"addListeners");
    __unsafe_unretained typeof(self) weakSelf = self;
    
    self.fibrichecker.onMeasurementStart = ^{
        NSLog(@"Measurement start");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onMeasurementStart"}];

            if(((FLFibriCheckView*)weakSelf.view).onMeasurementStart != nil) ((FLFibriCheckView*)weakSelf.view).onMeasurementStart();
        });
    };
    
    self.fibrichecker.onMeasurementFinished = ^{
        NSLog(@"Measurement Finished");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onMeasurementFinished"}];

            if(((FLFibriCheckView*)weakSelf.view).onMeasurementFinished != nil) ((FLFibriCheckView*)weakSelf.view).onMeasurementFinished();
        });
    };
    
    self.fibrichecker.onMeasurementProcessed = ^(Measurement* measurement){
        NSLog(@"Measurement processed");
        NSDictionary *data = @{@"measurement":[measurement mapToJson]};
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [_eventHandler send:@{@"eventType" : @"onMeasurementProcessed", @"measurement" : jsonString}];
            
            if(((FLFibriCheckView*)weakSelf.view).onMeasurementProcessed != nil) ((FLFibriCheckView*)weakSelf.view).onMeasurementProcessed(data);
        });
    };
    
    self.fibrichecker.onSampleReady = ^(double ppg, double raw) {
        BOOL drawGraph = ((FLFibriCheckView*)self.view).drawGraph;
        if(drawGraph) [weakSelf drawGraphPoint:ppg];
        NSDictionary *data = @{@"ppg":[NSNumber numberWithFloat:ppg], @"raw":[NSNumber numberWithFloat:raw]};
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onSampleReady", @"ppg" :[NSNumber numberWithFloat:ppg], @"raw" : [NSNumber numberWithFloat:raw]}];

            if(((FLFibriCheckView*)weakSelf.view).onSampleReady != nil) ((FLFibriCheckView*)weakSelf.view).onSampleReady(ppg, raw);
        });
    };
    
    self.fibrichecker.onCalibrationReady = ^{
        NSLog(@"Calibration Ready");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onCalibrationReady"}];

            if(((FLFibriCheckView*)weakSelf.view).onCalibrationReady != nil) ((FLFibriCheckView*)weakSelf.view).onCalibrationReady();
        });
    };
    
    self.fibrichecker.onFingerRemoved = ^{
        NSLog(@"Finger Removed");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onFingerRemoved"}];

            if(((FLFibriCheckView*)weakSelf.view).onFingerRemoved != nil) ((FLFibriCheckView*)weakSelf.view).onFingerRemoved();
        });
    };
    
    self.fibrichecker.onFingerDetected = ^{
        //NSLog(@"Finger Detected");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onFingerDetected"}];
            
            if(((FLFibriCheckView*)weakSelf.view).onFingerDetected != nil) ((FLFibriCheckView*)weakSelf.view).onFingerDetected();
        });
    };
    
    self.fibrichecker.onMovementDetected = ^{
        NSLog(@"Movement Detected");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onMovementDetected"}];

            if(((FLFibriCheckView*)weakSelf.view).onMovementDetected != nil) ((FLFibriCheckView*)weakSelf.view).onMovementDetected();
        });
    };
    
    self.fibrichecker.onPulseDetected = ^{
        NSLog(@"Pulse Detected");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onPulseDetected"}];

            if(((FLFibriCheckView*)weakSelf.view).onPulseDetected != nil) ((FLFibriCheckView*)weakSelf.view).onPulseDetected();
        });
    };
    
    self.fibrichecker.onPulseDetectionTimeExpired = ^{
        NSLog(@"Pulse Detection Time Expired");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onPulseDetectionTimeExpired"}];

            if(((FLFibriCheckView*)weakSelf.view).onPulseDetectionTimeExpired != nil) ((FLFibriCheckView*)weakSelf.view).onPulseDetectionTimeExpired();
        });
    };
    
    self.fibrichecker.onFingerDetectionTimeExpired = ^{
        NSLog(@"Finger Detection Time Expired");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onFingerDetectionTimeExpired"}];

            if(((FLFibriCheckView*)weakSelf.view).onFingerDetectionTimeExpired != nil) ((FLFibriCheckView*)weakSelf.view).onFingerDetectionTimeExpired();
        });
    };
    
    self.fibrichecker.onHeartBeat = ^(NSUInteger value) {
        NSLog(@"Heart Beat Detected: %lu", value);
        NSDictionary *data = @{@"heartRate":[NSNumber numberWithInteger:value]};
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onHeartBeat", @"heartRate" : [NSNumber numberWithInteger:value]}];
            
            if(((FLFibriCheckView*)weakSelf.view).onHeartBeat != nil) ((FLFibriCheckView*)weakSelf.view).onHeartBeat(data);
        });
    };
    
    self.fibrichecker.onTimeRemaining = ^(NSUInteger seconds) {
        NSLog(@"Time Remaining: %lu", seconds);
        NSDictionary *data = @{@"seconds":[NSNumber numberWithInteger:seconds]};
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onTimeRemaining", @"seconds" : [NSNumber numberWithInteger:seconds]}];
            
            if(((FLFibriCheckView*)weakSelf.view).onTimeRemaining != nil) ((FLFibriCheckView*)weakSelf.view).onTimeRemaining(data);
        });
    };
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
