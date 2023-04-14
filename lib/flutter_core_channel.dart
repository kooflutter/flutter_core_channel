
import 'flutter_core_channel_platform_interface.dart';

class FlutterCoreChannel {
  Future<String?> getPlatformVersion() {
    return FlutterCoreChannelPlatform.instance.getPlatformVersion();
  }
}
