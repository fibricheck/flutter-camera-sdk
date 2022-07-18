import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'camera_sdk_method_channel.dart';

abstract class CameraSdkPlatform extends PlatformInterface {
  /// Constructs a CameraSdkPlatform.
  CameraSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static CameraSdkPlatform _instance = MethodChannelCameraSdk();

  /// The default instance of [CameraSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelCameraSdk].
  static CameraSdkPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CameraSdkPlatform] when
  /// they register themselves.
  static set instance(CameraSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
