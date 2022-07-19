#import "FLFibriCheckView.h"

@implementation FLFibriCheckViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    NSLog(@"FLFibriCheckViewFactory createWithFrame");
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    NSLog(@"FLFibriCheckViewFactory createWithFrame: %@", NSStringFromCGRect(frame));
  return [[FLFibriCheckView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

@end

@implementation FLFibriCheckView{
    UIView *_view;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  NSLog(@"FLFibriCheckView initWithFrame: %@", NSStringFromCGRect(frame));
  self = [super init];
  if (self) {
    _view = [[UIView alloc] initWithFrame:frame];
    delta = 1;
    self.stepIncrement = 2.5;
    self.verticalOffset = 6;

    if(self.graphBackgroundColor) {
      [self drawGraphArea];
    }
    [self drawGraphLine];
  }
  return self;
}

- (UIView*)view {
  return _view;
}

- (void)didSetProps:(NSArray<NSString *> *)changedProps {
    NSLog(@"FLFibriCheckView didSetProps");
    [self.delegate startMeasurement];
}

- (void)drawRect:(CGRect)rect {
  NSLog(@"FLFibriCheckView drawRect");
  if(self.graphBackgroundColor) {
    [self drawGraphArea];
  }
  [self drawGraphLine];
}

-(void) drawGraphArea {
  NSLog(@"FLFibriCheckView drawGraphArea");
  if (_points.count != 0) {
    float xpos = _view.bounds.size.width;
    float ypos = _view.bounds.size.height - ([[_points objectAtIndex:0] floatValue] - min + (delta / 1000)) * (_view.bounds.size.height / delta);
    float baseLine = _view.bounds.size.height;
    unsigned int integer = 0;

    CGContextRef context=UIGraphicsGetCurrentContext();

    NSScanner *scanner = [NSScanner scannerWithString:self.graphBackgroundColor];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&integer];
    UIColor *color = [UIColor colorWithRed:((CGFloat) ((integer & 0xFF0000) >> 16))/255
                                             green:((CGFloat) ((integer & 0xFF00) >> 8))/255
                                              blue:((CGFloat) (integer & 0xFF))/255
                                             alpha:1];

    CGContextSetFillColorWithColor(context, color.CGColor);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, xpos, baseLine);
    CGContextAddLineToPoint(context, xpos, ypos);

    for (int i = 1; i < _points.count; i++) {
      xpos -= _stepIncrement;
      ypos = [[_points objectAtIndex:i] floatValue];

      CGFloat graphPoint = (ypos - min + (delta / 1000)) * (_view.bounds.size.height / delta);
      CGContextAddLineToPoint(context, xpos, _view.bounds.size.height - graphPoint);
    };

    CGContextAddLineToPoint(context, xpos - _stepIncrement, baseLine);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
  }
}

-(void) drawGraphLine {
  NSLog(@"FLFibriCheckView drawGraphLine points: %@", _points);

  if (_points.count != 0) {
    float xpos = _view.bounds.size.width;
    float ypos = _view.bounds.size.height - ([[_points objectAtIndex:0] floatValue] - min + (delta / 1000)) * (_view.bounds.size.height / delta);
    unsigned int integer = 0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineThickness / 4);

    NSScanner *scanner = [NSScanner scannerWithString:self.lineColor];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&integer];
    UIColor *color = [UIColor colorWithRed:((CGFloat) ((integer & 0xFF0000) >> 16))/255
                                             green:((CGFloat) ((integer & 0xFF00) >> 8))/255
                                              blue:((CGFloat) (integer & 0xFF))/255
                                             alpha:1];
    CGContextSetStrokeColorWithColor(context, color.CGColor);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, xpos, ypos);

    for (int i = 1; i < _points.count; i++) {
      xpos -= _stepIncrement;
      ypos = [[_points objectAtIndex:i] floatValue];

      CGFloat graphPoint = (ypos - min + (delta / 1000)) * (_view.bounds.size.height / delta);
      CGContextAddLineToPoint(context, xpos, _view.bounds.size.height - graphPoint);
    };

    CGContextStrokePath(context);
  }
    NSLog(@"FLFibriCheckView drawGraphLine finished");
}

-(void) addPoint:(NSNumber *) newPoint {
  NSLog(@"FLFibriCheckView addPoint");
  if (!_points) _points = [[NSMutableArray alloc] init];
  [_points insertObject:newPoint atIndex:0];
  while (_points.count > _view.bounds.size.width / _stepIncrement) {
    [_points removeLastObject];
  }
  min = 1000;
  max = -1000;
  for (int i = 1; i < _points.count; i++) {
    if ([[_points objectAtIndex:i] floatValue] < min) {
      min = [[_points objectAtIndex:i] floatValue];
    } else if([[_points objectAtIndex:i] floatValue] > max) {
      max = [[_points objectAtIndex:i] floatValue];
    }
  }

  min -= _verticalOffset;
  max += _verticalOffset;

  delta = max - min;
  if (delta == 0 ) {
    delta = 1;
  }
}

- (void)setSampleTime:(NSInteger *)sampleTime {
    NSLog(@"FLFibriCheckView setSampleTime");
    _sampleTime = sampleTime;
    [self.delegate fibriCheckViewDidSetSampleTime];
}

- (void)setFlashEnabled:(BOOL)flashEnabled {
    NSLog(@"FLFibriCheckView setFlashEnabled");
    _flashEnabled = flashEnabled;
    [self.delegate fibriCheckViewDidSetFlash];
}

- (void)setGravEnabled:(BOOL)gravEnabled {
    NSLog(@"FLFibriCheckView setGravEnabled");
    _gravEnabled = gravEnabled;
    [self.delegate fibriCheckViewDidSetGrav];
}

- (void)setGyroEnabled:(BOOL)gyroEnabled {
    NSLog(@"FLFibriCheckView setGyroEnabled");
    _gyroEnabled = gyroEnabled;
    [self.delegate fibriCheckViewDidSetGyro];
}

- (void)setAccEnabled:(BOOL)accEnabled {
    NSLog(@"FLFibriCheckView setAccEnabled");
    _accEnabled = accEnabled;
    [self.delegate fibriCheckViewDidSetAcc];
}

- (void)setRotationEnabled:(BOOL)rotationEnabled {
    NSLog(@"FLFibriCheckView setRotationEnabled");
    _rotationEnabled = rotationEnabled;
    [self.delegate fibriCheckViewDidSetRotation];
}

- (void)setMovementDetectionEnabled:(BOOL)movementDetectionEnabled {
    NSLog(@"FLFibriCheckView setMovementDetectionEnabled");
    _movementDetectionEnabled = movementDetectionEnabled;
    [self.delegate fibriCheckViewDidSetMovementDetection];
}

- (void)setFingerDetectionExpiryTime:(NSInteger *)fingerDetectionExpiryTime {
    NSLog(@"FLFibriCheckView setFingerDetectionExpiryTime");
    _fingerDetectionExpiryTime = fingerDetectionExpiryTime;
    [self.delegate fibriCheckViewDidSetFingerDetectionExpiryTime];
}

- (void)setWaitForStartRecordingSignal:(NSInteger *)waitForStartRecordingSignal {
    NSLog(@"FLFibriCheckView setWaitForStartRecordingSignal");
    _waitForStartRecordingSignal = waitForStartRecordingSignal;
    [self.delegate fibriCheckViewDidSetWaitForStartRecordingSignal];
}

- (void)dealloc {
  self.points = nil;
}


@end