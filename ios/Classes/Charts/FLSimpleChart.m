#import "FLSimpleChart.h"

@implementation FLSimpleChartFactory {
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
                                        arguments:(id _Nullable)args {
    NSLog(@"FLSimpleChartFactory createWithFrame");
  return [[FLSimpleChart alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

@end

@implementation FLSimpleChart{
    UIView *_view;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  NSLog(@"FLSimpleChart initWithFrame");
  
  self = [super init];
  if (self) {
    _view = [[UIView alloc] init];
    delta = 1;
    self.lineColor = [UIColor whiteColor];
    self.stepIncrement = 2.5;
    self.verticalOffset = 6;
  }
  return self;
}

- (UIView*)view {
  return _view;
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"FLSimpleChart drawRect");
  [self drawGraphArea];
  [self drawGraphLine];
}

-(void) drawGraphArea {
  NSLog(@"FLSimpleChart drawGraphArea");
  if (_points.count != 0) {
    float xpos = _view.bounds.size.width;
    float ypos = _view.bounds.size.height - ([[_points objectAtIndex:0] floatValue] - min + (delta / 1000)) * (_view.bounds.size.height / delta);
    float baseLine = _view.bounds.size.height;

    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.12 green:0.55 blue:0.58 alpha:1.0] CGColor]);

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
  NSLog(@"FLSimpleChart drawGraphLine");
  if (_points.count != 0) {
    float xpos = _view.bounds.size.width;
    float ypos = _view.bounds.size.height - ([[_points objectAtIndex:0] floatValue] - min + (delta / 1000)) * (_view.bounds.size.height / delta);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);

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
}

-(void) addPoint:(NSNumber *) newPoint {
    NSLog(@"FLSimpleChart addPoint");
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

- (void)dealloc {
  NSLog(@"FLSimpleChart dealloc");
  self.points = nil;
}

@end