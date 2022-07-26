#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "Measurement.h"

@protocol FibriCheckViewDelegate <NSObject>
- (void) fibriCheckViewDidSetSampleTime;
- (void) fibriCheckViewDidSetGrav;
- (void) fibriCheckViewDidSetFlash;
- (void) fibriCheckViewDidSetGyro;
- (void) fibriCheckViewDidSetAcc;
- (void) fibriCheckViewDidSetRotation;
- (void) fibriCheckViewDidSetMovementDetection;
- (void) fibriCheckViewDidSetFingerDetectionExpiryTime;
- (void) fibriCheckViewDidSetWaitForStartRecordingSignal;
- (void) stopCamera;
- (void) drawGraphPoint;
- (void) addPoint;
- (void) startMeasurement;
@end

@interface FLFibriCheckView : UIView {
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

@property (nonatomic, weak) id<FibriCheckViewDelegate> delegate;

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

@property (nonatomic, copy) void (^onFingerDetected)(void);
@property (nonatomic, copy) void (^onFingerRemoved)(void);
@property (nonatomic, copy) void (^onHeartBeat)(NSUInteger);
@property (nonatomic, copy) void (^onPulseDetected)(void);
@property (nonatomic, copy) void (^onCalibrationReady)(void);
@property (nonatomic, copy) void (^onPulseDetectionTimeExpired)(void);
@property (nonatomic, copy) void (^onFingerDetectionTimeExpired)(void);
@property (nonatomic, copy) void (^onMovementDetected)(void);
@property (nonatomic, copy) void (^onMeasurementStart)(void);
@property (nonatomic, copy) void (^onMeasurementFinished)(void);
@property (nonatomic, copy) void (^onMeasurementProcessed)(Measurement*);
@property (nonatomic, copy) void (^onSampleReady)(double, double);
@property (nonatomic, copy) void (^onTimeRemaining)(NSUInteger);

// @property (nonatomic, copy) RCTBubblingEventBlock onFingerDetected;
// @property (nonatomic, copy) RCTBubblingEventBlock onFingerRemoved;
// @property (nonatomic, copy) RCTBubblingEventBlock onSampleReady;
// @property (nonatomic, copy) RCTBubblingEventBlock onMeasurementStart;
// @property (nonatomic, copy) RCTBubblingEventBlock onMeasurementFinished;
// @property (nonatomic, copy) RCTBubblingEventBlock onMeasurementProcessed;
// @property (nonatomic, copy) RCTBubblingEventBlock onCalibrationReady;
// @property (nonatomic, copy) RCTBubblingEventBlock onMovementDetected;
// @property (nonatomic, copy) RCTBubblingEventBlock onPulseDetected;
// @property (nonatomic, copy) RCTBubblingEventBlock onPulseDetectionTimeExpired;
// @property (nonatomic, copy) RCTBubblingEventBlock onFingerDetectionTimeExpired;
// @property (nonatomic, copy) RCTBubblingEventBlock onHeartBeat;
// @property (nonatomic, copy) RCTBubblingEventBlock onTimeRemaining;

/*!
 *  Contains all the points currently displayed on the chart
 */
@property (nonatomic, retain) NSMutableArray *points;

-(void) addPoint:(NSNumber *) newPoint;

-(void) setGraphBackgroundColor:(UIColor *) graphBackgroundColor;

-(void) setGraphLineColor:(UIColor *)graphLineColor;

@end
