import 'package:flutter_test/flutter_test.dart';
import 'package:camera_sdk/camera_sdk.dart';
import 'package:camera_sdk/camera_sdk_platform_interface.dart';
import 'package:camera_sdk/camera_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCameraSdkPlatform 
    with MockPlatformInterfaceMixin
    implements CameraSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CameraSdkPlatform initialPlatform = CameraSdkPlatform.instance;

  test('$MethodChannelCameraSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCameraSdk>());
  });

  test('getPlatformVersion', () async {
    CameraSdk cameraSdkPlugin = CameraSdk();
    MockCameraSdkPlatform fakePlatform = MockCameraSdkPlatform();
    CameraSdkPlatform.instance = fakePlatform;
  
    expect(await cameraSdkPlugin.getPlatformVersion(), '42');
  });
}
