 #import "FLFibriCheckEventEmitter.h"

 @implementation FLFibriCheckEventEmitter

 - (NSArray<NSString *> *)supportedEvents {
   return @[@"heartBeat", @"sampleReady", @"onFingerDetected", @"pulseDetected", @"calibrationReady", @"measurementStart", @"measurementFinished", @"measurementProcessed", @"fingerRemoved", @"timeRemaining"];
 }

 - (void)startObserving {
   NSLog(@"-------- Starting to observe FEM --------");
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   for (NSString *notificationName in [self supportedEvents]) {
     [center addObserver:self
                selector:@selector(emitEventInternal:)
                    name:notificationName
                  object:nil];
   }
 }

 - (void)stopObserving {
   NSLog(@"-------- Stopping to observe FEM --------");
   [[NSNotificationCenter defaultCenter] removeObserver:self];
 }

 - (void)emitEventInternal:(NSNotification *)notification {
   NSLog(@"--------- Internal Event logged FEM -----------");
//    [self sendEventWithName:notification.name
//                       withBody:notification.userInfo];
 }

 + (void)emitEventWithName:(NSString *)name andPayload:(NSDictionary *)payload {
   NSLog(@"--------- External Event logged FEM -----------");
   [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                       object:self
                                                     userInfo:payload];
 }

 + (void)sendEventWithName:(NSString *)name withBody:(NSDictionary *)body {
     [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:body];
 }

 @end