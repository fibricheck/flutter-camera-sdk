#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "Measurement.h"

@interface FLFibriCheckView : UIView {
  float min;
  float max;
  float delta;
  int index;
}

- (UIView*)view;

@property (nonatomic) NSInteger *sampleTime;
@property (nonatomic) BOOL flashEnabled;
@property (nonatomic) BOOL gravEnabled;
@property (nonatomic) BOOL gyroEnabled;
@property (nonatomic) BOOL accEnabled;
@property (nonatomic) BOOL rotationEnabled;
@property (nonatomic) BOOL movementDetectionEnabled;
@property (nonatomic) NSInteger *fingerDetectionExpiryTime;
@property (nonatomic) NSInteger *waitForStartRecordingSignal;
@property (nonatomic) BOOL drawGraph;
@property (nonatomic) BOOL drawBackground;

@property (nonatomic) NSInteger stepIncrement;
@property (nonatomic) NSInteger verticalOffset;
@property (weak, nonatomic) UIColor *lineColor;
@property (nonatomic) NSInteger lineThickness;

/*!
 *  Contains all the points currently displayed on the chart
 */
@property (nonatomic, retain) NSMutableArray *points;

-(void) addPoint:(NSNumber *) newPoint;

-(void) setGraphBackgroundColor:(UIColor *) graphBackgroundColor;

-(void) setGraphLineColor:(UIColor *)graphLineColor;

@end
