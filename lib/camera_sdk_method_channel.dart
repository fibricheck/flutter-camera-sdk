import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'camera_sdk_platform_interface.dart';

/// An implementation of [CameraSdkPlatform] that uses method channels.
class MethodChannelCameraSdk extends CameraSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('camera_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
