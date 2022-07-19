#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

@interface FLSimpleChartFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

@interface FLSimpleChart : NSObject <FlutterPlatformView> {
  float min;
  float max;
  float delta;
  int index;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;

@property (nonatomic) NSInteger sampleTime;

@property (nonatomic) NSInteger stepIncrement;

@property (nonatomic) NSInteger verticalOffset;

@property (weak, nonatomic) UIColor *lineColor;
/*!
 *  Contains all the points currently displayed on the chart
 */
@property (nonatomic, retain) NSMutableArray *points;

-(void) addPoint:(NSNumber *) newPoint;

@end