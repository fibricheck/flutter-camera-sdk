#import "CameraSdkPlugin.h"
#import "FLFibriCheckView.h"
#import "FLFibriCheckView.m"

@implementation CameraSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"camera_sdk"
            binaryMessenger:[registrar messenger]];
  CameraSdkPlugin* instance = [[CameraSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
      FLFibriCheckViewFactory* flFibriCheckViewFactory =
    [[FLFibriCheckViewFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:flFibriCheckViewFactory withId:@"FLFibriCheckView"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end