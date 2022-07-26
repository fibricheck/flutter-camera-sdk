#include "FLFibriCheckStreamHandler.h"
@implementation FLFibriCheckStreamHandler{
    FlutterEventSink _eventSink;
}

- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events {
    _eventSink = events;
    return nil;
}

- (void)send:(NSDictionary *)event {
    if (_eventSink) {
        _eventSink(event);
    }
}

- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}

@end
