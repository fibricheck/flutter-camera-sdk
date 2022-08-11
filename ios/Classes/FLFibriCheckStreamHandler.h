#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>

@interface FLFibriCheckStreamHandler : NSObject<FlutterStreamHandler>
- (void)send:(NSDictionary *)event;
@end
