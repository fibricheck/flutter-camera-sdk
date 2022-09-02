#import "FLFibriCheckViewController.h"
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

// MARK: - UI
- (void)viewDidLoad {
    self.fibrichecker = [FLFibriChecker new];
    [self addListeners];
}

- (void)startMeasurement {
    [_fibrichecker startMeasurement];
}

- (void)stopMeasurement {
    [_fibrichecker stop];
}

- (void)loadView {
    FLFibriCheckView *customView = [[FLFibriCheckView alloc] init];
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
    __unsafe_unretained typeof(self) weakSelf = self;
    
    self.fibrichecker.onMeasurementStart = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onMeasurementStart"}];
        });
    };
    
    self.fibrichecker.onMeasurementFinished = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onMeasurementFinished"}];
        });
    };
    
    self.fibrichecker.onMeasurementProcessed = ^(Measurement* measurement){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *jsonData = [[measurement mapToJson] dataUsingEncoding:NSUTF8StringEncoding];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [_eventHandler send:@{@"eventType" : @"onMeasurementProcessed", @"measurement" : jsonString}];
        });
    };
    
    self.fibrichecker.onSampleReady = ^(double ppg, double raw) {
        BOOL drawGraph = ((FLFibriCheckView*)self.view).drawGraph;
        if(drawGraph) [weakSelf drawGraphPoint:ppg];
        NSDictionary *data = @{@"ppg":[NSNumber numberWithFloat:ppg], @"raw":[NSNumber numberWithFloat:raw]};
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onSampleReady", @"ppg" :[NSNumber numberWithFloat:ppg], @"raw" : [NSNumber numberWithFloat:raw]}];
        });
    };
    
    self.fibrichecker.onCalibrationReady = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onCalibrationReady"}];
        });
    };
    
    self.fibrichecker.onFingerRemoved = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onFingerRemoved"}];
        });
    };
    
    self.fibrichecker.onFingerDetected = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onFingerDetected"}];
        });
    };
    
    self.fibrichecker.onMovementDetected = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onMovementDetected"}];
        });
    };
    
    self.fibrichecker.onPulseDetected = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onPulseDetected"}];
        });
    };
    
    self.fibrichecker.onPulseDetectionTimeExpired = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onPulseDetectionTimeExpired"}];
        });
    };
    
    self.fibrichecker.onFingerDetectionTimeExpired = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onFingerDetectionTimeExpired"}];
        });
    };
    
    self.fibrichecker.onHeartBeat = ^(NSUInteger value) {
        NSDictionary *data = @{@"heartRate":[NSNumber numberWithInteger:value]};
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onHeartBeat", @"heartRate" : [NSNumber numberWithInteger:value]}];
        });
    };
    
    self.fibrichecker.onTimeRemaining = ^(NSUInteger seconds) {
        NSDictionary *data = @{@"seconds":[NSNumber numberWithInteger:seconds]};
        dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onTimeRemaining", @"seconds" : [NSNumber numberWithInteger:seconds]}];
        });
    };

    self.fibrichecker.onMeasurementError = ^(NSString* message) {
    dispatch_async(dispatch_get_main_queue(), ^{
            [_eventHandler send:@{@"eventType" : @"onMeasurementError", @"message" : message}];
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
