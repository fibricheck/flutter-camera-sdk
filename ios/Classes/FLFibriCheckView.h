#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

@interface FLFibriCheckViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

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

@interface FLFibriCheckView : NSObject <FlutterPlatformView> {
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

@property (nonatomic) NSInteger stepIncrement;
@property (nonatomic) NSInteger verticalOffset;
@property (weak, nonatomic) UIColor *lineColor;
@property (weak, nonatomic) UIColor *graphBackgroundColor;
@property (nonatomic) NSInteger lineThickness;

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

@end