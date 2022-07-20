#import "CameraSdkPlugin.h"
#import "FLFibriCheckViewController.h"
#import "FLFibriCheckViewController.m"

@implementation CameraSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"camera_sdk"
            binaryMessenger:[registrar messenger]];
  CameraSdkPlugin* instance = [[CameraSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
      FLFibriCheckViewControllerFactory* flFibriCheckViewControllerFactory =
    [[FLFibriCheckViewControllerFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:flFibriCheckViewControllerFactory withId:@"FLFibriCheckViewController"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end