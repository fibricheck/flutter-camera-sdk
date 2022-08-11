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
  [registrar registerViewFactory:flFibriCheckViewControllerFactory withId:@"fibricheckview"];
}

@end