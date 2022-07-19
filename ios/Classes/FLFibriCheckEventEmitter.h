#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface FLFibriCheckEventEmitter : RCTEventEmitter <RCTBridgeModule>

+ (void)emitEventWithName:(NSString *)name andPayload:(NSDictionary *)payload;
+ (void)sendEventWithName:(NSString *)name withBody:(NSDictionary *)body;

@end