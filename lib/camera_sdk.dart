
import 'camera_sdk_platform_interface.dart';

class CameraSdk {
  Future<String?> getPlatformVersion() {
    return CameraSdkPlatform.instance.getPlatformVersion();
  }
}
